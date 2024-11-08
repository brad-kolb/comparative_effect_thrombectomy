# define helper functions and load packages ------------

### functions
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

### libraries 
library(cmdstanr)
library(posterior)
library(tidyverse)
library(here)
library(stringr)
library(cowplot)
options(tibble.print_max = 100, tibble.print_min = 100)

# fit the model -----------
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



# do prior predictive simulations -------
dat <- dfs$all
skeptical <- fit_model(dat, "skeptical", "no")
diffuse <- fit_model(dat, "diffuse", "no")
pps <- list(skeptical = skeptical, 
            diffuse = diffuse)
saveRDS(pps, file = here("fits", "group_pps.RDS"))
# check outputs 
readRDS(here("fits", "group_pps.RDS")) %>% 
  str()

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


# check diagnostics ------
# inspect variables
readRDS(here("fits", "group_fits.RDS")) %>% 
  str()
# get rhats and ess
hyper_params <- c("mu", "tau", "rho", "sigma")
mapply(function(x) {
  extract_rhats(dfs, prior_types, model_fits, x)
}, hyper_params)
mapply(function(x) {
  extract_ess(dfs, prior_types, model_fits, x)
}, hyper_params)

# check sensitivity to alternative prior specifications ----
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)
summary <- readRDS(file = here("fits", "group_summaries.RDS"))
# theme_set(new = cowplot::theme_cowplot(font_size = 10))
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
    labs(x = NULL, y = "odds ratio (log scale)", 
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
plot_or(summary, "group", "all", trials)
# check model by comparing hyperparameter values from simpler models--------
varying_summary <- readRDS(here("fits", "varying_summary.RDS"))
group_summaries <- readRDS(here("fits", "group_summaries.RDS"))
binomial_summaries <- readRDS(here("fits", "binomial_summaries.RDS")) 

x1 <- varying_summary %>% 
  filter(variable == "mu", priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(2)


x2 <- binomial_summaries %>% 
  filter(str_detect(variable, "^mu"), priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(2)

x3 <- group_summaries %>% 
  filter(str_detect(variable, "^mu"), data == "all", priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(1)

rbind(x1,x2,x3) %>% 
  mutate(model = c("norm_approx", "binomial", "binomial_baserate"),
         variable = "mu")

x1 <- varying_summary %>% 
  filter(variable == "sigma", priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(2)


x2 <- binomial_summaries %>% 
  filter(str_detect(variable, "^tau"), priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(2)

x3 <- group_summaries %>% 
  filter(str_detect(variable, "^tau"), data == "all", priors == "diffuse") %>% 
  select(median, mad) %>% 
  slice(1)

rbind(x1,x2,x3) %>% 
  mutate(model = c("norm_approx", "binomial", "binomial_baserate"),
         variable = "tau")

# check model by doing graphical posterior predictive checks ---- 
dat <- make_data_list(dfs$all)
model <- as_draws_array(model_fits$all$diffuse)
gq1 <- cmdstan_model(here("models", "group_gq1.stan"))
gq1 <- gq1$generate_quantities(model, data = dat, seed = 123)
saveRDS(gq1, file = here("fits", "gq1.RDS"))
df <- gq1 %>% 
  posterior::summarise_draws("median", "mad", 
                             "rhat", "ess_bulk",
                             ~quantile(., probs = c(.05, .95), na.rm = TRUE)) %>% 
  rename(low = '5%', high = '95%') 
saveRDS(df, file = here("fits", "gq1_summary.RDS"))



# by replicating trial
y_rep <- as_draws_matrix(gq1$draws(paste0("rr_erep[", 1:22, "]")))
y <- data %>%
  mutate(rr_obs = (r_t*n_c)/(n_t*r_c)) %>% 
  select(rr_obs) %>%
  deframe()

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(breaks = 1:22) +
  scale_y_continuous(
    trans = "log",  # Use log transformation
    breaks = c(0.5, 1, 2, 5, 10),  # Custom breaks that make sense on log scale
    limits = c(0.5, 10)
  ) +
  ylab("risk ratio") +
  xlab("trial") +
  cowplot::theme_cowplot(font_size = 10) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey")

# by simulating future trial
y_rep <- as_draws_matrix(gq1$draws(paste0("rr_epred[", 1:4, "]")))
y <- data %>%
  group_by(K) %>%
  summarize(
    n_c_sum = sum(n_c),
    r_c_sum = sum(r_c),
    n_t_sum = sum(n_t),
    r_t_sum = sum(r_t)
  ) %>%
  mutate(rr_obs = (r_t_sum * n_c_sum)/(n_t_sum * r_c_sum)) %>%
  select(rr_obs) %>%
  deframe()

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(breaks = 1:22) +
  scale_y_continuous(
    trans = "log",  # Use log transformation
    breaks = c(0.5, 1, 2, 5, 10),  # Custom breaks that make sense on log scale
    limits = c(0.5, 10)
  ) +
  ylab("risk ratio") +
  xlab("stroke type") +
  # coord_flip() +
  cowplot::theme_cowplot(font_size = 10) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "grey")

# risk difference
y_rep <- as_draws_matrix(gq1$draws(paste0("rd_erep[", 1:22, "]")))
y <- data %>%
  mutate(rd_obs = (r_t/n_t) - (r_c/n_c)) %>% 
  select(rd_obs) %>%
  deframe()

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(breaks = 1:22) +
  # scale_y_continuous(
  #   trans = "log",  # Use log transformation
  #   breaks = c(0.5, 1, 2, 5, 10),  # Custom breaks that make sense on log scale
  #   limits = c(0.5, 10)
  # ) +
  ylab("risk difference") +
  xlab("trial") +
  # coord_flip() +
  cowplot::theme_cowplot(font_size = 10) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")

# by simulating future trial
y_rep <- as_draws_matrix(gq1$draws(paste0("rd_epred[", 1:4, "]")))
y <- data %>%
  group_by(K) %>%
  summarize(
    n_c_sum = sum(n_c),
    r_c_sum = sum(r_c),
    n_t_sum = sum(n_t),
    r_t_sum = sum(r_t)
  ) %>%
  mutate(rd_obs = (r_t_sum/n_t_sum) - (r_c_sum/n_c_sum)) %>%
  select(rd_obs) %>%
  deframe()

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(breaks = 1:22) +
  scale_y_continuous(
  #   trans = "log",  # Use log transformation
     breaks = c(0, .1, .2, .3, .4),  # Custom breaks that make sense on log scale
     limits = c(0, .4)
  ) +
  ylab("risk difference") +
  xlab("stroke type") +
  # coord_flip() +
  cowplot::theme_cowplot(font_size = 10) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey")

# traditional forest plot with illusion of predictability -----
model_fits <- readRDS(here("fits", "group_fits.RDS"))
y_rep <- as_draws_matrix(model_fits$all$diffuse[, paste0("theta[", 1:22, "]")])
av <- draws_matrix(mu = model_fits$all$diffuse$mu)
y_rep <- cbind(av, y_rep)
y <- data %>%
  select(y) %>%
  deframe()
naive_av <- mean(y)
y <- c(naive_av, y)
trials <- c("AVERAGE", "angel", "rescue", "select2", "tension", "tesla",
            "escape", "extend", "mrclean", "piste", "resilient", "revascat","swift", "therapy", "thrace",
            "dawn", "defuse3", "mrcleanlate", "positive",
            "attention", "baoche", "basics", "best")

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(labels = trials, breaks = 1:length(trials)) +
  ylab("parameter estimate (log odds scale)") +
  xlab("") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey") +
  coord_flip() +
  cowplot::theme_cowplot(font_size = 10) 

y_rep <- as_draws_matrix(model_fits$all$diffuse[, paste0("theta[", 1:22, "]")])
new <- as_draws_matrix(gq1$draws("theta_linpred"))
y_rep <- cbind(new, y_rep)
y <- data %>%
  select(y) %>%
  deframe()
naive_av <- mean(y)
y <- c(naive_av, y)
trials <- c("NEW TRIAL", "angel", "rescue", "select2", "tension", "tesla",
            "escape", "extend", "mrclean", "piste", "resilient", "revascat","swift", "therapy", "thrace",
            "dawn", "defuse3", "mrcleanlate", "positive",
            "attention", "baoche", "basics", "best")

bayesplot::ppc_intervals(y, y_rep, prob = .95, prob_outer = .95) +
  scale_x_continuous(labels = trials, breaks = 1:length(trials)) +
  ylab("parameter estimate (log odds scale)") +
  xlab("") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey") +
  coord_flip() +
  cowplot::theme_cowplot(font_size = 10) 



gq1$summary("rr_erep_gt_1")
gq1$summary("rd_epred")

