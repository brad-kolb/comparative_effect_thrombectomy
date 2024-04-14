library(tidyverse)
library(cowplot)
library(ggdist)
library(here)

# load the fits
model_fits <- readRDS(here("fits", "varying_fits.RDS")) 
pps <- readRDS(here("fits", "varying_pps.RDS"))

# plot prior distribution ---------
mu_prior <- tibble(
  value = pps$diffuse$mu
)

p1 <- mu_prior %>%
  ggplot(aes(x = value)) +
  stat_slab(alpha = .3) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Prior distribution",
    subtitle = "Relative average treatment effect of thrombectomy by stroke subtype",
    y = NULL,
    x = "odds ratio (log scale)"
  ) +
  theme_minimal_vgrid() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())

inset <- mu_prior %>%
  ggplot(aes(x = value)) +
  stat_slab(alpha = .3) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(subtitle = "Prior",
       y = NULL,
       x = NULL) +
  theme_minimal_vgrid() +
  panel_border() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank())

prior_plot <- ggdraw(p1)

ggsave(here("plots", "prior_plot.png"), prior_plot, width = 8, height = 6, dpi = 300, bg = "white")

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

p2 <- mu %>%
  ggplot(aes(fill = type, color = type, x = value)) +
  stat_slab(alpha = .3) +
  stat_pointinterval(position = position_dodge(width = .4, preserve = "single")) +
  labs(
    title = "Posterior distributions",
    subtitle = "Relative average treatment effect of thrombectomy by stroke type",
    y = NULL,
    x = "odds ratio (log scale)"
  ) +
  scale_y_continuous(breaks = NULL) +
  theme_minimal_vgrid() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = c(.95, .95),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.margin = margin(6,6,6,6)) 

posterior_plot <- ggdraw(p2) +
  draw_plot(inset, .8, .3, .2, .2) 

ggsave(here("plots", "posterior_plot.png"), posterior_plot, width = 8, height = 6, dpi = 300, bg = "white")


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

ccdf_plot <- ggplot() +
  geom_step(data = mu_ccdf, aes(x = value, y = ccdf, color = type), size = 1.25) +
  geom_step(data = prior_ccdf, aes(x = value, y = ccdf), color = "darkgrey", linetype = "dotted", size = 1.25) +
  geom_text(data = prior_ccdf, aes(x = 0.1, y = 0.35), label = "prior", color = "darkgrey", hjust = 0, vjust = 0) +
  scale_y_continuous(labels = scales::percent_format(),
                     limits = c(0, 1),
                     breaks = seq(0, 1, by = 0.1)) +
  scale_x_continuous(limits = c(-.5, 2.0),
                     breaks = seq(-.5, 2.0, by = 0.5)) +
  labs(x = "odds ratio threshold (log scale)",
       y = "P(odds ratio > x)",
       title = "Posterior complementary cumulative distributions",
       subtitle = "Probability relative average treatment effect exceeds a given threshold") +
  theme_minimal_grid() +
  theme(legend.position = c(.95, .95),
        legend.justification = c("right", "top"),
        legend.box.just = "right",
        legend.margin = margin(6,6,6,6))

ggsave(here("plots", "ccdf_plot.png"), ccdf_plot, width = 8, height = 6, dpi = 300, bg = "white")

