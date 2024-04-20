library(tidyverse)
library(cowplot)
library(ggdist)
library(ggokabeito)

library(here)

# load the fits
model_fits <- readRDS(here("fits", "varying_fits.RDS")) 
pps <- readRDS(here("fits", "varying_pps.RDS"))

# plot prior distribution ---------
mu_prior <- tibble(
  value = pps$diffuse$mu
)

prior_density <- mu_prior %>%
  ggplot(aes(x = value)) +
  stat_slab(alpha = .5) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Prior distribution",
    subtitle = "Average treatment effect of thrombectomy",
    y = NULL,
    x = "odds ratio (log scale)"
  ) +
  theme_minimal_vgrid() +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())

ggsave(here("plots", "prior_density.png"), prior_plot, width = 8, height = 6, dpi = 300, bg = "white")

# plot posterior distribution ------
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

posterior_density <- mu %>%
  ggplot(aes(fill = type, color = type, x = value)) +
  stat_slab(alpha = .6) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Posterior distributions",
    subtitle = "Average treatment effect of thrombectomy by stroke type",
    y = NULL,
    x = "odds ratio (log scale)"
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

ggsave(here("plots", "posterior_density.png"), posterior_density, width = 8, height = 6, dpi = 300, bg = "white")

# plot the posterior complementary cumulative distribution -----------

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

posterior_ccdf <- ggplot() +
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
  labs(x = "treatment effect threshold (odds ratio on log scale)",
       y = NULL,
       title = "Complementary cumulative posterior distributions",
       subtitle = "Probability average treatment effect exceeds a given threshold.") +
  guides(color = "none", fill = "none") +
  theme_minimal_grid() +
  facet_wrap(~ type, nrow = 1)

ggsave(here("plots", "posterior_ccdf.png"), ccdf_plot, width = 8, height = 6, dpi = 300, bg = "white")

# histograms -----------

data <- tibble(x = rnorm(1e6, mean = 0, sd = 1))

bin_breaks <- seq(floor(min(data$x)), ceiling(max(data$x)), by = 0.5)

highlight_bin <- bin_breaks[which.min(abs(bin_breaks)) + 1]

prior_legend <- ggplot(data, aes(x = x, fill = ifelse(x >= highlight_bin & x < highlight_bin + 0.5, "highlight", "default"))) +
  geom_histogram(breaks = bin_breaks, color = "black") +
  scale_fill_manual(values = c("default" = "grey", "highlight" = "black"), guide = FALSE) +
  scale_x_continuous(breaks = c(0.5, 1),
                     labels = c("X1", "X2")) +
  scale_y_continuous(breaks = 1.5e5,
                     labels = c("Y%")) +
  labs(title = "Interpretating histogram of draws from the prior distribution",
       subtitle = "Y% prior probability of an effect between X1 and X2",
       x = NULL,
       y = NULL) +
  theme_minimal_grid()

ggsave(here("plots", "prior_legend.png"), prior_legend, width = 8, height = 6, dpi = 300, bg = "white")

prior_histogram <- mu_prior %>% 
  ggplot() +
  geom_histogram(mapping = aes(x = value, y = ..count..),
                 breaks = seq(floor(min(mu_prior$value)), ceiling(max(mu_prior$value)), by = 0.5),
                 alpha = 0.9, fill = "gray40", color = "black", size = 0.5) +
  guides(color = "none", fill = "none") +
  labs(x = "Average treatment effect (odds ratio on log scale)", y = "% of draws",
       title = "Prior distribution of average treatment effects",
       subtitle = "Bins represent clinically meaningful thresholds") +
  scale_x_continuous(breaks = c(-3, -2, -1, 0, 1, 2, 3),
                     labels = c("-3", "-2", "-1", "0", "1", "2", "3")) +
  scale_y_continuous(labels = c("0%", "5%", "10%", "15%", "20%")) +
  theme_minimal_grid() +
  theme(
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )

ggsave(here("plots", "prior_histogram.png"), prior_histogram, width = 8, height = 6, dpi = 300, bg = "white")

posterior_histogram <- mu %>% 
  mutate(prior = rep(mu_prior$value, 4)) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = prior, y = ..count..),
                 breaks = seq(floor(min(mu_prior$value)), ceiling(max(mu_prior$value)), by = 0.5),
                 alpha = 0.5, fill = "gray40", size = 0.5) +
  geom_histogram(mapping = aes(x = value, y = ..count.., color = type, fill = type),
                 breaks = seq(floor(min(mu$value)), ceiling(max(mu$value)), by = 0.5),
                 size = 0.5, alpha = 0.7) +
  scale_fill_okabe_ito() +
  scale_color_okabe_ito() +
  guides(color = "none", fill = "none") +
  labs(x = "Treatment effect (odds ratio on log scale)", y = "Posterior draws",
       title = "Thrombectomy treatment effect by stroke type",
       subtitle = "Draws from prior distribution shown in gray for comparison") +
  facet_wrap(~ type, nrow = 1) +
  scale_x_continuous(breaks = c(-4, -2, 0, 2, 4),
                     labels = c("-4", "-2", "0", "2", "4")) +
  scale_y_continuous(labels = c("0%", "25%", "50%", "75%", "100%")) +
  theme_minimal_grid() +
  theme(
    # axis.title.y = element_blank(),
    # axis.text.y = element_blank(),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
  )

ggsave(here("plots", "posterior_histogram.png"), posterior_histogram, width = 8, height = 6, dpi = 300, bg = "white")

