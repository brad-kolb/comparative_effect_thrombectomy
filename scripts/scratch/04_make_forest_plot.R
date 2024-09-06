library(cowplot)

data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)

varying_summary <- readRDS(here("fits", "varying_summary.RDS")) 

theme_set(new = cowplot::theme_cowplot(font_size = 12))

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
           variable == "mu") %>% 
    mutate(trial = "AVERAGE") %>% 
    select("priors", "trial", "median", "low", "high")
  
  df <- bind_rows(df1, df2)
  df$trial <- factor(df$trial, levels = c(unique(df1$trial), "AVERAGE"))
  df$trial <- fct_rev(df$trial)
  
  ggplot(df, aes(x = trial, y = median, ymin = low, ymax = high, color = priors)) +
    geom_pointrange(position = position_dodge(width = 0.5)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    coord_flip(ylim = c(-0.5, 2.0)) +
    labs(x = NULL, y = "odds ratio (log scale)", 
         title = NULL,
         color = "Priors", shape = "Priors") +
    scale_color_manual(values = c("skeptical" = "blue", "diffuse" = "red")) +
    scale_shape_manual(values = c("skeptical" = 16, "diffuse" = 17))
}

trials_early <- c("escape", "extend", "mrclean", "piste", "resilient", "revascat","swift", "therapy", "thrace")
trials_large <- c("angel", "rescue", "select2", "tension", "tesla")
trials_late <- c("dawn", "defuse3", "mrcleanlate", "positive")
trials_basilar <- c("attention", "baoche", "basics", "best")


p1 <- plot_or(varying_summary, "varying", "early", trials_early)
p2 <- plot_or(varying_summary, "varying", "large", trials_large)
p3 <- plot_or(varying_summary, "varying", "late", trials_late)
p4 <- plot_or(varying_summary, "varying", "basilar", trials_basilar)

style <- theme(legend.position = "none", 
               axis.title.x = element_blank())

prow <- plot_grid(
  p1 + style,
  p2 + style,
  p3 + style,
  p4 + theme(legend.position = "none"),
  align = 'vh',
  labels = c("A", "B", "C", "D"),
  hjust = -1,
  nrow = 4
)

# extract the legend from one of the plots
legend <- get_legend(
  # create some space to the left of the legend
  p1 + theme(legend.box.margin = margin(0, 0, 0, 15))
)

# add the legend to the row we made earlier. Give it one-third of 
# the width of one plot (via rel_widths).
plot <- plot_grid(prow, legend, rel_widths = c(1, .3))

ggsave(here("plots", "forest.png"), 
       plot, width = 8, height = 8, dpi = 300, bg = "white")


