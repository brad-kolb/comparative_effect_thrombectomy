library(tidyverse)
library(ggtext)
library(ggdist)
library(glue)
library(patchwork)
library(cowplot)

theme_set(new = theme_tidybayes() + panel_border())

# load the fits
model_fits <- readRDS(here("fits", "varying_fits.RDS")) 
pps <- readRDS(here("fits", "varying_pps.RDS"))

# generate plot ---------
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
  )
)

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
  )
)

mu$type <- factor(mu$type, levels = unique(mu$type))
theta_new$type <- factor(theta_new$type, levels = unique(theta_new$type))

plot_subtitle = glue("This is the subtitle. Data from {scales::number(1e5, big.mark = ',')} trials between 2000 and 3000.")

plot <- ggplot(mu, aes(y = type, x = value)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "lightgrey", 
             size = 0.5) +
  stat_slabinterval(.width = c(0.95),
                    position = position_nudge(y = 0.2)) +  
  stat_interval(aes(x = value),
                alpha = .9,
                data = theta_new) + 
  scale_color_brewer() +
  guides(col = "none") +
  labs(
    title = toupper("This is the title"),
    subtitle = plot_subtitle,
    caption = "This is a caption.",
    y = NULL,
    x = "Odds ratio (log scale)"
  ) 
    


# generate legend for plot -------------

mu_prior <- tibble(
  value = pps$diffuse$mu
)

theta_new_prior <- tibble(
  value = pps$diffuse$theta_new
)

legend <- ggplot(mu_prior, aes(x = value)) +
  stat_slabinterval(.width = c(0.95),
                    position = position_nudge(y = 0.1)) +  
  stat_interval(aes(x = value), 
                alpha = .9,
                data = theta_new_prior) +  
  scale_color_brewer() + 
  annotate(
    "richtext",
    x = c(-1, 1, 2, 0.5, 2),
    y = c(-.1, -.1, -.1, .35, .75),
    label = c(
      "In a hypothetical future trial, <br>given the trials observed up to this point,<br> the true effect of the intervention *in that trial* <br> can be expected to fall outside this range <br>50% of the time, according to the model",
      "20% of the time <br>it can be expected<br> to fall outside this range", 
      "5% of the time <br>it can be expected<br> to fall outside this range", 
      "According to the model, <br>there is a 95% chance that the true average effect <br> falls within this interval, given the observed data", 
      "Distribution of possible average effect sizes <br> ranked by the model according to their compatibility with the data"),
    fill = NA, label.size = 0, size = 2, vjust = 1,
  ) +
  geom_curve(
    data = data.frame(
      x = c(-.75, 1, 2, 0, 1.75),
      xend = c(-.5, 1, 2, -.25, 1), 
      y = c(-.1, -.1, -.1, .25, .75),
      yend = c(-.05, -.05, -.05, .15, .75)),
    aes(x = x, xend = xend, y = y, yend = yend),
    stat = "unique", curvature = 0.2, size = 0.2, color = "grey12",
    arrow = arrow(angle = 20, length = unit(1, "mm"))
  ) +
  theme_void() +
  guides(col = "none")

ggsave(here("plots", "plot.png"), plot, width = 8, height = 6, dpi = 300, bg = "white")
ggsave(here("plots", "legend.png"), legend, width = 8, height = 6, dpi = 300, bg = "white")

