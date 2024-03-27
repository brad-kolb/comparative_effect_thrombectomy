# functions for fitting Stan models using cmdstanr and posterior ----
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
  if (prior_type == "informed") {
    dat$priors <- 1
  } else if (prior_type == "improper") {
    dat$priors <- 0
  }
  fit <- fit_model(dat)
  return(fit)
}

# functions for summarizing fits -------
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

# functions for MCMC diagnostics --------
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
