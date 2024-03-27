// varying (random) effect meta-analysis
// adapted from www.mc-stan.org/docs/stan-users-guide/measurement-error.html

data {
  // data for posterior estimation
  int<lower=0> J; // num studies
  array[J] int<lower=0> n_t;  // num cases, treatment
  array[J] int<lower=0> r_t;  // num successes, treatment
  array[J] int<lower=0> n_c;  // num cases, control
  array[J] int<lower=0> r_c;  // num successes, control
  // switch for priors (if set to 0, posterior will be estimated using improper priors)
  // this is essentially equivalent to frequentist maximum likelihood estimation
  int<lower=0> estimate_posterior;
  // switch for priors
  int<lower=0> priors;
}
transformed data {
  array[J] real y; 
  array[J] real<lower=0> sigma;
  for (j in 1:J) {
    y[j] = log(r_t[j]) - log(n_t[j] - r_t[j]) 
    - (log(r_c[j]) - log(n_c[j] - r_c[j]));
  }
  for (j in 1:J) {
    sigma[j] = sqrt(1.0 / r_t[j] + 1.0 / (n_t[j] - r_t[j]) 
    + 1.0 / r_c[j] + 1.0 / (n_c[j] - r_c[j]));
  }
}
parameters {
  real mu; // mean treatment effect
  real<lower=0> tau; // deviation of treatment effects
  vector<offset=mu,multiplier=tau>[J] theta; // trial-specific treatment effects
}
model {
  // likelihood
  if (estimate_posterior == 1) {
  y[1:J] ~ normal(theta[1:J], sigma[1:J]);
  }
  // priors
  theta[1:J] ~ normal(mu, tau); 
  if (priors == 1) {
    mu ~ normal(0, 1); // prior on mean treatment effect
    tau ~ normal(0, 1);  // prior on deviation of treatment effects
  } else {
    mu ~ normal(0, 10);
    tau ~ cauchy(0, 5);
  }
}
generated quantities {
  vector[J] theta_or = exp(to_vector(theta));
  real mu_or = exp(mu);
  real theta_new = normal_rng(mu, tau); // posterior predictive distribution
  real theta_new_or = exp(theta_new); // odds ratio
}
