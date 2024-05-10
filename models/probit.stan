// full bayesian implementation of a random-effects meta-analysis using probit regression

// in a fully Bayesian analysis, the goal is to estimate the joint posterior distribution of the parameters given the data and the priors and make predictions based on the posterior predictive distribution.
// the focus is on generating observable predictions rather than interpreting point-estimates for regression coefficients.
// here, we implement random effects meta-analysis using probit regression and full bayesian inference.
// probit regression is equivalent to logistic regression but the coefficients are less familiar.
// this can be seen as a feature, rather than a bug:
// 1. Reduces temptation to interpret coefficients: since the coefficients in probit regression represent changes in the z-score rather than log-odds (as in logistic regression), they are less intuitive and harder to interpret directly. 
// 2. Explicitly highlights the importance of working on the probability scale rather than the unconstrained log-odds or probit scale. 
// 3. Clarifies implications of the data being modeled for actual patient-level outcomes.

data {
  int<lower=1> N; // number observations
  int<lower=1> J; // number trials
  array[N] int<lower=1,upper=J> jj; // trial covariate
  array[N] int<lower=0,upper=1> x; // intervention covariate
  array[N] int<lower=0,upper=1> y; // outcome
  
  int<lower=0> estimate_posterior; // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors; // switch for checking sensitivity of posterior to alternative specification for priors
  int<lower=1> N_new;
  array[N_new] int<lower=0,upper=1> x_new;
}
parameters {
  real rho; // population mean baseline probit score (z-score) of success
  real<lower=0> sigma; // population sd of baseline probit scores
  vector<offset=rho, multiplier=sigma>[J] phi; // per trial baseline probit score of success
  
  real mu; // population mean treatment effect (difference in probit scores at baseline and with treatment)
  real<lower=0> tau; // population sd of treatment effects
  vector<offset=mu, multiplier=tau>[J] theta; // per trial treatment effect (probit score difference)
}
model {
  if (estimate_posterior == 1) {
  // linear model
  vector[N] q;
  for (n in 1:N) {
    q[n] = phi[jj[n]] + theta[jj[n]] * x[n];
  }
  // likelihood
  y[1:N] ~ bernoulli(Phi(q[1:N]));
  }
  // hyperpriors
  phi[1:J] ~ normal(rho, sigma);
  theta[1:J] ~ normal(mu, tau); 
  // priors
  mu ~ normal(0, 1); 
  rho ~ normal(0, 1);
  sigma ~ normal(0, 1); 
  tau ~ normal(0, 1);
}
generated quantities{
  real phi_tilde = normal_rng(rho, sigma);
  real theta_tilde = normal_rng(mu, tau);
  vector[N_new] q_new;
  for (n in 1:N_new) {
    q_new[n] = phi_tilde + theta_tilde * x_new[n];
  }
  vector[N_new] y_new = to_vector(bernoulli_rng(Phi(q_new[1:N_new])));
}

