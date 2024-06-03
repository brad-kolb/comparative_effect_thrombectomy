// varying (random) effect meta-analysis
// adapted from www.mc-stan.org/docs/stan-users-guide/measurement-error.html
data {
  int<lower=0> J; // num studies
  array[J] int<lower=0> n_t; // num cases, treatment
  array[J] int<lower=0> r_t; // num successes, treatment
  array[J] int<lower=0> n_c; // num cases, control
  array[J] int<lower=0> r_c; // num successes, control
  
  int<lower=0> estimate_posterior; // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors; // switch for checking sensitivity of posterior to alternative specification for priors
}
transformed data {
  array[J] real y; // log odds ratio for each study
  for (j in 1:J) {
    y[j] = log(r_t[j]) - log(n_t[j] - r_t[j]) 
    - (log(r_c[j]) - log(n_c[j] - r_c[j]));
  }
  
  array[J] real<lower=0> se; // standard error of y (inverse variance method)
  for (j in 1:J) {
    se[j] = sqrt(1.0 / r_t[j] + 1.0 / (n_t[j] - r_t[j]) 
    + 1.0 / r_c[j] + 1.0 / (n_c[j] - r_c[j]));
  }
}
parameters {
  real mu; // mean treatment effect
  real<lower=0> sigma; // deviation of treatment effects from the mean
  vector<offset=mu,multiplier=sigma>[J] theta; // trial-specific treatment effects
}
model {
  if (estimate_posterior == 1) {
  y[1:J] ~ normal(theta[1:J], se[1:J]);
  } 
  
  theta[1:J] ~ normal(mu, sigma); 
  if (priors == 1) { // "skeptical" priors
    mu ~ normal(0, 0.5); 
    sigma ~ normal(0, 0.5); 
  } else { // "diffuse" priors
    mu ~ normal(0, 1); 
    sigma ~ normal(0, 1); 
  }
}
generated quantities {
  vector[J] se2 = square(to_vector(se)); // approximate sampling variance for each study
  real se2_hat = sum(se2) / J; // average approximate sampling variance across all studies
  real<lower=0> i2 = square(sigma) / (square(sigma) + se2_hat); // proportion of total variance in effect size estimate due to heterogeneity between studies rather than sampling error
  vector[J] p = 1 - (square(sigma) / (square(sigma) + se2)); // proportion of variance in the trial_specific effect size estimate that is due to the true effect size rather than sampling error
  
  vector[J] theta_or = exp(to_vector(theta));
  real mu_or = exp(mu);
  
  real theta_new = normal_rng(mu, sigma); // posterior predictive distribution
  real theta_new_or = exp(theta_new); // odds ratio
}
