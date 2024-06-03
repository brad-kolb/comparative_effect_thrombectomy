data {
  int<lower=1> J; // total number of trials
  int<lower=1> K; // total number of trial types
  int<lower=1> N;  // total number of arms across all trials
  array[N] int<lower=1,upper=J> j;  // trial ID for each arm
  array[N] int<lower=1,upper=K> k; // trial type ID for each arm
  array[N] int<lower=0,upper=1> x;  // intervention covariate (0 for control, 1 for treatment)
  array[N] int<lower=0> y;  // number of successes (patients with positive outcome) in each arm
  array[N] int<lower=0> n;  // number of patients in each arm
  int<lower=0> estimate_posterior;  // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors;  // switch for checking sensitivity of posterior to alternative specification for priors
}
parameters {
  real rho;  // population mean baseline probit score (z-score) of success
  real<lower=0> sigma;  // population sd of baseline probit scores
  vector<offset=rho, multiplier=sigma>[J] phi;  // per trial baseline probit score of success
  real mu;  // population mean treatment effect (difference in probit scores at baseline and with treatment)
  real<lower=0> tau;  // population sd of treatment effects
  vector<offset=mu, multiplier=tau>[J] theta;  // per trial treatment effect (probit score difference)
  vector[K] beta_control;
  vector[K] beta_treatment;
}
model {
  if (estimate_posterior == 1) {
    // linear model
    vector[N] q;
    for (i in 1:N) {
      q[i] = phi[j[i]] + beta_control[k[i]] + (theta[j[i]] + beta_treatment[k[i]]) * x[i];
    }
    // likelihood
    y[1:N] ~ binomial(n[1:N], Phi(q[1:N]));
  }
  // hyperpriors
  phi[1:J] ~ normal(rho, sigma);
  theta[1:J] ~ normal(mu, tau);
  // priors
  if (priors == 1) {
  mu ~ normal(0, 1);
  rho ~ normal(0, 1);
  sigma ~ normal(0, 1);
  tau ~ normal(0, 1);
  
  beta_control[1:K] ~ normal(0,1);
  beta_treatment[1:K] ~ normal(0,1);
  }
}
