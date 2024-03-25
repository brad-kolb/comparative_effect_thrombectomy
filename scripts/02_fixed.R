# fits fixed.stan to clean_data.csv

# load packages --------
library(cmdstanr)

# translate and compile stan model to c++ ---------
model <- cmdstan_model(here("models", 
                            "fixed.stan"))

# read in data and create data list that can be passed to cmdstanr -------
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 
dat <- list(J = nrow(data),
            n_c = data$n_c,
            r_c = data$r_c,
            n_t = data$n_t,
            r_t = data$r_t,
            estimate_posterior = 1,
            priors = 1
)

# run sampler using informed priors --------
fixed_informed <- model$sample(data = dat, 
                               chains = 4,
                               parallel_chains = 4,
                               save_warmup = TRUE,
                               refresh = 0)

# run sampler using improper priors ---------
dat$priors <- 0
fixed_improper <- model$sample(data = dat, 
                           chains = 4,
                           parallel_chains = 4,
                           save_warmup = TRUE,
                           refresh = 0)

# output summaries --------
# posterior for theta using informed prior
fixed_informed$summary(c("theta", "mean_y_obs", "mean_sigma_obs"))
# posterior for theta using improper prior
fixed_improper$summary(c("theta", "mean_y_obs", "mean_sigma_obs"))
# compared to fully pooling data and calculating y and sigma by hand
data %>% summarise(
  r_t = sum(r_t),
  n_t = sum(n_t),
  r_c = sum(r_c),
  n_c = sum(n_c)
) %>% 
  mutate(y = log(r_t / (n_t - r_t)) - log(r_c / (n_c - r_c)),
         sigma = ifelse(r_t == 0 | r_c == 0, # approximate standard error
                        NA_real_,
                        sqrt(1/r_t + 1/(n_t - r_t) + 1/r_c + 1/(n_c - r_c))
         )) %>% 
  select(y, sigma)

# save model fits ----------
