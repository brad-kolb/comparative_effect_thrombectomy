###### publication plots ########
#### risk plots #####
model_summaries <- readRDS(file = here("fits", "group_summaries.RDS"))

# baseline and with treatment

df_control <- model_summaries %>% 
  filter(str_detect(variable, "E_y_c"), 
         !str_detect(variable, "E_y_c_new"),
         data == "all", 
         priors == "diffuse") %>% 
  select("variable", "median", "mad", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  arrange(desc(median))

df_treatment <- model_summaries %>% 
  filter(str_detect(variable, "E_y_t"), 
         !str_detect(variable, "E_y_t_new"),
         data == "all", 
         priors == "diffuse") %>% 
  select("variable", "median", "mad", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  arrange(desc(median))

df_control$median_pct <- df_control$median * 100
df_control$low_pct <- df_control$low * 100
df_control$high_pct <- df_control$high * 100

df_treatment$median_pct <- df_treatment$median * 100
df_treatment$low_pct <- df_treatment$low * 100
df_treatment$high_pct <- df_treatment$high * 100

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_control$median) - 1)

# Define the offset value for separating control and treatment points
offset <- 0.1

pdf(here("plots", "risk.pdf"), width = 5, height = 4)
plot(df_control$median_pct, 1:4 + offset, xlim = c(0, max(df_treatment$high_pct)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, xlab = NA, pch = 19, 
     col = 4, main = "Probability of favorable outcome")

# treatment group points with offset
points(df_treatment$median_pct, 1:4 - offset, pch = 19, col = 2)

# intervals for control group with offset
segments(df_control$low_pct, 1:4 + offset, df_control$high_pct, 1:4 + offset, col = 4)

# intervals for treatment group with offset
segments(df_treatment$low_pct, 1:4 - offset, df_treatment$high_pct, 1:4 - offset, col = 2)

# custom x-axis with percentage labels
axis(1, at = seq(0, 60, by = 10), labels = paste0(seq(0, 60, by = 10), "%"))

# y-axis labels
axis(2, at = 1:4, labels = df_control$names, las = 2)

# dashed vertical line at x = 0 
abline(v = 0, lty = 2, col = "grey")

# legend
legend("topright", legend = c("Baseline", "With treatment"), pch = 19, col = c(4, 2))

dev.off()


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

model_fits <- readRDS(here("fits", "group_fits.RDS"))

# Function to create a single plot
create_impact_plot <- function(y_impact_new, index) {
  df <- y_impact_new
  df_plus <- df[df >= 1 & df < 10]
  df_plusplus <- df[df >= 10]
  df_neg <- df[df < 1]
  
  colors <- rev(brewer.pal(3, "Set2"))
  
  plot(NULL, xlim = c(-20, 60), ylim = c(0, 230), bty = 'n',
       xlab = 'projected additional favorable outcomes with treatment',
       ylab = 'Frequency',
       main = paste("New 200 patient trial\n ", index))
  
  lines(table(df_neg), lwd = 3, col = colors[1])
  lines(table(df_plus), lwd = 3, col = colors[2])
  lines(table(df_plusplus), lwd = 3, col = colors[3])

  legend("topright", 
         legend = c(
           paste0("P(<1) = ", format(length(df_neg)/length(df)*100, digits = 2), "%"),
           paste0("P(1-10) = ", format(length(df_plus)/length(df)*100, digits = 2), "%"),
           paste0("P(>10) = ", format(length(df_plusplus)/length(df)*100, digits = 2), "%")
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

##### NNT ######

model_fits <- readRDS(here("fits", "group_fits.RDS"))

df <- model_fits$all$diffuse$`y_impact_new[1]`
df_100 <- length(df[df >= 1])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df1 <- data.frame(name = "large", nnt = c("<100", "<10", "<5"), value = c(df_100, df_10, df_5))

df <- model_fits$all$diffuse$`y_impact_new[2]`
df_100 <- length(df[df >= 1])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df2 <- data.frame(name = "small", nnt = c("<100", "<10", "<5"), value = c(df_100, df_10, df_5))

df <- model_fits$all$diffuse$`y_impact_new[3]`
df_100 <- length(df[df >= 1])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df3 <- data.frame(name = "late", nnt = c("<100", "<10", "<5"), value = c(df_100, df_10, df_5))

df <- model_fits$all$diffuse$`y_impact_new[4]`
df_100 <- length(df[df >= 1])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df4 <- data.frame(name = "basilar", nnt = c("<100", "<10", "<5"), value = c(df_100, df_10, df_5))

df <- rbind(df1, df2, df3, df4)

# Prepare the data
df$nnt <- factor(df$nnt, levels = c("<100", "<10", "<5"))

# Define colors for the groups
colors <- c(1, 2, 3, 4)
names <- unique(df$name)
names <- factor(names, levels = names)

# Set up the plot window with custom labels and limits, but don't draw anything yet
pdf(here("plots", "nnt.pdf"), width = 5.5, height = 4.5)
plot(NA, NA, type = "n", xlim = c(1, 3), ylim = c(0, 100),
     xlab = "NNT", ylab = "Probability", main = "Projected number needed to treat in new trial",
     xaxt = "n", yaxt = "n")

# Add custom x-axis labels
axis(1, at = 1:3, labels = levels(df$nnt))

# Add custom y-axis labels as percentages
axis(2, at = seq(5, 95, by = 45), labels = paste0(seq(5, 95, by = 45), "%"))

# Add lines and points for each group
for (i in 1:length(names)) {
  lines(1:3, df$value[df$name == names[i]] * 100, type = "b", col = colors[i], pch = 19)
}

# Add a legend
legend("topright", legend = c("small", "late", "basilar", "large"), 
       col = c(2,3,4,1), pch = 16, lty = 1, bty = "n")

dev.off()