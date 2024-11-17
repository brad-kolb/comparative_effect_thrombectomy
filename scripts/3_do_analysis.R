###### publication analysis ########
library(tidyverse)

df <- readRDS(file = here("fits", "gq1_summary.RDS"))
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)

#### expected likelihood without treatment ####

df_rd <- df %>% 
  filter(str_detect(variable, "x_epred")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

# Reorder factor levels for names
df_rd <- df_rd %>%
  mutate(names = factor(names, levels = c("Large", "Basilar", "Late", "Small"))) %>%
  arrange(names)

# Calculate extra space
extra_space <- 0.2 * (length(df_rd$median) - 1)

pdf(here("plots", "pr_ind_wo_mt.pdf"), width = 5, height = 4)
plot(df_rd$median, as.numeric(df_rd$names), xlim = c(0, max(50)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = "Chances of independence without treatment",
     pch = 19,
     col = 1, main = "")

segments(df_rd$low, as.numeric(df_rd$names), df_rd$high, as.numeric(df_rd$names), col = 1, lwd = 1)
axis(1, at = seq(0, 50, by = 10), labels = paste0(seq(0, 50, by = 10), "%"))
axis(2, at = 1:4, labels = levels(df_rd$names), las = 2)
abline(v = 0, lty = 2, col = "grey")

dev.off()


#### absolute treatment effect ####
df_rd <- df %>% 
  filter(str_detect(variable, "rd_epred"),
         !str_detect(variable, "rd_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

# Reorder factor levels for names
df_rd <- df_rd %>%
  mutate(names = factor(names, levels = c("Large", "Basilar", "Late", "Small"))) %>%
  arrange(names)

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_rd$median) - 1)

pdf(here("plots", "treatment_effect.pdf"), width = 5, height = 4)
plot(df_rd$median, 1:4, xlim = c(0, max(35)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = "Predicted effect",
     pch = 19,
     col = 1, main = "")

segments(df_rd$low, 1:4, df_rd$high, 1:4, col = 1, lwd = 1)
axis(1, at = seq(0, 30, by = 10), labels = paste0("+", seq(0, 30, by = 10), "%"))
axis(2, at = 1:4, labels = df_rd$names, las = 2)
abline(v = 0, lty = 2, col = "grey")

dev.off()

#### expected improvement with treatment, absolute vs relative ####
df <- readRDS(file = here("fits", "gq1_summary.RDS"))

df_rd <- df %>% 
  filter(str_detect(variable, "rd_epred"),
         !str_detect(variable, "rd_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

df_rd <- df_rd %>%
  mutate(names = factor(names, levels = c("Large", "Basilar", "Late", "Small"))) %>%
  arrange(names)

df_rr <- df %>% 
  filter(str_detect(variable, "rr_epred"),
         !str_detect(variable, "rr_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = (median - 1) * 100, low = (low - 1) * 100, high = (high - 1) * 100)

df_rr <- df_rr %>%
  mutate(names = factor(names, levels = c("Large", "Basilar", "Late", "Small"))) %>%
  arrange(names)

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_rd$median) - 1)

# Define the offset value for separating control and treatment points
offset <- 0.1

pdf(here("plots", "abs_vs_rel.pdf"), width = 5, height = 4)
plot(df_rr$median, 1:4 + offset, xlim = c(0, max(df_rr$high)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = "Predicted effect", 
     pch = 18,
     col = 1, main = "")
points(df_rd$median, 1:4 - offset, pch = 19, col = 1)

segments(df_rr$low, 1:4 + offset, df_rr$high, 1:4 + offset, col = 1)

segments(df_rd$low, 1:4 - offset, df_rd$high, 1:4 - offset, col = 1)

axis(1, at = seq(0, 250, by = 50), labels = paste0("+", seq(0, 250, by = 50), "%"))

axis(2, at = 1:4, labels = df_rr$names, las = 2)

abline(v = 0, lty = 2, col = "grey")

legend("topright", legend = c("relative", "absolute"),
       pch = c(18, 19), col = 1)

dev.off()

##### clinical significance, cum prob ######

gq1 <- readRDS(here("fits", "gq1.RDS"))

# cum prob
x <- gq1$draws("rd_epred[1]")
x_100 <- format(length(x[x >.01])/length(x)*100, digits = 1)
x_10 <- format(length(x[x >.1])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >.2])/length(x)*100, digits = 2)
df1 <- data.frame(name = "large", 
                  nnt = c("<100", "<10", "<5"), 
                  rd = c(">1%", ">10%", ">20%"),
                  value = c(x_100, x_10, x_5))


x <- gq1$draws("rd_epred[2]")
x_100 <- format(length(x[x >.01])/length(x)*100, digits = 1)
x_10 <- format(length(x[x >.1])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >.2])/length(x)*100, digits = 2)
df2 <- data.frame(name = "small", nnt = c("<100", "<10", "<5"), 
                  rd = c(">1%", ">10%", ">20%"),
                  value = c(x_100, x_10, x_5))


x <- gq1$draws("rd_epred[3]")
x_100 <- format(length(x[x >.01])/length(x)*100, digits = 1)
x_10 <- format(length(x[x >.1])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >.2])/length(x)*100, digits = 2)
df3 <- data.frame(name = "late", nnt = c("<100", "<10", "<5"), 
                  rd = c(">1%", ">10%", ">20%"),
                  value = c(x_100, x_10, x_5))


x <- gq1$draws("rd_epred[4]")
x_100 <- format(length(x[x >.01])/length(x)*100, digits = 1)
x_10 <- format(length(x[x >.1])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >.2])/length(x)*100, digits = 2)
df4 <- data.frame(name = "basilar", nnt = c("<100", "<10", "<5"), 
                  rd = c(">1%", ">10%", ">20%"),
                  value = c(x_100, x_10, x_5))

df <- rbind(df1, df2, df3, df4)

# Prepare the data
df$nnt <- factor(df$nnt, levels = c("<100", "<10", "<5"))
df$rd <- factor(df$rd, levels = c(">1%", ">10%", ">20%"))

# Define colors for the groups
colors <- c("#E69F00","#0072B2","#009E73","#56B4E9") 
names <- unique(df$name)
names <- factor(names, levels = names)

# Set up the plot window with custom labels and limits, but don't draw anything yet
pdf(here("plots", "clinsig_cumulative.pdf"), width = 5, height = 5)
plot(NA, NA, type = "n", xlim = c(1, 3), ylim = c(0, 100),
     xlab = "Predicted effect", ylab = "Probability", main = "",
     xaxt = "n", yaxt = "n")

# Add custom x-axis labels
axis(1, at = 1:3, labels = levels(df$rd))

# Add custom y-axis labels as percentages
axis(2, at = seq(10, 90, by = 40), labels = paste0(seq(10, 90, by = 40), "%"))

# Add lines and points for each group
for (i in 1:length(names)) {
  lines(1:3, df$value[df$name == names[i]], type = "b", col = colors[i], pch = 19)
}

# Add a legend
legend("topright", legend = c("small", "late", "basilar", "large"), 
       col = c("#0072B2","#009E73","#56B4E9","#E69F00" ), pch = 16, lty = 1)

dev.off()

#### clinical significance, intervals ####
pdf(here("plots", "intervals_clinical.pdf"), width = 10, height = 3)

# Set outer margins (bottom, left, top, right) and enable them
par(oma = c(3, 0, 0, 0))  # outer margins
par(mar = c(4, 2, 4, 2))  # plot margins
par(cex.main = 1, mgp = c(3.5, 1, 0), cex.lab = 1, 
    font.lab = 1, cex.axis = 1, bty = "n", las = 1, lwd = 1)

# Layout for 4 plots in a row
layout(matrix(c(1, 2, 3, 4), 1, 4))

### large ###

x <- gq1$draws("rd_epred[1]")

# interval prob

x_100 <- format(length(x[x <.01])/length(x)*100, digits = 1)
x_100_10 <- format(length(x[x >= .01 & x < .1])/length(x)*100, digits = 2)
x_10_5 <- format(length(x[x >= .1 & x < .2])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >= .2])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.05,.4), xlab = "", ylab = "",
                 main = "Large", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0.01, 0.1, 0.2), labels = c("0.01", "0.1", "0.2"))

wdens <- density(x, adj=0.5)

# Color area to the left of 0.01
polygon(c(wdens$x[wdens$x < 0.01], 0.01, min(wdens$x)), 
        c(wdens$y[wdens$x < 0.01], 0, 0), col="#E0E0E0", border = NA, xpd = FALSE)

# Color area between 0.01 and 0.1
polygon(c(wdens$x[wdens$x >= 0.01 & wdens$x <= 0.1], 0.1, 0.01), 
        c(wdens$y[wdens$x >= 0.01 & wdens$x <= 0.1], 0, 0), col="#C0C0C0", border = NA, lwd = 2, xpd = FALSE)

# Color area between 0.1 and 0.2
polygon(c(wdens$x[wdens$x >= 0.1 & wdens$x <= 0.2], 0.2, 0.1), 
        c(wdens$y[wdens$x >= 0.1 & wdens$x <= 0.2], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0.2], max(wdens$x), 0.2), 
        c(wdens$y[wdens$x > 0.2], 0, 0), col="#808080", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0.1, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.01, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.2, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

text(0.01, 11, "100", cex = 1)
text(0.1, 11, "10", cex = 1)
text(0.2, 11, "5", cex = 1)


text(-0.025, 9, paste0(x_100, "%"), cex = 1)
text(0.06, 9, paste0(x_100_10, "%"), cex = 1)
text(0.15, 9, paste0(x_10_5, "%"), cex = 1)
text(0.25, 9, paste0(x_5, "%"), cex = 1)


### small ###
x <- gq1$draws("rd_epred[2]")

x_100 <- format(length(x[x <.01])/length(x)*100, digits = 1)
x_100_10 <- format(length(x[x >= .01 & x < .1])/length(x)*100, digits = 2)
x_10_5 <- format(length(x[x >= .1 & x < .2])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >= .2])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.05,.4), xlab = "", ylab = "",
                 main = "Small", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0.01, 0.1, 0.2), labels = c("0.01", "0.1", "0.2"))

wdens <- density(x, adj=0.5)

# Color area to the left of 0.01
polygon(c(wdens$x[wdens$x < 0.01], 0.01, min(wdens$x)), 
        c(wdens$y[wdens$x < 0.01], 0, 0), col="#E0E0E0", border = NA, xpd = FALSE)

# Color area between 0.01 and 0.1
polygon(c(wdens$x[wdens$x >= 0.01 & wdens$x <= 0.1], 0.1, 0.01), 
        c(wdens$y[wdens$x >= 0.01 & wdens$x <= 0.1], 0, 0), col="#C0C0C0", border = NA, lwd = 2, xpd = FALSE)

# Color area between 0.1 and 0.2
polygon(c(wdens$x[wdens$x >= 0.1 & wdens$x <= 0.2], 0.2, 0.1), 
        c(wdens$y[wdens$x >= 0.1 & wdens$x <= 0.2], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0.2], max(wdens$x), 0.2), 
        c(wdens$y[wdens$x > 0.2], 0, 0), col="#808080", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0.1, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.01, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.2, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

text(0.01, 11, "100", cex = 1)
text(0.1, 11, "10", cex = 1)
text(0.2, 11, "5", cex = 1)


text(-0.025, 9, paste0(x_100, "%"), cex = 1)
text(0.06, 9, paste0(x_100_10, "%"), cex = 1)
text(0.15, 9, paste0(x_10_5, "%"), cex = 1)
text(0.25, 9, paste0(x_5, "%"), cex = 1)

### late ###
x <- gq1$draws("rd_epred[3]")

x_100 <- format(length(x[x <.01])/length(x)*100, digits = 1)
x_100_10 <- format(length(x[x >= .01 & x < .1])/length(x)*100, digits = 2)
x_10_5 <- format(length(x[x >= .1 & x < .2])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >= .2])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.05,.4), xlab = "", ylab = "",
                 main = "Late", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0.01, 0.1, 0.2), labels = c("0.01", "0.1", "0.2"))

wdens <- density(x, adj=0.5)

# Color area to the left of 0.01
polygon(c(wdens$x[wdens$x < 0.01], 0.01, min(wdens$x)), 
        c(wdens$y[wdens$x < 0.01], 0, 0), col="#E0E0E0", border = NA, xpd = FALSE)

# Color area between 0.01 and 0.1
polygon(c(wdens$x[wdens$x >= 0.01 & wdens$x <= 0.1], 0.1, 0.01), 
        c(wdens$y[wdens$x >= 0.01 & wdens$x <= 0.1], 0, 0), col="#C0C0C0", border = NA, lwd = 2, xpd = FALSE)

# Color area between 0.1 and 0.2
polygon(c(wdens$x[wdens$x >= 0.1 & wdens$x <= 0.2], 0.2, 0.1), 
        c(wdens$y[wdens$x >= 0.1 & wdens$x <= 0.2], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0.2], max(wdens$x), 0.2), 
        c(wdens$y[wdens$x > 0.2], 0, 0), col="#808080", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0.1, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.01, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.2, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

text(0.01, 11, "100", cex = 1)
text(0.1, 11, "10", cex = 1)
text(0.2, 11, "5", cex = 1)


text(-0.025, 9, paste0(x_100, "%"), cex = 1)
text(0.06, 9, paste0(x_100_10, "%"), cex = 1)
text(0.15, 9, paste0(x_10_5, "%"), cex = 1)
text(0.25, 9, paste0(x_5, "%"), cex = 1)

### basilar ###

x <- gq1$draws("rd_epred[4]")

x_100 <- format(length(x[x <.01])/length(x)*100, digits = 1)
x_100_10 <- format(length(x[x >= .01 & x < .1])/length(x)*100, digits = 2)
x_10_5 <- format(length(x[x >= .1 & x < .2])/length(x)*100, digits = 2)
x_5 <- format(length(x[x >= .2])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.05,.4), xlab = "", ylab = "",
                 main = "Basilar", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0.01, 0.1, 0.2), labels = c("0.01", "0.1", "0.2"))

wdens <- density(x, adj=0.5)

# Color area to the left of 0.01
polygon(c(wdens$x[wdens$x < 0.01], 0.01, min(wdens$x)), 
        c(wdens$y[wdens$x < 0.01], 0, 0), col="#E0E0E0", border = NA, xpd = FALSE)

# Color area between 0.01 and 0.1
polygon(c(wdens$x[wdens$x >= 0.01 & wdens$x <= 0.1], 0.1, 0.01), 
        c(wdens$y[wdens$x >= 0.01 & wdens$x <= 0.1], 0, 0), col="#C0C0C0", border = NA, lwd = 2, xpd = FALSE)

# Color area between 0.1 and 0.2
polygon(c(wdens$x[wdens$x >= 0.1 & wdens$x <= 0.2], 0.2, 0.1), 
        c(wdens$y[wdens$x >= 0.1 & wdens$x <= 0.2], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0.2], max(wdens$x), 0.2), 
        c(wdens$y[wdens$x > 0.2], 0, 0), col="#808080", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0.1, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.01, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

l <- seq(0, 10, 0.01)
x1 <- rep(0.2, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.05,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")

text(0.01, 11, "100", cex = 1)
text(0.1, 11, "10", cex = 1)
text(0.2, 11, "5", cex = 1)


text(-0.025, 9, paste0(x_100, "%"), cex = 1)
text(0.06, 9, paste0(x_100_10, "%"), cex = 1)
text(0.15, 9, paste0(x_10_5, "%"), cex = 1)
text(0.25, 9, paste0(x_5, "%"), cex = 1)

mtext("Predicted effect", side = 1, outer = TRUE, cex = 0.7)

dev.off()

#### statistical significance, intervals ####
pdf(here("plots", "intervals_statistical.pdf"), width = 10, height = 3)

# Set outer margins (bottom, left, top, right) and enable them
par(oma = c(3, 0, 0, 0))  # outer margins
par(mar = c(4, 2, 4, 2))  # plot margins
par(cex.main = 1, mgp = c(3.5, 1, 0), cex.lab = 1, 
    font.lab = 1, cex.axis = 1, bty = "n", las = 1, lwd = 1)

# Layout for 4 plots in a row
layout(matrix(c(1, 2, 3, 4), 1, 4))

### large ###

x <- gq1$draws("rd_epred[1]")

# interval prob

x_neg <- format(length(x[x <= 0])/length(x)*100, digits = 1)
x_pos <- format(length(x[x > 0])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.1,.4), xlab = "", ylab = "",
                 main = "Large", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0), labels = c("0"))

wdens <- density(x, adj=0.5)

polygon(c(wdens$x[wdens$x <= 0], 0, min(wdens$x)), 
        c(wdens$y[wdens$x <= 0], 0, 0), col="#C0C0C0", border = NA, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0], max(wdens$x), 0), 
        c(wdens$y[wdens$x > 0], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.1,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")


# text(0.05, 11, "Pr(+)", cex = 1)
# text(-0.05, 11, "Pr(-)", cex = 1)



text(-0.05, 9, paste0(x_neg, "%"), cex = 1)
text(0.06, 9, paste0(x_pos, "%"), cex = 1)


### small ###
x <- gq1$draws("rd_epred[2]")

# interval prob

x_neg <- format(length(x[x <= 0])/length(x)*100, digits = 1)
x_pos <- format(length(x[x > 0])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.1,.4), xlab = "", ylab = "",
                 main = "Small", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0), labels = c("0"))

wdens <- density(x, adj=0.5)

polygon(c(wdens$x[wdens$x <= 0], 0, min(wdens$x)), 
        c(wdens$y[wdens$x <= 0], 0, 0), col="#C0C0C0", border = NA, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0], max(wdens$x), 0), 
        c(wdens$y[wdens$x > 0], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.1,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")


# text(0.05, 11, "Pr(+)", cex = 1)
# text(-0.05, 11, "Pr(-)", cex = 1)



text(-0.05, 9, paste0(x_neg, "%"), cex = 1)
text(0.06, 9, paste0(x_pos, "%"), cex = 1)

### late ###
x <- gq1$draws("rd_epred[3]")

# interval prob

x_neg <- format(length(x[x <= 0])/length(x)*100, digits = 1)
x_pos <- format(length(x[x > 0])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.1,.4), xlab = "", ylab = "",
                 main = "Late", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0), labels = c("0"))

wdens <- density(x, adj=0.5)

polygon(c(wdens$x[wdens$x <= 0], 0, min(wdens$x)), 
        c(wdens$y[wdens$x <= 0], 0, 0), col="#C0C0C0", border = NA, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0], max(wdens$x), 0), 
        c(wdens$y[wdens$x > 0], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.1,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")


# text(0.05, 11, "Pr(+)", cex = 1)
# text(-0.05, 11, "Pr(-)", cex = 1)



text(-0.05, 9, paste0(x_neg, "%"), cex = 1)
text(0.06, 9, paste0(x_pos, "%"), cex = 1)

### basilar ###

x <- gq1$draws("rd_epred[4]")

# interval prob

x_neg <- format(length(x[x <= 0])/length(x)*100, digits = 1)
x_pos <- format(length(x[x > 0])/length(x)*100, digits = 2)

rethinking::dens(x, type = "l", ylim = c(0,12), xlim = c(-.1,.4), xlab = "", ylab = "",
                 main = "Basilar", bty = "n", yaxt = "n", xaxt = "n", xpd = FALSE)
axis(1, at = c(0), labels = c("0"))

wdens <- density(x, adj=0.5)

polygon(c(wdens$x[wdens$x <= 0], 0, min(wdens$x)), 
        c(wdens$y[wdens$x <= 0], 0, 0), col="#C0C0C0", border = NA, xpd = FALSE)

# Color area to the right of 0.1
polygon(c(wdens$x[wdens$x > 0], max(wdens$x), 0), 
        c(wdens$y[wdens$x > 0], 0, 0), col="#A0A0A0", border = NA, lwd = 2, xpd = FALSE)

l <- seq(0, 10, 0.01)
x1 <- rep(0, length(l))
par(new = TRUE)
plot(x1, l, type = "l", ylim = c(0, 12), xlim = c(-.1,.4), xlab = "", ylab = "", 
     main = "", bty = "n", yaxt = "n", xaxt = "n")


# text(0.05, 11, "Pr(+)", cex = 1)
# text(-0.05, 11, "Pr(-)", cex = 1)



text(-0.05, 9, paste0(x_neg, "%"), cex = 1)
text(0.06, 9, paste0(x_pos, "%"), cex = 1)

mtext("Predicted effect", side = 1, outer = TRUE, cex = 0.7)

dev.off()

