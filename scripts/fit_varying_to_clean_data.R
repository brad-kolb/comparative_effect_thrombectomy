# fits varying.stan to clean_data.csv
# implements multiple sensitivity checks including:
# prior predictive simulation
# sensitivity of posterior to choice of prior
# sensitivity of posterior to empirically meaningful subsets of data

# load packages --------
library(cmdstanr)
library(posterior)

# translate and compile stan model to c++ ---------
model <- cmdstan_model(here("models", 
                            "varying.stan"))

# read in data  -------
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 

# perform prior predictive simulation ----
dat <- make_dat(data)
dat$estimate_posterior <- 0
varying_pps <- fit_model(dat)

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
params <- c("tau")

rhat_values <- extract_rhats(subsets, prior_types, model_fits, params)
check_rhats(rhat_values)

bulk_ess_values <- extract_bulk_ess(subsets, prior_types, model_fits, params)
check_bulk_ess(bulk_ess_values)

# summarize the fits ------------
params <- c("tau")
summaries <- lapply(names(subsets), function(subset_name) {
  lapply(prior_types, function(prior_type) {
    summarize_fit(model_fits[[subset_name]][[prior_type]], 
                  params, subset_name, "varying", prior_type)
  })
})

# summarize the prior predictive simulation --------
summary_pps <- summarize_fit(varying_pps, params, "pps", "varying", "informed")

# combine the summaries into a single data frame ------
varying_summary <- bind_rows(summary_pps, lapply(summaries, bind_rows))

# show the main results of interest ------
varying_summary %>% filter(priors == "informed")
