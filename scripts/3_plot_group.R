###### publication plots ########

#### effect plots #####
model_summaries <- readRDS(file = here("fits", "group_summaries.RDS"))

# risk ratios
df <- model_summaries %>% 
  filter(str_detect(variable, "E_rr"), 
         !str_detect(variable, "E_rr_new"),
         data == "all", 
         priors == "diffuse") %>% 
  select("variable", "median", "mad", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  arrange(desc(median))

# Flip the order of variables for bottom-to-top plotting
df <- df[nrow(df):1, ]

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df$median) - 1)

# Set up the plot area with flipped coordinates and extra space
pdf(here("plots", "risk_ratio.pdf"), width = 5, height = 4)
plot(df$median, 1:4, xlim = c(1, max(df$high)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", ylab = "", xlab = "adjusted risk ratio", pch = 19,
     main = "Relative effect estimates")

# Add y-axis labels
axis(2, at = 1:4, labels = df$names, las = 2)

abline(v = 1, lty = 2, col = "grey")

# Add error bars as lines
segments(df$low, 1:4, df$high, 1:4)

dev.off()

# risk differences
df <- model_summaries %>% 
  filter(str_detect(variable, "E_rd"), 
         !str_detect(variable, "E_rd_new"),
         data == "all", 
         priors == "diffuse") %>% 
  select("variable", "median", "mad", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  arrange(desc(median))

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df$median) - 1)

# Convert risk differences to percentages
df$median_pct <- df$median * 100
df$low_pct <- df$low * 100
df$high_pct <- df$high * 100

# Set up the plot area with flipped coordinates and extra space
pdf(here("plots", "risk_difference.pdf"), width = 5, height = 4)
plot(df$median_pct, 1:4, xlim = c(0, max(df$high_pct)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = "", xlab = "adjusted risk difference", pch = 19,
     main = "Absolute effect estimates")

# Add custom x-axis with percentage labels
axis(1, at = seq(0, 25, by = 5), labels = paste0(seq(0, 25, by = 5), "%"))

# Add y-axis labels
axis(2, at = 1:4, labels = df$names, las = 2)

# Add error bars as lines
segments(df$low_pct, 1:4, df$high_pct, 1:4)

# Add dashed vertical line at x = 0 (no effect)
abline(v = 0, lty = 2, col = "grey")

dev.off()

#### impact plots #####
library(RColorBrewer)
library(here)

model_fits <- readRDS(here("fits", "group_fits.RDS"))

# Function to create a single plot
create_impact_plot <- function(y_impact_new, index) {
  df <- y_impact_new
  df_plus <- df[df >= 1 & df < 10]
  df_plusplus <- df[df >= 10]
  df_neg <- df[df < 1]
  
  colors <- rev(brewer.pal(3, "Set2"))
  
  plot(NULL, xlim = c(-20, 60), ylim = c(0, 230), bty = 'n',
       xlab = 'Additional favorable outcomes',
       ylab = 'Frequency',
       main = paste("Predicted impact in new trial\n ", index))
  
  lines(table(df_neg), lwd = 3, col = colors[1])
  lines(table(df_plus), lwd = 3, col = colors[2])
  lines(table(df_plusplus), lwd = 3, col = colors[3])

  legend("topright", 
         legend = c(
           paste0("P(-) = ", format(length(df_neg)/length(df)*100, digits = 2), "%"),
           paste0("P(+) = ", format(length(df_plus)/length(df)*100, digits = 2), "%"),
           paste0("P(++) = ", format(length(df_plusplus)/length(df)*100, digits = 2), "%")
         ), 
         col = colors, 
         pt.cex = 2, 
         pch = 15,
         bty = 'n')
}

# Generate separate PDFs for each plot
generate_impact_plots <- function(model_fits, filename_prefix = "impact_plot") {
  stroke_types <- c("large core", "small core", "late window", "basilar occlusion")
  # Ensure the plots directory exists
  dir.create(here("plots"), showWarnings = FALSE, recursive = TRUE)
  
  for (i in 1:4) {
    file_path <- here("plots", paste0(filename_prefix, "_", i, ".pdf"))
    pdf(file_path, width = 5, height = 4)
    
    y_impact_new <- model_fits$all$diffuse[[paste0("y_impact_new[", i, "]")]]
    create_impact_plot(y_impact_new, stroke_types[i])
    
    dev.off()
    cat("Saved plot", i, "to", file_path, "\n")
  }
}

# Usage example:
generate_impact_plots(model_fits, filename_prefix = "impact_plot")

