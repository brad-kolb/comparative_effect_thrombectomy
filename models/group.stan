// varying intercepts varying slopes metaanalysis with binomial data,
// group level covariates for control and treatment,
// non-centered parameterization

data {
  // data for posterior estimation
  int<lower=1> J; // trials
  int<lower=1> L; // arms (J*2)
  int<lower=1> K; // categories
  array[L] int<lower=1,upper=J> jj; // trial covariate
  array[L] int<lower=1,upper=L> ll; // arm covariate
  array[L] int<lower=1,upper=K> kk; // group covariate
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
  // treatment
  real mu; 
  real<lower=0> tau; 
  vector<offset=mu,multiplier=tau> [J] theta; 
  // category
  vector[K] kappa;
}
model {
  if (estimate_posterior == 1) {
  // linear model
  vector[L] q;
  for (i in 1:L) {
    q[i] = phi[jj[i]] + kappa[kk[i]] + theta[jj[i]] * x[i];
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
  kappa[1:K] ~ normal(0, .5);
  } else { 
    mu ~ std_normal(); 
    rho ~ std_normal();
    sigma ~ std_normal();
    tau ~ std_normal();
    kappa[1:K] ~ std_normal();
  }
}
generated quantities {
  /// pooling metrics
  vector[J] p = 1 - (tau / (tau + to_vector(se_hat)));
  real<lower=0> I2 = tau / (tau + se_hat_tot);
  
  // marginal effects (risk ratios and risk differences)
  vector[K] E_phi = rho + kappa;
  vector[K] E_psi = E_phi + mu;
  vector[K] E_y_c = inv_logit(E_phi);
  vector[K] E_y_t = inv_logit(E_psi);
  vector[K] E_rd = E_y_t - E_y_c;
  vector[K] E_rr = E_y_t./E_y_c;
  
  // posterior predictive distributions, log odds scale
  real E_theta_new = normal_rng(mu, tau);
  vector[K] E_phi_new = normal_rng(rho, sigma) + kappa;
  vector[K] E_psi_new = E_theta_new + E_phi_new;
  vector[K] E_y_c_new = inv_logit(E_phi_new);
  vector[K] E_y_t_new = inv_logit(E_psi_new);
  vector[K] E_rd_new = E_y_t_new - E_y_c_new;
  vector[K] E_rr_new = E_y_t_new./E_y_c_new;
  
  // *** forecasted patient level impact in a completely new trial *** //
  array[K] int y_c_new = binomial_rng(100, E_y_c_new);
  array[K] int y_t_new = binomial_rng(100, E_y_t_new);
  vector[K] y_impact_new = to_vector(y_t_new) - to_vector(y_c_new);
  

}
