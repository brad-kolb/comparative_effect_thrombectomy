library(here)
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
plot(NULL, xlim = c(-100, 100), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_rd_new[1]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_rd_new[1]`), lwd = 2)

# group 2
plot(NULL, xlim = c(-100, 100), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_rd_new[2]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_rd_new[2]`), lwd = 2)

# group 3
plot(NULL, xlim = c(-100, 100), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_rd_new[3]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_rd_new[3]`), lwd = 2)

# groyp 4
plot(NULL, xlim = c(-100, 100), ylim = c(0,220),bty = 'n', ylab = NA, xlab = NA, yaxt = 'n')

lines(table(model_fits$all$skeptical$`y_rd_new[4]`), lwd = 1, col = 8)
abline(v = median(model_fits$all$skeptical$`y_rd_new[4]`), lwd = 2)

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# compatibility region ####
library(tidyverse)

dat <- data %>% 
  mutate(size = n_c + n_t) %>% 
  mutate(f_c = r_c/n_c) %>% 
  mutate(f_t = r_t/n_t)

title <- "Observed values"

plot(NULL , xlab="Control" , ylab="Treatment" , 
     bty='n',xlim=c(0,.9), ylim=c(0,.9))
abline(0,1,col=rethinking::col.alpha(1,0.2),lty=2)
mtext(paste0(title))

for (i in 1:22) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=1,pch=1,
         cex = dat$size[i]/200  # Scale point size based on z values
)
}

title <- "Observed values by stroke type"

plot(NULL , xlab="Control" , ylab="Treatment" , 
     bty='n',xlim=c(0,.9), ylim=c(0,.9))
abline(0,1,col=rethinking::col.alpha(1,0.2),lty=2)
mtext(paste0(title))

for (i in 1:5) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=2,pch=20)
}
for (i in 6:14) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=3,pch=20)
}
for (i in 15:18) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=4,pch=20)
}
for (i in 19:22) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=7,pch=20)
}

text(0.03, 0.26, "large", col=2)  
text(0.45, 0.62, "small", col=3)  
text(0.23, 0.45, "late", col=4)   
text(0.15, 0.25, "basilar", col=7)


make_compatibility_region <- function(title = "title",
                                      color = 1,
                                      index = 1, 
                                      x_prefix = "E_phi_new", 
                                      y_prefix = "E_psi_new") {
  require(ellipse)
  
  model_fits <- readRDS(here("fits", "group_fits.RDS"))
  
  x_col <- paste0(x_prefix, "[", index, "]")
  y_col <- paste0(y_prefix, "[",index, "]")
  
  x <- model_fits$all$skeptical[[x_col]]
  y <- model_fits$all$skeptical[[y_col]]
  
  # error checking
  if(is.null(x) || is.null(y)) {
    stop(sprintf("Could not find values for the specified columns: %s, %s", phi_col, psi_col))
  }
  
  plot(NULL , xlab="Control" , ylab="Treatment" , 
       bty='n',xlim=c(0,.9), ylim=c(0,.9))
  abline(0,1,col=rethinking::col.alpha(1,0.2),lty=2)
  mtext(paste0(title))
  xy_cov <- cov(cbind(x, y))
  xy_center <- c(mean(x), mean(y))
  
  # 51% region
  region <- ellipse(xy_cov, centre = xy_center, level=0.51)
  lines(rethinking::inv_logit(region) , col = rethinking::col.alpha(color, 0.2), 
        lwd=2)
  polygon(rethinking::inv_logit(region), col=rethinking::col.alpha(color, 0.2), 
          border=NA)
  # 95% region
  region <- ellipse(xy_cov, centre = xy_center, level=0.95)
  lines(rethinking::inv_logit(region) , col = rethinking::col.alpha(color, 0.2), 
        lwd=2)
  polygon(rethinking::inv_logit(region), col=rethinking::col.alpha(color, 0.2), 
          border=NA)

  # mean
  points(mean(rethinking::inv_logit(x)),
         mean(rethinking::inv_logit(y)), lwd=6, col="white")
  points(mean(rethinking::inv_logit(x)),
         mean(rethinking::inv_logit(y)), lwd=3,
         col=rethinking::col.alpha(1,0.5))
}

make_compatibility_region(title = "Large core", color = 2, index = 1)
for (i in 1:5) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=2,pch=20)
}

make_compatibility_region(title = "Small core", color = 3, index = 2)
for (i in 6:14) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=3, pch=20)
}

make_compatibility_region(title = "Late window", color = 4, index = 3)
for (i in 15:18) {
  points(dat$f_c[i],dat$f_t[i],lwd=1,col=4, pch=20)
}

make_compatibility_region(title = "Basilar", color = 7, index = 4)
for (i in 19:22) {
  points(dat$f_c[i],dat$f_t[i],lwd=1, col=7, pch=20)
}


