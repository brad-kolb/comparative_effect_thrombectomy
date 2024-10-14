# functions -------------
# fitting binomial model to multiple data sets using multiple prior specifications

make_data_frame <- function(clean_data) {
  data_frame <- clean_data %>% 
    mutate(id = as.integer(J), K = as.integer(K)) %>% 
    select(id, K, n_c, r_c, n_t, r_t, y, se) %>% 
    mutate(j = row_number()) %>% 
    pivot_longer(cols = starts_with(c("n_", "r_")), 
                 names_to = c(".value", "arm"), 
                 names_sep = "_") %>%
    mutate(arm = ifelse(arm == "c", 0, 1)) %>%
    mutate(l = row_number()) %>% 
    select(id, j, l, k = K, n, y = r, x = arm, y_hat = y, se_hat = se) 
  return(data_frame)
}

make_data_list <- function(data_frame) {
  data_list <- with(data_frame,
                    list(L = length(l),
                         J = length(unique(j)),
                         K = length(unique(k)),
                         jj = j,
                         ll = l,
                         kk = k,
                         x = x,
                         n = n,
                         y = y,
                         se_hat = unique(se_hat),
                         estimate_posterior = 1, 
                         priors = 1))
  return(data_list)
}

fit_model <- function(data_frame, prior_type, estimate_posterior) {
  require(cmdstanr)
  require(posterior)
  
  data_list <- make_data_list(data_frame)
  
  if (estimate_posterior == "yes") {
    data_list$estimate_posterior <- 1
  } else {data_list$estimate_posterior <- 0}
  
  if (prior_type == "skeptical") {
    data_list$priors <- 1
  } else if (prior_type == "diffuse") {
    data_list$priors <- 0
  }
  
  fit <- model$sample(data = data_list, 
                      seed = 312,
                      chains = 4,
                      parallel_chains = 4,
                      save_warmup = TRUE,
                      refresh = 0,
                      init = 0,
                      adapt_delta = 0.99) %>% 
    posterior::as_draws_df() 
  return(fit)
}

# checking inference
extract_rhats <- function(data_subsets, 
                          priors, 
                          fits, 
                          params) {
  require(posterior)
  rhat_values <- mapply(
    function(subset_name, prior_type) {
      posterior::rhat(extract_variable_matrix(fits[[subset_name]][[prior_type]],
                                              variable = params))
    }, 
    subset_name = rep(names(data_subsets), each = length(priors)),
    prior_type = rep(priors, times = length(data_subsets)), 
    SIMPLIFY = FALSE)
  rhat_values <- set_names(rhat_values, 
                           paste(
                             rep(names(data_subsets), each = length(priors)), 
                             rep(priors, times = length(data_subsets)), 
                             sep = "_")
  )
  return(rhat_values)
}

extract_ess <- function(data_subsets, 
                        priors, 
                        fits, 
                        params) {
  require(posterior)
  ess_values <- mapply(
    function(subset_name, prior_type) {
      posterior::ess_bulk(extract_variable_matrix(fits[[subset_name]][[prior_type]],
                                                  variable = params))
    }, 
    subset_name = rep(names(data_subsets), each = length(priors)),
    prior_type = rep(priors, times = length(data_subsets)), 
    SIMPLIFY = FALSE)
  ess_values <- set_names(ess_values, 
                          paste(
                            rep(names(data_subsets), each = length(priors)), 
                            rep(priors, times = length(data_subsets)), 
                            sep = "_")
  )
  return(ess_values)
}

# summarize inference
summarize_fit <- function(fit_df, data_type, model_type, prior_type) {
  require(posterior)
  df <- fit_df %>% 
    posterior::summarise_draws("median", "mad", 
                               "rhat", "ess_bulk",
                               ~quantile(., probs = c(.025, .975), na.rm = TRUE),
                               prob_pos = ~mean(.>0, na.rm = TRUE)) %>% 
    rename(low = '2.5%', high = '97.5%') %>% 
    mutate(data = data_type, model = model_type, priors = prior_type) 
  return(df)
}



library(cmdstanr)
library(posterior)
library(tidyverse)
library(here)
library(stringr)

options(tibble.print_max = 100, tibble.print_min = 100)


# fit model to data sets -----------

model <- cmdstan_model(here("models", 
                            "group.stan"))

data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)

prior_types <- c("skeptical", "diffuse")

dfs <- list(
  "all" = data %>% make_data_frame()
)


model_fits <- lapply(dfs, function(x) {
  setNames(lapply(prior_types, function(y) {
    fit_model(x, y, "yes")
  }), prior_types)
})

saveRDS(model_fits, file = here("fits", "group_fits.RDS"))

# perform prior predictive simulation ----
dat <- dfs$all

skeptical <- fit_model(dat, "skeptical", "no")

diffuse <- fit_model(dat, "diffuse", "no")

pps <- list(skeptical = skeptical, 
            diffuse = diffuse)

saveRDS(pps, file = here("fits", "group_pps.RDS"))

# check outputs ----
readRDS(here("fits", "group_fits.RDS")) %>% 
  str()
readRDS(here("fits", "group_pps.RDS")) %>% 
  str()

# check the inferences ----
hyper_params <- c("mu", "tau", "rho", "sigma")

mapply(function(x) {
  extract_rhats(dfs, prior_types, model_fits, x)
}, hyper_params)

mapply(function(x) {
  extract_ess(dfs, prior_types, model_fits, x)
}, hyper_params)

# summarize the inferences ----
summary_pps_skeptical <- summarize_fit(
  pps$skeptical, "pps", "group", "skeptical")
summary_pps_diffuse <- summarize_fit(
  pps$diffuse, "pps", "group", "diffuse")

summaries <- lapply(names(dfs), function(x) {
  lapply(prior_types, function(y) {
    summarize_fit(model_fits[[x]][[y]], x, 
                  "group", y)
  })
})

group_summaries <- bind_rows(summary_pps_skeptical,
                                summary_pps_diffuse,
                                lapply(summaries, bind_rows))

saveRDS(group_summaries, file = here("fits", "group_summaries.RDS"))

# graphical posterior predictive check ---- 
model_fits <- readRDS(here("fits", "group_fits.RDS"))

y_rep <- as_draws_matrix(
  model_fits$all$diffuse[, c("theta[1]", "theta[2]", "theta[3]", "theta[4]", "theta[5]",
                             "theta[6]", "theta[7]", "theta[8]", "theta[9]", "theta[10]",
                             "theta[11]", "theta[12]", "theta[13]", "theta[14]", "theta[15]",
                             "theta[16]", "theta[17]", "theta[18]", "theta[19]", "theta[20]",
                             "theta[21]", "theta[22]")])
y <- data %>%
  select(y) %>%
  deframe()
bayesplot::ppc_intervals(y, y_rep, prob_outer = .95) +
  scale_x_continuous("trial") +
  ylab("log odds ratio") +
  coord_flip()

# compare parameter values --------
varying_summary <- readRDS(here("fits", "varying_summary.RDS"))
group_summaries <- readRDS(here("fits", "group_summaries.RDS"))
binomial_summaries <- readRDS(here("fits", "binomial_summaries.RDS")) 

varying_summary %>% 
  filter(variable == "mu", priors == "diffuse")

varying_summary %>% 
  filter(variable == "theta_new", priors == "diffuse")

binomial_summaries %>% 
  filter(str_detect(variable, "^mu"), priors == "diffuse")

binomial_summaries %>% 
  filter(str_detect(variable, "^E_theta_next"), priors == "diffuse")

group_summaries %>% 
  filter(str_detect(variable, "^E_rd"), data == "all", priors == "diffuse")

group_summaries %>% 
  filter(str_detect(variable, "^E_rr"),  data == "all", priors == "diffuse")

# forest plot -----

library(cowplot)

data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)

summary <- readRDS(file = here("fits", "group_summaries.RDS"))

# theme_set(new = cowplot::theme_cowplot(font_size = 11))

plot_or <- function(x, y, z, w){
  df1 <- x %>%
    filter(model == y,
           data == z,
           str_detect(variable, "^theta\\[")) %>%
    mutate(trial = c(w, w)) %>% 
    relocate(trial, .after = variable) %>% 
    select("priors", "trial", "median", "low", "high")
  
  df2 <- x %>% 
    filter(model == y,
           data == z,
           variable == "E_theta_new") %>% 
    mutate(trial = "NEW") %>% 
    select("priors", "trial", "median", "low", "high")
  
  df <- bind_rows(df1, df2)
  df$trial <- factor(df$trial, levels = c(unique(df1$trial), "NEW"))
  df$trial <- fct_rev(df$trial)
  
  ggplot(df, aes(x = trial, y = median, ymin = low, ymax = high, color = priors)) +
    geom_pointrange(position = position_dodge(width = 0.5)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    coord_flip(ylim = c(-0.5, 2.0)) +
    labs(x = NULL, y = "log odds", 
         title = NULL,
         color = "Priors", shape = "Priors") +
    scale_color_manual(values = c("skeptical" = "blue", "diffuse" = "red")) +
    scale_shape_manual(values = c("skeptical" = 16, "diffuse" = 17)) +
    theme_minimal_hgrid(font_size = 10)
}

trials <- c("angel", "rescue", "select2", "tension", "tesla",
            "escape", "extend", "mrclean", "piste", "resilient", "revascat","swift", "therapy", "thrace",
            "dawn", "defuse3", "mrcleanlate", "positive",
            "attention", "baoche", "basics", "best")


p1 <- plot_or(summary, "group", "all", trials)
