#L'abbe plot (working)

df <- data.frame(x = c(.2, .3, .4), y = c(.4, .6, .8), z = c(100, 200, 300))

# Create the scatter plot
plot(df$x, df$y, 
     main = "Scatter Plot of X vs Y (Size scaled by Z)",
     xlab = "X", 
     ylab = "Y", 
     pch = 16,  # Use filled circles for points
     cex = df$z / 100,  # Scale point size based on z values
     col = "blue")  # Set point color to blue

# Add a legend to explain the point sizes
legend("topleft", 
       legend = c("Z = 100", "Z = 200", "Z = 300"),
       pt.cex = c(1, 2, 3),
       pch = 16,
       col = "blue",
       title = "Point Sizes")

model_fits <- readRDS(here("fits", "group_fits.RDS"))

# expected control and treatment ####
par(mfrow = c(4, 2), mar = c(2, 2, 2, 1))
# group 1
plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_c_new[1]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_c_new[1]`), lwd = 2)

plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_t_new[1]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_t_new[1]`), lwd = 2)

# group 2
plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_c_new[2]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_c_new[2]`), lwd = 2)

plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_t_new[2]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_t_new[2]`), lwd = 2)

# group 3
plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_c_new[3]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_c_new[3]`), lwd = 2)

plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_t_new[3]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_t_new[3]`), lwd = 2)

# group 4
plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_c_new[4]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_c_new[4]`), lwd = 2)

plot(NULL, xlim = c(0, 100), ylim = c(0,350),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_t_new[4]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_t_new[4]`), lwd = 2)

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# expected impact ####

par(mfrow = c(4, 1), mar = c(2, 2, 2, 1))
# group 1
plot(NULL, xlim = c(-10, 60), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_impact_new[1]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_impact_new[1]`), lwd = 2)

# group 2
plot(NULL, xlim = c(-10, 60), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_impact_new[2]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_impact_new[2]`), lwd = 2)

# group 3
plot(NULL, xlim = c(-10, 60), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_impact_new[3]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_impact_new[3]`), lwd = 2)

# groyp 4
plot(NULL, xlim = c(-10, 60), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_impact_new[4]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_impact_new[4]`), lwd = 2)

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

