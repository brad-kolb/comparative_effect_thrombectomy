// full bayesian implementation of a random-effects meta-analysis using probit regression

// In a fully Bayesian analysis, the goal is to estimate the joint posterior distribution of the parameters and make predictions based on the posterior predictive distribution.
// The focus is on generating observable predictions rather than interpreting point-estimates for regression coefficients.
// Here, we implement random effects meta-analysis using probit regression and full bayesian inference.
// Probit regression is equivalent to logistic regression but the coefficients are less familiar.
// This can be seen as a feature, rather than a bug, for the following reasons.
// 1. Reduces temptation to interpret coefficients: since the coefficients in probit regression represent changes in the z-score rather than log-odds (as in logistic regression), they are less intuitive and harder to interpret directly. 
// 2. Explicitly highlights the importance of working on the probability scale rather than the unconstrained log-odds or probit scale. 
// 3. Helps stakeholders and readers more easily appreciate the implications of the data being modeled for actual patient-level outcomes.

data {
  int<lower=1> N; // number observations
  int<lower=1> J; // number trials
  array[N] int<lower=1,upper=J> jj; // trial covariate
  array[N] int<lower=0,upper=1> x; // intervention covariate
  array[N] int<lower=0,upper=1> y; // outcome
  
  int<lower=0> estimate_posterior; // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors; // switch for checking sensitivity of posterior to alternative specification for priors
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
generated quantities {
  // clinically interesting posterior distributions
  // marginal posterior distribution for the mean value of a hyperparameter
  // difficult to interpret, even when transformed to the probability scale!!!
  real risk_control_average = 100 - Phi(rho);
  real risk_treatment_average = 100 - Phi(mu);
  real arr_average = risk_control_average - risk_treatment_average;
  real rr_average = arr_average / risk_control_average;
  
  // clinically interesting posterior predictive distributions 
  // anticipated control and treatment group risks in a new trial
  // easier to interpret!!!!
  // still not observable!!!
  real phi_new = normal_rng(rho,sigma); 
  real theta_new = normal_rng(mu,tau); 
  real risk_control_new = 100 - Phi(phi_new);
  real risk_treatment_new = 100 - Phi(phi_new + theta_new);
  real arr_new = risk_control_new - risk_treatment_new; // absolute risk reduction!
  real rr_new = arr_new / risk_control_new; // relative risk reduction !
  
  // clinically interesting posterior predictive simulations
  // anticipated patient-level observable outcomes in a new trial
  // easiest to interpret!!!
  int y_control_new = binomial_rng(100, risk_control_new);
  int y_treatment_new = binomial_rng(100, risk_treatment_new);
  int y_difference_new = y_treatment_new - y_control_new; // anticipated net patient-level impact (what actually matters!)
}

