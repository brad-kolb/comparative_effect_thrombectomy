// meta-analysis using varying intercepts varying slopes logistic regression with binomial data,
// common treatment effect, and category-specific covariate for control log-odds

data {
  // data for posterior estimation
  int<lower=1> J; // trials
  int<lower=1> L; // arms (J*2)
  int<lower=1> K; // categories
  array[L] int<lower=1,upper=J> jj; // trial covariate
  array[L] int<lower=1,upper=L> ll; // arm covariate
  array[L] int<lower=1,upper=K> kk; // category covariate
  array[L] int<lower=0,upper=1> x; // intervention covariate
  array[L] int<lower=0> y; // number events in each arm
  array[L] int<lower=0> n;  // number of total observations in each arm
  // data for calculating pooling metrics
  array[J] real<lower=0> se_hat;
  // switches
  int<lower=0> estimate_posterior;   // switch for running model forward (prior predictive simulation) or backward (posterior estimation)
  int<lower=0> priors;  // switch for checking sensitivity of posterior to alternative prior assumptions
}
transformed data {
  // average within-study approximate sampling variance
  real se_hat_tot = sum(se_hat[1:J]) / (J * 1.0);
}
parameters {
  // control 
  real rho; 
  real<lower=0> sigma; 
  vector<offset=rho,multiplier=sigma> [J] phi; 
  vector[K] kappa_c; 
  // treatment
  real mu;  
  real<lower=0> tau; 
  vector<offset=mu,multiplier=tau> [J] theta; 


}
model {
  if (estimate_posterior == 1) {
  // linear model
  vector[L] q;
  for (i in 1:L) {
    q[i] = phi[jj[i]] + kappa_c[kk[i]] + theta[jj[i]] * x[i];
  }
  // likelihood
  y[1:L] ~ binomial(n[1:L], inv_logit(q[1:L]));
  }
  // hyperpriors
  phi[1:J] ~ normal(rho, sigma);
  theta[1:J] ~ normal(mu, tau);  
  // priors
  if (priors == 1) {
  rho ~ normal(-1, .5);
  sigma ~ normal(0, .5);
  mu ~ normal(0, .5);
  tau ~ normal(0, .5);
  kappa_c[1:K] ~ normal(0, .5); 
  } else { 
    mu ~ std_normal(); 
    rho ~ std_normal();
    sigma ~ std_normal();
    tau ~ std_normal();
    kappa_c[1:K] ~ std_normal();
  }
}
generated quantities {
  /// pooling metrics
  vector[J] p = 1 - (tau / (tau + to_vector(se_hat)));
  real<lower=0> I2 = tau / (tau + se_hat_tot);

  // event probabilities
  real mu_gt_0 = mu > 0;
  vector[J] theta_gt_0;
  for (i in 1:J) {
    theta_gt_0[i] = theta_gt_0[i] > 0 ? 1 : 0;
  }
}
