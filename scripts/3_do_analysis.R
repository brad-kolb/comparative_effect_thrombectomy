###### publication analysis ########

df <- readRDS(file = here("fits", "gq1_summary.RDS"))
data <- read_csv(here("data", "clean_data.csv"), show_col_types = FALSE)

#### expected likelihood without treatment ####
df_rd <- df %>% 
  filter(str_detect(variable, "x_epred")) %>% 
      #   !str_detect(variable, "rd_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

rd_obs <- data %>%
  mutate(rd_obs = r_c/n_c) %>% 
  select(K, rd_obs) 

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_rd$median) - 1)

# Define the offset value for separating control and treatment points
offset <- 0.1

pdf(here("plots", "chances.pdf"), width = 5, height = 4)
plot(df_rd$median, 1:4, xlim = c(0, max(50)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = NA,
     pch = 19,
     col = 1, main = "Chances without treatment")
obs <- rd_obs %>% 
  filter(K == 1) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 1 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 2) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 2 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 3) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 3 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 4) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 4 + offset, pch = 21, col = 1)
}

segments(df_rd$low, 1:4, df_rd$high, 1:4, col = 1)

axis(1, at = seq(0, 50, by = 10), labels = paste0(seq(0, 50, by = 10), "%"))

axis(2, at = 1:4, labels = df_rd$names, las = 2)

abline(v = 0, lty = 2, col = "grey")

legend("topright", legend = c("future", "past"),
       pch = c(19, 21), col = 1)

dev.off()

#### expected absolute improvement with treatment, percentage terms ####
df_rd <- df %>% 
  filter(str_detect(variable, "rd_epred"),
         !str_detect(variable, "rd_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

rd_obs <- data %>%
  mutate(rd_obs = (r_t/n_t) - (r_c/n_c)) %>% 
  select(K, rd_obs) 

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_rd$median) - 1)

# Define the offset value for separating control and treatment points
offset <- 0.1

pdf(here("plots", "rd.pdf"), width = 5, height = 4)
plot(df_rd$median, 1:4, xlim = c(0, max(50)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = NA,
     pch = 19,
     col = 1, main = "Absolute improvement in chances")
obs <- rd_obs %>% 
  filter(K == 1) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 1 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 2) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 2 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 3) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 3 + offset, pch = 21, col = 1)
}

obs <- rd_obs %>% 
  filter(K == 4) %>% 
  select(rd_obs) %>% 
  deframe()
for (i in 1:length(obs)) {
  points((obs*100)[i], 4 + offset, pch = 21, col = 1)
}

segments(df_rd$low, 1:4, df_rd$high, 1:4, col = 1)

axis(1, at = seq(0, 50, by = 10), labels = paste0(seq(0, 50, by = 10), "%"))

axis(2, at = 1:4, labels = df_rd$names, las = 2)

abline(v = 0, lty = 2, col = "grey")

legend("topright", legend = c("future", "past"),
       pch = c(19, 21), col = 1)

dev.off()


#### expected improvement with treatment, absolute vs relative ####
df <- readRDS(file = here("fits", "gq1_summary.RDS"))

df_rd <- df %>% 
  filter(str_detect(variable, "rd_epred"),
         !str_detect(variable, "rd_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = median * 100, low = low * 100, high = high * 100)

df_rr <- df %>% 
  filter(str_detect(variable, "rr_epred"),
         !str_detect(variable, "rr_epred_gt")) %>% 
  select("variable", "median", "low", "high") %>% 
  mutate(names = c("Large", "Small", "Late", "Basilar")) %>% 
  mutate(median = (median - 1) * 100, low = (low - 1) * 100, high = (high - 1) * 100)

# Calculate the amount of extra space (e.g., 20% of the plot height)
extra_space <- 0.2 * (length(df_rd$median) - 1)

# Define the offset value for separating control and treatment points
offset <- 0.1

pdf(here("plots", "jama.pdf"), width = 5, height = 4)
plot(df_rr$median, 1:4 + offset, xlim = c(0, max(df_rr$high)), 
     ylim = c(1 - extra_space, 4 + extra_space),
     yaxt = "n", xaxt = "n", ylab = NA, 
     xlab = NA, 
     pch = 18,
     col = 1, main = "Future predicted improvement in chances")
points(df_rd$median, 1:4 - offset, pch = 19, col = 1)

segments(df_rr$low, 1:4 + offset, df_rr$high, 1:4 + offset, col = 1)

segments(df_rd$low, 1:4 - offset, df_rd$high, 1:4 - offset, col = 1)

axis(1, at = seq(0, 250, by = 50), labels = paste0(seq(0, 250, by = 50), "%"))

axis(2, at = 1:4, labels = df_rr$names, las = 2)

abline(v = 0, lty = 2, col = "grey")

legend("topright", legend = c("relative", "absolute"),
       pch = c(18, 19), col = 1)

dev.off()



#### impact plots #####
colors <- c("#E69F00","#0072B2","#009E73","#56B4E9")
gq1 <- readRDS(here("fits", "gq1.RDS"))

df <- as_draws_array(gq1$draws("rd_pred[1]"))
df_plus <- df[df >= 1]
df_neg <- df[df < 1]

plot(NULL, xlim = c(-20, 60), ylim = c(0, 230), bty = 'n',
     xlab = 'predicted difference in functionally independent patients',
     ylab = 'Frequency',
     main = NA)
mtext("large")
lines(table(df_neg), lwd = 3, col = 8)
lines(table(df_plus), lwd = 3, col = 1)

legend("topright", 
       legend = c(
         paste0("P(<1) = ", format(length(df_neg)/length(df)*100, digits = 2), "%"),
         paste0("P(>1) = ", format(length(df_plus)/length(df)*100, digits = 2), "%")
       ), 
       col = c(8, 1), 
       pt.cex = 2, 
       pch = 15,
       bty = 'n')



##### NNT ######

gq1 <- readRDS(here("fits", "gq1.RDS"))

df <- gq1$draws("rd_pred[1]")
df_20 <- length(df[df >= 5])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df1 <- data.frame(name = "large", nnt = c("<20", "<10", "<5"), value = c(df_20, df_10, df_5))

df <- gq1$draws("rd_pred[2]")
df_20 <- length(df[df >= 5])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df2 <- data.frame(name = "small", nnt = c("<20", "<10", "<5"), value = c(df_20, df_10, df_5))

df <- gq1$draws("rd_pred[3]")
df_20 <- length(df[df >= 5])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df3 <- data.frame(name = "late", nnt = c("<20", "<10", "<5"), value = c(df_20, df_10, df_5))

df <- gq1$draws("rd_pred[4]")
df_20 <- length(df[df >= 5])/length(df)
df_10 <- length(df[df >= 10])/length(df)
df_5 <- length(df[df >=20])/length(df)
df4 <- data.frame(name = "basilar", nnt = c("<20", "<10", "<5"), value = c(df_20, df_10, df_5))

df <- rbind(df1, df2, df3, df4)

# Prepare the data
df$nnt <- factor(df$nnt, levels = c("<20", "<10", "<5"))

# Define colors for the groups
colors <- c("#E69F00","#0072B2","#009E73","#56B4E9") 
names <- unique(df$name)
names <- factor(names, levels = names)

# Set up the plot window with custom labels and limits, but don't draw anything yet
pdf(here("plots", "nnt.pdf"), width = 5, height = 5)
plot(NA, NA, type = "n", xlim = c(1, 3), ylim = c(0, 100),
     xlab = "NNT", ylab = "Probability", main = "Number needed to treat in new trial",
     xaxt = "n", yaxt = "n")

# Add custom x-axis labels
axis(1, at = 1:3, labels = levels(df$nnt))

# Add custom y-axis labels as percentages
axis(2, at = seq(10, 90, by = 40), labels = paste0(seq(10, 90, by = 40), "%"))

# Add lines and points for each group
for (i in 1:length(names)) {
  lines(1:3, df$value[df$name == names[i]] * 100, type = "b", col = colors[i], pch = 19)
}

# Add a legend
legend("topright", legend = c("small", "late", "basilar", "large"), 
       col = c("#0072B2","#009E73","#56B4E9","#E69F00" ), pch = 16, lty = 1)

dev.off()
