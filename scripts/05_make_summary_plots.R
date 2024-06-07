library(ggdist)
library(ggokabeito)

# load the fits
model_fits <- readRDS(here("fits", "varying_fits.RDS")) 
pps <- readRDS(here("fits", "varying_pps.RDS"))

# scatter plot of data
df <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE) 

df <- df %>% 
  mutate(control = r_c / n_c, 
         treatment = r_t / n_t,
         size = n_c + n_t,
         K = recode(K, `1` = "large", `2` = "early", `3` = "late", `4` = "basilar"),
         K = factor(K, levels = c("basilar", "late", "early", "large"))) %>% 
  select(J, K, control, treatment, size)

scatter_plot <- ggplot(df, aes(x = control, y = treatment, fill = K, color = K, size = size)) +
  geom_point() +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  scale_y_continuous(limits = c(.1, 0.8), breaks = seq(.2, 0.8, by = 0.2)) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "lightgrey") +
  labs(fill = "stroke type", color = "stroke type", size = "sample size") 

ggsave(here("plots", "scatter_plot.png"), scatter_plot, width = 6, height = 4, dpi = 300, bg = "white")

#### mu #####
mu <- tibble(
  type = c(
    rep("late", 4e3),
    rep("basilar", 4e3),
    rep("large", 4e3),
    rep("early", 4e3)
  ),
  value = c(
    model_fits[["late"]][["diffuse"]]$mu,
    model_fits[["basilar"]][["diffuse"]]$mu,
    model_fits[["large"]][["diffuse"]]$mu,
    model_fits[["early"]][["diffuse"]]$mu
  ),
  variable = "mu"
)
mu$type <- factor(mu$type, levels = unique(mu$type))

# visualize prior ----

# distribution
mu_prior <- tibble(
  value = pps$diffuse$mu
)
prior_density <- mu_prior %>%
  ggplot(aes(x = value)) +
  stat_slab(alpha = .5) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Diffuse prior for average treatment effect of thrombectomy",
    y = NULL,
    x = "odds ratio (log scale)"
  ) +
  theme_minimal_vgrid() +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())
ggsave(here("plots", "density_prior.png"), prior_density, width = 8, height = 6, dpi = 300, bg = "white")

# histogram
prior_histogram <- mu_prior %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = value, y = ..count..),
                 breaks = seq(floor(min(mu_prior$value)), ceiling(max(mu_prior$value)), by = 0.5),
                 alpha = 0.9, fill = "gray40", color = "black", size = 0.5) +
  guides(color = "none", fill = "none") +
  labs(x = "odds ratio (log scale)", y = "prior draws",
       title = "Draws from prior distribution of average treatment effects",
       subtitle = "Bins represent clinically meaningful thresholds") +
  scale_x_continuous(breaks = c(-3, -2, -1, 0, 1, 2, 3),
                     labels = c("-3", "-2", "-1", "0", "1", "2", "3")) +
  scale_y_continuous(labels = c("0%", "5%", "10%", "15%", "20%")) +
  theme_minimal_grid() +
  theme(
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )
ggsave(here("plots", "histogram_prior.png"), prior_histogram, width = 8, height = 6, dpi = 300, bg = "white")

# visualize posterior ---------

# posterior density 
posterior_density <- mu %>%
  ggplot(aes(fill = type, color = type, x = value)) +
  stat_slab(alpha = .6) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Average treatment effect of thrombectomy across trials",
    y = NULL,
    x = "average treatment effect (log scale)"
  ) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  scale_y_continuous(breaks = NULL) +
  theme_minimal_vgrid() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "bottom",
        legend.justification = "center",
        legend.box.just = "right",
        legend.margin = margin(6,6,6,6)) 
ggsave(here("plots", "density_posterior.png"), posterior_density, width = 8, height = 6, dpi = 300, bg = "white")

# complementary cumulative distribution 
# Probability average treatment effect across trials exceeds a given threshold
# Prior probability shown for comparison.
mu_ccdf <- mu %>%
  group_by(type) %>% 
  arrange(value) %>%
  mutate(ecdf = seq_along(value) / n()) %>%
  ungroup() %>%
  mutate(ccdf = 1 - ecdf)
prior_ccdf <- mu_prior %>% 
  arrange(value) %>% 
  mutate(ecdf = seq_along(value) / n()) %>% 
  ungroup() %>% 
  mutate(ccdf = 1 - ecdf)
ccdf_mu <- ggplot() +
  geom_step(data = mu_ccdf, aes(x = value, y = ccdf, color = type), size = 1.25) +
  geom_step(data = prior_ccdf, aes(x = value, y = ccdf), color = "darkgrey", size = 1.25) +
  geom_text(data = prior_ccdf, aes(x = 0.1, y = 0.15), label = "prior", color = "darkgrey", hjust = 0, vjust = 0) +
  scale_y_continuous(labels = scales::percent_format(),
                     limits = c(0, 1),
                     breaks = seq(0, 1, by = 0.1)) +
  scale_x_continuous(limits = c(0, 2.0),
                     breaks = seq(0, 2.0, by = 1)) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  labs(x = "Average treatment effect (log scale)",
       y = NULL,
       title = "Probability average treatment effect across trials exceeds a given threshold",
       subtitle = "Prior probability shown for comparison.") +
  guides(color = "none", fill = "none") +
  theme_minimal_grid() +
  facet_wrap(~ type, nrow = 1)
ggsave(here("plots", "ccdf_posterior.png"), ccdf_mu, width = 8, height = 6, dpi = 300, bg = "white")

# histograms
# Average treatment effect of thrombectomy across trials
# prior shown in grey for comparison
data <- tibble(x = rnorm(1e6, mean = 0, sd = 1))
bin_breaks <- seq(floor(min(data$x)), ceiling(max(data$x)), by = 0.5)
highlight_bin <- bin_breaks[which.min(abs(bin_breaks)) + 1]
posterior_histogram <- mu %>% 
  mutate(prior = rep(mu_prior$value, 4)) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = prior, y = ..count..),
                 breaks = seq(-3, 3, by = 0.5),
                 alpha = 0.5, fill = "gray40", size = 0.5) +
  geom_histogram(mapping = aes(x = value, y = ..count.., color = type, fill = type),
                 breaks = seq(-3, 3, by = 0.5),
                 size = 0.5, alpha = 0.7) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  guides(color = "none", fill = "none") +
  labs(x = "average treatment effect (log scale)", y = "draws") +
  facet_wrap(~ type, nrow = 1) +
  scale_x_continuous(breaks = c(-2, 0, 2),
                     labels = c("-2", "0", "2")) +
  scale_y_continuous(labels = c("0%", "25%", "50%", "75%", "100%")) +
  theme_minimal_grid() +
  theme(
    # axis.title.y = element_blank(),
    # axis.text.y = element_blank(),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )
ggsave(here("plots", "histogram_posterior.png"), posterior_histogram, width = 8, height = 6, dpi = 300, bg = "white")

# visual guide to interpreting these plots
histogram_legend <- ggplot(data, aes(x = x, fill = ifelse(x >= highlight_bin & x < highlight_bin + 0.5, "highlight", "default"))) +
  geom_histogram(breaks = bin_breaks, color = "black") +
  scale_fill_manual(values = c("default" = "grey", "highlight" = "black"), guide = FALSE) +
  scale_x_continuous(breaks = c(0.5, 1),
                     labels = c("X1", "X2")) +
  scale_y_continuous(breaks = 1.5e5,
                     labels = c("Y%")) +
  labs(title = "Interpretating histogram of draws from a prior distribution",
       subtitle = "''Y% prior probability of an average effect between X1 and X2''",
       x = NULL,
       y = NULL) +
  theme_minimal_grid()
ggsave(here("plots", "histogram_legend.png"), histogram_legend, width = 8, height = 6, dpi = 300, bg = "white")

#### theta_new ####
theta_new <- tibble(
  type = c(
    rep("late", 4e3),
    rep("basilar", 4e3),
    rep("large", 4e3),
    rep("early", 4e3)
  ),
  value = c(
    model_fits[["late"]][["diffuse"]]$theta_new,
    model_fits[["basilar"]][["diffuse"]]$theta_new,
    model_fits[["large"]][["diffuse"]]$theta_new,
    model_fits[["early"]][["diffuse"]]$theta_new
  ),
  variable = "theta_new"
)
theta_new$type <- factor(theta_new$type, levels = unique(theta_new$type))

# density 
predictive_density <- theta_new %>%
  ggplot(aes(fill = type, color = type, x = value)) +
  stat_slab(alpha = .6) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Anticipated treatment effect of thrombectomy in a new trial",
    y = NULL,
    x = "anticipated treatment effect (log scale)"
  ) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  scale_y_continuous(breaks = NULL) +
  theme_minimal_vgrid() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "bottom",
        legend.justification = "center",
        legend.box.just = "right",
        legend.margin = margin(6,6,6,6)) 
ggsave(here("plots", "density_predictive.png"), predictive_density, width = 8, height = 6, dpi = 300, bg = "white")

# complementary cumulative distribution 
# Probability anticipated treatment effect exceeds a given threshold
# Prior Prior probability shown in grey for comparison
predictive_prior <- tibble(
  value = pps$diffuse$theta_new
)
predictive_ccdf <- theta_new %>%
  group_by(type) %>% 
  arrange(value) %>%
  mutate(ecdf = seq_along(value) / n()) %>%
  ungroup() %>%
  mutate(ccdf = 1 - ecdf)
prior_ccdf <- predictive_prior %>% 
  arrange(value) %>% 
  mutate(ecdf = seq_along(value) / n()) %>% 
  ungroup() %>% 
  mutate(ccdf = 1 - ecdf)
ccdf_predictive <- ggplot() +
  geom_step(data = predictive_ccdf, aes(x = value, y = ccdf, color = type), size = 1.25) +
  geom_step(data = prior_ccdf, aes(x = value, y = ccdf), color = "darkgrey", size = 1.25) +
  geom_text(data = prior_ccdf, aes(x = 0.1, y = 0.15), label = "prior", color = "darkgrey", hjust = 0, vjust = 0) +
  scale_y_continuous(labels = scales::percent_format(),
                     limits = c(0, 1),
                     breaks = seq(0, 1, by = 0.1)) +
  scale_x_continuous(limits = c(0, 2.0),
                     breaks = seq(0, 2.0, by = 1)) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  labs(x = "anticipated treatment effect (log scale)",
       y = NULL) +
  guides(color = "none", fill = "none") +
  theme_minimal_grid() +
  facet_wrap(~ type, nrow = 1)
ggsave(here("plots", "ccdf_predictive.png"), ccdf_predictive, width = 8, height = 6, dpi = 300, bg = "white")

# histograms
# Anticipated treatment effect of thrombectomy in a new trial
# Prior shown in gray for comparison
data <- tibble(x = rnorm(1e6, mean = 0, sd = 1))
bin_breaks <- seq(floor(min(data$x)), ceiling(max(data$x)), by = 0.5)
highlight_bin <- bin_breaks[which.min(abs(bin_breaks)) + 1]
predictive_histogram <- theta_new %>% 
  mutate(prior = rep(predictive_prior$value, 4)) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = prior, y = ..count..),
                 breaks = seq(-3, 3, by = 0.5),
                 alpha = 0.5, fill = "gray40", size = 0.5) +
  geom_histogram(mapping = aes(x = value, y = ..count.., color = type, fill = type),
                 breaks = seq(-3, 3, by = 0.5),
                 size = 0.5, alpha = 0.7) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  guides(color = "none", fill = "none") +
  labs(x = "anticipated treatment effect (log scale)", 
       y = "draws") +
  facet_wrap(~ type, nrow = 1) +
  scale_x_continuous(breaks = c(-2, 0, 2),
                     labels = c("-2", "0", "2")) +
  scale_y_continuous(labels = c("0%", "25%", "50%", "75%")) +
  theme_minimal_grid() +
  theme(
    # axis.title.y = element_blank(),
    # axis.text.y = element_blank(),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )
ggsave(here("plots", "histogram_predictive.png"), predictive_histogram, width = 8, height = 6, dpi = 300, bg = "white")

