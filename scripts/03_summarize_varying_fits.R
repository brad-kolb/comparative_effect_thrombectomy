# summarize fits

# specify functions for summarizing fits -------
summarize_fit <- function(fit_df, parameters, data_type, model_type, prior_type) {
  require(posterior)
  df <- fit_df %>% 
    posterior::summarise_draws("median", "mad", 
                               "rhat", "ess_bulk", "ess_tail",
                               ~quantile(., probs = c(.025, .975)),
                               prob_pos = ~mean(.>0)) %>% 
    rename(low = '2.5%', high = '97.5%') %>% 
    filter(variable %in% parameters) %>% 
    mutate(data = data_type, model = model_type, priors = prior_type) 
  return(df)
}

# specify functions for MCMC diagnostics --------
# r_hat ------
# as total variance shrinks to the average within chain variance, r_hat approaches 1
# a heuristic for convergence of chains. not a test
extract_rhats <- function(subsets, prior_types, model_fits, params) {
  require(posterior)
  rhat_values <- mapply(
    function(subset_name, prior_type) {
      posterior::rhat(extract_variable_matrix(model_fits[[subset_name]][[prior_type]],
                                              variable = params))
    }, 
    subset_name = rep(names(subsets), each = length(prior_types)),
    prior_type = rep(prior_types, times = length(subsets)), 
    SIMPLIFY = FALSE)
  rhat_values <- set_names(rhat_values, 
                           paste(
                             rep(names(subsets), each = length(prior_types)), 
                             rep(prior_types, times = length(subsets)), 
                             sep = "_")
  )
  return(rhat_values)
}


check_rhats <- function(rhat_values, threshold = 1.01) {
  problematic_models <- list()
  
  for (model_name in names(rhat_values)) {
    rhat <- rhat_values[[model_name]]
    if (rhat > threshold) {
      problematic_models <- c(problematic_models, model_name)
    }
  }
  
  if (length(problematic_models) > 0) {
    warning("Rhat value exceeds threshold for the following models:\n",
            paste("- ", problematic_models, collapse = "\n"),
            "\nConsider running the chains for more iterations or checking the model convergence.")
  } else {
    message("Rhat values are within the acceptable range for all models.")
  }
}

# bulk_ess ------
extract_bulk_ess <- function(subsets, prior_types, model_fits, params) {
  require(posterior)
  bulk_ess <- mapply(
    function(subset_name, prior_type) {
      posterior::ess_bulk(extract_variable_matrix(model_fits[[subset_name]][[prior_type]],
                                                  variable = params))
    }, 
    subset_name = rep(names(subsets), each = length(prior_types)),
    prior_type = rep(prior_types, times = length(subsets)), 
    SIMPLIFY = FALSE)
  bulk_ess <- set_names(bulk_ess, 
                        paste(
                          rep(names(subsets), each = length(prior_types)), 
                          rep(prior_types, times = length(subsets)), 
                          sep = "_")
  )
  return(bulk_ess)
}

check_bulk_ess <- function(bulk_ess_values, threshold = 100) {
  problematic_models <- list()
  
  for (model_name in names(bulk_ess_values)) {
    bulk_ess <- bulk_ess_values[[model_name]]
    if (bulk_ess < threshold) {
      problematic_models <- c(problematic_models, model_name)
    }
  }
  
  if (length(problematic_models) > 0) {
    warning("Bulk ESS is less than the threshold for the following models:\n",
            paste("- ", problematic_models, collapse = "\n"),
            "\nConsider running the chains for more iterations or using a more efficient sampler.")
  } else {
    message("Bulk ESS is sufficient for all models.")
  }
}

# summarize estimates for mu ------------
params <- c("mu")

rhat_values <- extract_rhats(subsets, prior_types, model_fits, params)
check_rhats(rhat_values)

bulk_ess_values <- extract_bulk_ess(subsets, prior_types, model_fits, params)
check_bulk_ess(bulk_ess_values)

summary_pps_skeptical <- summarize_fit(
  varying_pps_skeptical, params, "pps", "varying", "skeptical")
summary_pps_diffuse <- summarize_fit(
  varying_pps_diffuse, params, "pps", "varying", "diffuse")

summaries <- lapply(names(subsets), function(subset_name) {
  lapply(prior_types, function(prior_type) {
    summarize_fit(model_fits[[subset_name]][[prior_type]], 
                  params, subset_name, "varying", prior_type)
  })
})

# combine the summaries into a single data frame ------
varying_summary <- bind_rows(summary_pps_skeptical,
                             summary_pps_diffuse,
                             lapply(summaries, bind_rows))

# show the main results of interest ------
varying_summary %>% filter(priors == "skeptical") %>% 
  select(-c("prob_pos", "rhat", "ess_bulk", "ess_tail"))

varying_summary %>% filter(priors == "diffuse") %>% 
  select(-c("prob_pos", "rhat", "ess_bulk", "ess_tail"))

# summarize estimates for tau ------------
params <- c("tau")

rhat_values <- extract_rhats(subsets, prior_types, model_fits, params)
check_rhats(rhat_values)

bulk_ess_values <- extract_bulk_ess(subsets, prior_types, model_fits, params)
check_bulk_ess(bulk_ess_values)

summary_pps_skeptical <- summarize_fit(
  varying_pps_skeptical, params, "pps", "varying", "skeptical")
summary_pps_diffuse <- summarize_fit(
  varying_pps_diffuse, params, "pps", "varying", "diffuse")

summaries <- lapply(names(subsets), function(subset_name) {
  lapply(prior_types, function(prior_type) {
    summarize_fit(model_fits[[subset_name]][[prior_type]], 
                  params, subset_name, "varying", prior_type)
  })
})

# combine the summaries into a single data frame ------
varying_summary <- bind_rows(summary_pps_skeptical,
                             summary_pps_diffuse,
                             lapply(summaries, bind_rows))

# show the main results of interest ------
varying_summary %>% filter(priors == "skeptical") %>% 
  select(-c("prob_pos", "rhat", "ess_bulk", "ess_tail"))

varying_summary %>% filter(priors == "diffuse") %>% 
  select(-c("prob_pos", "rhat", "ess_bulk", "ess_tail"))

