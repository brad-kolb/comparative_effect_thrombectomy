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
  array[J] int<lower=0> n_t;  // num cases, treatment
  array[J] int<lower=0> r_t;  // num successes, treatment
  array[J] int<lower=0> n_c;  // num cases, control
  array[J] int<lower=0> r_c;  // num successes, control
  // switches
  int<lower=0> compute_likelihood;   // switch for running model forward (prior predictive simulation) or backward (posterior estimation)
  int<lower=0> priors;  // switch for checking sensitivity of posterior to alte
}
transformed data {
  array[J] real<lower=0> se2; // within-study approximate sampling variance 
  for (j in 1:J) {
    se2 [j] = 1.0 / r_t[j] + 1.0 / (n_t[j] - r_t[j]) 
    + 1.0 / r_c[j] + 1.0 / (n_c[j] - r_c[j]);
  }
  // average within-study approximate sampling variances by group and overall 
  real se2_large = sum(se2[1:5]) / 5.0; 
  real se2_small = sum(se2[6:14]) / 9.0; 
  real se2_late = sum(se2[15:18]) / 4.0;
  real se2_bas = sum(se2[19:22]) / 4.0;
  real se2_tot = sum(se2[1:22]) / 22.0;
}
parameters {
  // control 
  real rho; 
  real<lower=0> sigma;
  vector<offset=rho,multiplier=sigma> [J] alpha; 
  // treatment
  real mu; 
  real<lower=0> tau; 
  vector<offset=mu,multiplier=tau> [J] beta; 
  // category
  vector[K] kappa_cont; 
  vector[K] kappa_treat; 
}
model {
  if (compute_likelihood == 1) {
  // linear model
  vector[L] q;
  for (i in 1:L) {
    q[i] = (alpha[jj[i]] + kappa_cont[kk[i]]) +
    (beta[jj[i]] + kappa_treat[kk[i]]) * x[i];
  }
  // likelihood
  y[1:L] ~ binomial(n[1:L], inv_logit(q[1:L]));
  }
  // hyperpriors
  alpha[1:J] ~ normal(rho, sigma);
  beta[1:J] ~ normal(mu, tau); 
  // priors
  if (priors == 1) {
  rho ~ normal(-1, 1);
  sigma ~ normal(0, 1);
  mu ~ normal(0, 1);
  tau ~ normal(0, 1);
  kappa_cont[1:K] ~ normal(0, 1);
  kappa_treat[1:K] ~ normal(0,1);
  } else { 
    mu ~ std_normal(); 
    rho ~ std_normal();
    sigma ~ std_normal();
    tau ~ std_normal();
    kappa_cont[1:K] ~ normal(0, 1);
    kappa_treat[1:K] ~ normal(0,1);
  }
}
generated quantities {
  // trial baseline log odds
  vector[5] phi_large = alpha[1:5] + kappa_cont[1];
  vector[9] phi_small = alpha[6:14] + kappa_cont[2];
  vector[4] phi_late = alpha[15:18] + kappa_cont[3];
  vector[4] phi_bas = alpha[19:22] + kappa_cont[4];
  // group average baseline log odds
  vector[K] psi = rho + kappa_cont;
  // trial treatment effect
  vector[5] theta_large = beta[1:5] + kappa_treat[1];
  vector[9] theta_small = beta[6:14] + kappa_treat[2];
  vector[4] theta_late = beta[15:18] + kappa_treat[3];
  vector[4] theta_bas = beta[19:22] + kappa_treat[4];
  // group average treatment effect
  vector[K] delta = mu + kappa_treat;
}
