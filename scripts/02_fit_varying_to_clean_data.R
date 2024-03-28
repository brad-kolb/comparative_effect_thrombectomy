# fits varying.stan to clean_data.csv
# implements multiple sensitivity checks including:
# prior predictive simulation
# sensitivity of posterior to choice of prior
# sensitivity of posterior to empirically meaningful subsets of data

# load packages --------
library(cmdstanr)
library(posterior)

# specify functions for fitting Stan models using cmdstanr and posterior ----
make_dat <- function(df) {
  list <- with(df,
               list(J = NROW(J),
                    n_c = n_c,
                    r_c = r_c,
                    n_t = n_t,
                    r_t = r_t,
                    estimate_posterior = 1,
                    priors = 1))
  return(list)
}

fit_model <- function(data_list) {
  require(cmdstanr)
  require(posterior)
  fit <- model$sample(data = data_list, 
                      chains = 4,
                      parallel_chains = 4,
                      save_warmup = TRUE,
                      refresh = 0,
                      init = 0,
                      adapt_delta = 0.99) %>% 
    posterior::as_draws_df() 
  return(fit)
}

fit_model_with_priors <- function(data, prior_type) {
  dat <- make_dat(data)
  if (prior_type == "skeptical") {
    dat$priors <- 1
  } else if (prior_type == "diffuse") {
    dat$priors <- 0
  }
  fit <- fit_model(dat)
  return(fit)
}

# translate and compile stan model to c++ ---------
model <- cmdstan_model(here("models", 
                            "varying.stan"))

# read in data  -------
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 

# perform prior predictive simulation ----
prior_types <- c("skeptical", "diffuse")
dat <- make_dat(data)
dat$estimate_posterior <- 0

dat$priors <- 1
varying_pps_skeptical <- fit_model(dat)

dat$priors <- 0
varying_pps_diffuse <- fit_model(dat)

# define the data subsets and prior types for the model fits -------
subsets <- list(
  "full" = data,
  "large" = data %>% filter(K == 1),
  "early" = data %>% filter(K == 2),
  "late" = data %>% filter(K == 3),
  "basilar" = data %>% filter(K == 4)
)

# fit the model for each subset and prior type -------
model_fits <- lapply(subsets, function(subset_data) {
  setNames(lapply(prior_types, function(prior_type) {
    fit_model_with_priors(subset_data, prior_type)
  }), prior_types)
})
