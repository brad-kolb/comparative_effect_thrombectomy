// fixed effects meta-analysis
// adapted from www.mc-stan.org/docs/stan-users-guide/measurement-error.html

data {
  // data for posterior estimation
  int<lower=0> J; // number of studies
  array[J] int<lower=0> n_t;  // num cases, treatment
  array[J] int<lower=0> r_t;  // num successes, treatment
  array[J] int<lower=0> n_c;  // num cases, control
  array[J] int<lower=0> r_c;  // num successes, control
  // switch for running model forward (prior predictive simulation) or backward (posterior estimation)
  int<lower=0> estimate_posterior;
  // switch for priors (if set to 0, posterior will be estimated using improper priors)
  // this is essentially equivalent to frequentist maximum likelihood estimation
  int<lower=0> priors;
}
transformed data {
  array[J] real y; // observed log odds 
  array[J] real<lower=0> sigma; // approximate standard error 
  for (j in 1:J) {
    y[j] = log(r_t[j]) - log(n_t[j] - r_t[j])
    - (log(r_c[j]) - log(n_c[j] - r_c[j]));
  } // calculatees y for each study
  for (j in 1:J) {
    sigma[j] = sqrt(1.0 / r_t[j] + 1.0 / (n_t[j] - r_t[j]) 
    + 1.0 / r_c[j] + 1.0 / (n_c[j] - r_c[j]));
  } // calculates sigma for each study
}
parameters {
  real theta; // global treatment effect, log odds ratio
}
model {
  // likelihood
  if (estimate_posterior == 1) {
  y[1:J] ~ normal(theta, sigma[1:J]); // likelihood
  }
  // priors
  if (priors == 1) {
    theta ~ std_normal();
  }
}
generated quantities{
  // transformed data 
  array[J] real y_obs = y;
  array[J] real sigma_obs = sigma;
  real mean_y_obs = mean(y);
  real mean_sigma_obs = mean(sigma);
  // convert from log odds ratio to odds ratio
  real odds_ratio = exp(theta);
}
