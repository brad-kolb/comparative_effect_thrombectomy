######### under construction ############

# fits fixed.stan to clean_data.csv
# implements multiple sensitivity checks including:
# prior predictive simulation
# sensitivity of posterior to choice of prior
# sensitivity of posterior to empirically meaningful subsets of data

# load packages --------
library(cmdstanr)
library(posterior)

# translate and compile stan model to c++ ---------
model <- cmdstan_model(here("models", 
                            "fixed.stan"))

# read in data  -------
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 

# perform prior predictive simulation ----
dat <- make_dat(data)
dat$estimate_posterior <- 0
fixed_pps <- fit_model(dat)

# define the data subsets and prior types for the model fits -------
subsets <- list(
  "full" = data,
  "large" = data %>% filter(K == 1),
  "early" = data %>% filter(K == 2),
  "late" = data %>% filter(K == 3),
  "basilar" = data %>% filter(K == 4)
)
prior_types <- c("informed", "improper")

# fit the model for each subset and prior type -------
model_fits <- lapply(subsets, function(subset_data) {
  setNames(lapply(prior_types, function(prior_type) {
    fit_model_with_priors(subset_data, prior_type)
  }), prior_types)
})

# run diagnostics --------
params <- c("theta")

rhat_values <- extract_rhats(subsets, prior_types, model_fits, params)
check_rhats(rhat_values)

bulk_ess_values <- extract_bulk_ess(subsets, prior_types, model_fits, params)
check_bulk_ess(bulk_ess_values)

# summarize the fits ------------
summaries <- lapply(names(subsets), function(subset_name) {
  lapply(prior_types, function(prior_type) {
    summarize_fit(model_fits[[subset_name]][[prior_type]], 
                  params, subset_name, "fixed", prior_type)
  })
})

# summarize the prior predictive simulation --------
summary_pps <- summarize_fit(fixed_pps, params, "pps", "fixed", "informed")

# combine the summaries into a single data frame ------
fixed_summary <- bind_rows(summary_pps, lapply(summaries, bind_rows))

# show the main results of interest ------
fixed_summary %>% filter(priors == "informed")

# show the results when using improper prior -----
fixed_summary %>% filter(priors == "improper")

# compare to fully pooling data and calculating y and sigma by hand ----
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
