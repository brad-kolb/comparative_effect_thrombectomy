# fits fixed.stan to clean_data.csv

# load packages --------
library(cmdstanr)

# translate and compile stan model to c++ ---------
model <- cmdstan_model(here("models", 
                            "fixed.stan"))

# read in data  -------

data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 

# create data list that can be passed to cmdstanr

dat <- with(data,
            list(J = NROW(J),
                 n_c = n_c,
                 r_c = r_c,
                 n_t = n_t,
                 r_t = r_t,
                 estimate_posterior = 1,
                 priors = 1))

# perform prior predictive simulation ----------
dat$estimate_posterior <- 0
fixed_pps <- model$sample(data = dat, 
                          chains = 4,
                          parallel_chains = 4,
                          save_warmup = TRUE,
                          refresh = 0)

# run sampler using informed priors --------
dat$estimate_posterior <- 1
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

params <- c("theta", "mean_y_obs", "mean_sigma_obs")

# posterior for theta using no data (prior predictive simulation)
fixed_pps$summary(params)

# posterior for theta using informed prior
fixed_informed$summary(params)

# posterior for theta using improper prior
fixed_improper$summary(params)

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

# subset the data by stroke type and refit models ---------

# large
data_large <- data %>% 
  filter(K == 1)

dat <- with(data_large,
            list(J = NROW(J),
                 n_c = n_c,
                 r_c = r_c,
                 n_t = n_t,
                 r_t = r_t,
                 estimate_posterior = 1,
                 priors = 1))

fixed_informed_large <- model$sample(data = dat, 
                               chains = 4,
                               parallel_chains = 4,
                               save_warmup = TRUE,
                               refresh = 0)

dat$priors <- 0
fixed_improper_large <- model$sample(data = dat, 
                               chains = 4,
                               parallel_chains = 4,
                               save_warmup = TRUE,
                               refresh = 0)

# early
data_early <- data %>% 
  filter(K == 2)

dat <- with(data_early,
            list(J = NROW(J),
                 n_c = n_c,
                 r_c = r_c,
                 n_t = n_t,
                 r_t = r_t,
                 estimate_posterior = 1,
                 priors = 1))

fixed_informed_early <- model$sample(data = dat, 
                                     chains = 4,
                                     parallel_chains = 4,
                                     save_warmup = TRUE,
                                     refresh = 0)

dat$priors <- 0
fixed_improper_early <- model$sample(data = dat, 
                                     chains = 4,
                                     parallel_chains = 4,
                                     save_warmup = TRUE,
                                     refresh = 0)
# late
data_late <- data %>% 
  filter(K == 3)

dat <- with(data_late,
            list(J = NROW(J),
                 n_c = n_c,
                 r_c = r_c,
                 n_t = n_t,
                 r_t = r_t,
                 estimate_posterior = 1,
                 priors = 1))

fixed_informed_late <- model$sample(data = dat, 
                                     chains = 4,
                                     parallel_chains = 4,
                                     save_warmup = TRUE,
                                     refresh = 0)

dat$priors <- 0
fixed_improper_late <- model$sample(data = dat, 
                                     chains = 4,
                                     parallel_chains = 4,
                                     save_warmup = TRUE,
                                     refresh = 0)

# basilar
data_basilar <- data %>% 
  filter(K == 4)

dat <- with(data_basilar,
            list(J = NROW(J),
                 n_c = n_c,
                 r_c = r_c,
                 n_t = n_t,
                 r_t = r_t,
                 estimate_posterior = 1,
                 priors = 1))

fixed_informed_basilar <- model$sample(data = dat, 
                                    chains = 4,
                                    parallel_chains = 4,
                                    save_warmup = TRUE,
                                    refresh = 0)

dat$priors <- 0
fixed_improper_basilar <- model$sample(data = dat, 
                                    chains = 4,
                                    parallel_chains = 4,
                                    save_warmup = TRUE,
                                    refresh = 0)

# compare refits on subset data to original fits on full data -----------

fixed_informed_large$summary(params)
fixed_informed_early$summary(params)
fixed_informed_late$summary(params)
fixed_informed_basilar$summary(params)
fixed_informed$summary(params)

