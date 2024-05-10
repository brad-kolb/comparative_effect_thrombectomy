# packages
library(here)
library(tidyverse)
library(cmdstanr)
library(posterior)

# options
options(dplyr.print_max = 50)

# fit model
data <- read_csv(file = here("data", "clean_data.csv")) %>% 
  mutate(J = as.integer(J), K = as.integer(K))

dat <- data %>% 
  select(K, n_c, r_c, n_t, r_t) %>% 
  pivot_longer(cols = starts_with(c("n_", "r_")), 
               names_to = c(".value", "arm"), 
               names_sep = "_") %>%
  mutate(arm = ifelse(arm == "c", 0, 1)) %>%
  mutate(j = row_number()) %>% 
  select(j, k = K, n, y = r, x = arm)

dat <- with(dat,
            list(J = length(unique(j)),
                 K = length(unique(k)),
                 N = length(j),
                 j = j,
                 k = k,
                 n = n,
                 x = x,
                 y = y,
                 estimate_posterior = 1, 
                 priors = 1))

model <- cmdstan_model(here("models", "probit_binomial.stan"))

fit <- model$sample(data = dat, seed = 123, chains = 4, 
                    parallel_chains = 4, save_warmup = TRUE, refresh = 1000)

# perform inference on the fitted parameter values
model_gq <- cmdstan_model(here("models", "probit_binomial_gq.stan"))

fit_gq <- model_ppc$generate_quantities(fit, data = dat, seed = 123)

# trial level
data %>% 
  reframe(arr_obs = r_t/n_t - r_c/n_c) %>% 
  mutate(arr_est = fit_gq$summary("arr")$mean,
         arr_sd = fit_gq$summary("arr")$sd,
         arr_rep_est = fit_gq$summary("arr_tilde")$mean,
         arr_rep_sd = fit_gq$summary("arr_tilde")$sd)

# summary level
data %>% 
  group_by(K) %>% 
  reframe(arr_obs = sum(r_t)/sum(n_t) - sum(r_c)/sum(n_c)) %>% 
  mutate(arr_av_est = fit_gq$summary("arr_av")$mean,
         arr_av_sd = fit_gq$summary("arr_av")$sd,
         arr_next_est = fit_gq$summary("arr_next")$mean,
         arr_next_sd = fit_gq$summary("arr_next")$sd)

# graphical posterior predictive check
y_rep <- as_draws_matrix(fit_gq$draws("arr_tilde"))
y <- data %>% 
  reframe(arr_obs = r_t/n_t - r_c/n_c) %>% 
  deframe()
bayesplot::ppc_intervals(y, y_rep) +
  scale_x_continuous("Study") +
  ylab("Absolute risk reduction") +
  coord_flip()
