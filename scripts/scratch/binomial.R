# packages
library(here)
library(tidyverse)
library(cmdstanr)
library(posterior)
library(cowplot)

# options
# theme_set(new = theme_minimal() +
#             theme(
#               panel.grid.major.y = element_blank(),
#               panel.grid.minor.y = element_blank(),
#               panel.grid.major.x = element_blank(),
#               panel.grid.minor.x = element_blank(),
#               axis.line.y = element_blank(),
#               axis.text.y = element_blank(),
#               axis.ticks.y = element_blank(),
#               axis.title.y = element_blank()
#             ))


# options
options(dplyr.print_max = 50)



# fit model
data <- read_csv(file = here("data", "clean_data.csv")) %>% 
  mutate(J = as.integer(J), K = as.integer(K)) %>% 
  filter(K == 1) %>% 
  select(K, n_c, r_c, n_t, r_t) %>% 
  mutate(j = row_number()) %>% 
  pivot_longer(cols = starts_with(c("n_", "r_")), 
               names_to = c(".value", "arm"), 
               names_sep = "_") %>%
  mutate(arm = ifelse(arm == "c", 0, 1)) %>%
  mutate(l = row_number()) %>% 
  select(j, l, k = K, n, y = r, x = arm) 

dat <- with(data,
            list(L = length(l),
                 J = length(unique(j)),
                 K = length(unique(k)),
                 jj = j,
                 ll = l,
                 x = x,
                 n = n,
                 y = y,
                 estimate_posterior = 1, 
                 priors = 1))

model <- cmdstan_model(here("models", "binomial.stan"))

fit <- model$sample(data = dat, seed = 222, chains = 4, 
                    parallel_chains = 4, save_warmup = TRUE, refresh = 1000)

# rhat should not in general exceed 1.01 for each parameter
map(c("rho", "sigma", "mu", "tau"), 
    function(params) {
      posterior::rhat(extract_variable_matrix(fit, variable = params))
    }
)

# bulk ESS should in general exceed 100 for each parameter
map(c("rho", "sigma", "mu", "tau"), 
    function(params) {
      posterior::ess_bulk(extract_variable_matrix(fit, variable = params))
    }
)

# generated quantities --------
model_gq <- cmdstan_model(here("models", "binomial_gq.stan"))

fit_gq <- model_gq$generate_quantities(fit, data = dat, seed = 123)

# results -----------------

theme_set(new = cowplot::theme_cowplot(font_size = 12) +
            theme(axis.ticks.y = element_blank(),
                  axis.text.y = element_blank(),
                  axis.line.y = element_blank()))

# parameter estimates
draws <- as_draws_matrix(fit$draws())
bayesplot::mcmc_areas_ridges(draws, pars = "rho", regex_pars = "phi", border_size = 0.1, prob = .5, prob_outer = .95) +
  ggtitle("Baseline log odds")
bayesplot::mcmc_areas_ridges(draws, pars = "mu", regex_pars = "theta", border_size = 0.1, prob = .5, prob_outer = .95) +
  ggtitle("Change in log odds with treatment")

bayesplot::mcmc_areas_ridges(draws, pars = "rho", regex_pars = "mu", border_size = 0.1, prob = .95, prob_outer = .99) +
  ggtitle("Hyperparameter estimates")

draws <- as_draws_matrix(fit_gq$draws())
bayesplot::mcmc_intervals(draws, pars = "E_y_next_cont", regex_pars = "E_y_next_treat", border_size = 0.1, prob = .95, prob_outer = .99) +
  ggtitle("Next trial forecasts")

bayesplot::mcmc_areas_ridges(draws, pars = "arr_marg", regex_pars = "E_arr_next", prob = .9, prob_outer = .99) +
  ggtitle("Next trial forecasts")

bayesplot::mcmc_areas_ridges(draws, pars = "rr_marg", regex_pars = "E_rr_next", prob = .9, prob_outer = .99) +
  ggtitle("Next trial forecasts")

y_rep <- as_draws_matrix(fit_gq$draws("oddsratio"))
y <- data %>% 
  select(n, y) %>% 
  mutate(odds = y / (n - y)) %>% 
  mutate(trial = rep(1:length(unique(data$j)), each = 2)) %>%
  group_by(trial) %>%
  summarise(odds_ratio = odds[2] / odds[1]) %>% 
  deframe() 
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Study") +
  ylab("theta vs observed odds ratio") +
  coord_flip() +
  scale_y_log10(breaks = c(1, 3, 6),
                labels = c("1x", "2x", "5x")) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey")

# graphical posterior predictive check in terms of events
y_rep <- as_draws_matrix(fit_gq$draws("y_tilde"))
y <- data %>% 
  select(y) %>% 
  deframe()
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Arm") +
  ylab("Forecasted good outcome in repeat trial") +
  coord_flip()

# expected probability of outcome vs observed event rate
y_rep <- as_draws_matrix(fit_gq$draws("E_y_tilde"))
y_rep_control <- y_rep[, seq(1, ncol(y_rep), 2)]
y_rep_treatment <- y_rep[, seq(2, ncol(y_rep), 2)]

y <- data %>% 
  mutate(event_rate = y/n) %>% 
  select(event_rate) %>% 
  deframe()
y_control <- y[seq(1, length(y), 2)]
y_treatment <- y[seq(2, length(y), 2)]

# Create custom x-axis labels
x_labels <- c(0.0, 0.2, 0.4, 0.6, 0.8)

bayesplot::ppc_intervals(y_control, y_rep_control, prob_outer = .95) +
  scale_x_continuous("Trial") +
  scale_y_continuous(breaks = x_labels, labels = x_labels, limits = c(0, 1)) +
  ylab("Estimated probability vs observed event rate") +
  ggtitle("Control arms") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")


bayesplot::ppc_intervals(y_treatment, y_rep_treatment, prob_outer = .95) +
  scale_x_continuous("Trial") +
  scale_y_continuous(breaks = x_labels, labels = x_labels, limits = c(0, 1)) +
  ylab("Estimated probability vs observed event rate") +
  ggtitle("Treatment arms") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")


# expected absolute risk reduction vs observed 
y_rep <- as_draws_matrix(fit_gq$draws("E_arr_tilde"))
y <- data %>% 
  select(n, y) %>% 
  mutate(risk = y/n) %>% 
  mutate(trial = rep(1:length(unique(data$j)), each = 2)) %>%
  group_by(trial) %>%
  summarise(arr = risk[2] - risk[1]) %>% 
  deframe() 
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Study") +
  ylab("Absolute effect: expected vs observed") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")

# expected relative risk reduction vs observed
y_rep <- as_draws_matrix(fit_gq$draws("E_rr_tilde"))
y <- data %>% 
  select(n, y) %>% 
  mutate(risk = y/n) %>% 
  mutate(trial = rep(1:length(unique(data$j)), each = 2)) %>%
  group_by(trial) %>%
  summarise(arr = risk[2]/risk[1]) %>% 
  deframe() 
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Study") +
  ylab("Relative effect: expectation vs observed") +
  coord_flip() +
  scale_y_log10(breaks = c(1, 2, 3, 5),
                labels = c("1x", "1.5x", "2x", "4x")) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey")


# graphical posterior predictive check in terms of relative risks
y_rep <- as_draws_matrix(fit_gq$draws("rr_tilde"))
y <- data %>% 
  select(n, y) %>% 
  mutate(risk = y / n) %>% 
  mutate(trial = rep(1:length(unique(data$j)), each = 2)) %>%
  group_by(trial) %>%
  summarise(odds_ratio = risk[2] / risk[1]) %>% 
  deframe() 
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Study") +
  ylab("Observed relative treatment effect in repeat of trial") +
  coord_flip() +
  scale_y_log10(breaks = c(1, 3, 6, 11),
                labels = c("1x", "2x", "5x", "10x")) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey")

# graphical posterior predictive check in terms of absolute risks
y_rep <- as_draws_matrix(fit_gq$draws("arr_tilde"))
y <- data %>% 
  select(n, y) %>% 
  mutate(risk = y / n) %>% 
  mutate(trial = rep(1:length(unique(data$j)), each = 2)) %>%
  group_by(trial) %>%
  summarise(odds_ratio = risk[2] - risk[1]) %>% 
  deframe() 
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("Study") +
  ylab("Observed absolute treatment effect in repeat of trial") +
  coord_flip() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")

# tables ----------

observations <- read_csv(file = here("data", "clean_data.csv")) %>% 
  as_tibble() 

# trial level
observations %>% 
  reframe(arr_obs = r_t/n_t - r_c/n_c) %>% 
  mutate(arr_est = fit_gq$summary("E_arr_tilde")$median,
         arr_sd = fit_gq$summary("E_arr_tilde")$mad,
         arr_rep_est = fit_gq$summary("arr_tilde")$median,
         arr_rep_sd = fit_gq$summary("arr_tilde")$mad)

# summary level
# absolute
observations %>% 
  reframe(arr_obs = sum(r_t)/sum(n_t) - sum(r_c)/sum(n_c)) %>% 
  mutate(arr_marg_est = fit_gq$summary("arr_marg")$median,
         arr_marg_sd = fit_gq$summary("arr_marg")$mad,
         arr_next_est = fit_gq$summary("E_arr_next")$median,
         arr_next_sd = fit_gq$summary("E_arr_next")$mad)
# relative
observations %>% 
  reframe(rr_obs = (sum(r_t)/sum(n_t)) / (sum(r_c)/sum(n_c))) %>% 
  mutate(rr_marg_est = fit_gq$summary("rr_marg")$median,
         rr_marg_sd = fit_gq$summary("rr_marg")$mad,
         rr_next_est = fit_gq$summary("E_rr_next")$median,
         rr_next_sd = fit_gq$summary("E_rr_next")$mad)
