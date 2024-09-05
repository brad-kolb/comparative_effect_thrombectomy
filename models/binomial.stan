// varying intercepts varying slopes metaanalysis with binomial data,
// non-centered parameterization

data {
  int<lower=1> J; // total number of studies
  int<lower=1> L;  // total number of arms (each study has two arms)
  array[L] int<lower=1,upper=J> jj;  // study ID
  array[L] int<lower=1,upper=L> ll; // arm ID
  array[L] int<lower=0,upper=1> x;  // intervention covariate 
  array[L] int<lower=0> y;  // number of events in each arm
  array[L] int<lower=0> n;  // number of observations in each arm
  // data for calculating pooling metrics
  array[J] real<lower=0> se_hat;
  // switches
  int<lower=0> estimate_posterior;  // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors;  // switch for checking sensitivity of posterior to alternative specification for priors
}
transformed data {
  // average within-study approximate sampling variance
  real se_hat_tot = sum(se_hat[1:J]) / (J * 1.0);
}
parameters {
  real rho;  // population mean baseline log odds
  real<lower=0> sigma;  // population sd of baseline log odds
  vector<offset=rho, multiplier=sigma>[J] phi;  // per study baseline log odds
  real mu;  // population mean treatment effect (difference in log odds of outcome at baseline and with treatment)
  real<lower=0> tau;  // population sd of treatment effects
  vector<offset=mu, multiplier=tau>[J] theta;  // per study treatment effect (log odds difference)
}
model {
  if (estimate_posterior == 1) {
    // linear model
    vector[L] q;
    for (i in 1:L) {
      q[i] = phi[jj[i]] + theta[jj[i]] * x[i];
    }
    // likelihood
    y[1:L] ~ binomial(n[1:L], inv_logit(q[1:L]));
  }
  // hyperpriors
  phi[1:J] ~ normal(rho, sigma);
  theta[1:J] ~ normal(mu, tau);
  // priors
  if (priors == 1) {
  rho ~ normal(-1, 1);
  sigma ~ normal(0, 1);
  mu ~ normal(0, 1);
  tau ~ normal(0, 1);
  } else { 
    mu ~ std_normal(); 
    rho ~ std_normal();
    sigma ~ std_normal();
    tau ~ std_normal();
  }
}
generated quantities {
  /// pooling metrics
  vector[J] p = 1 - (tau / (tau + to_vector(se_hat)));
  real<lower=0> I2 = tau / (tau + se_hat_tot);
  // next trial forecasting, log odds scale
  real E_theta_next = normal_rng(mu, tau);
  real E_phi_next = normal_rng(rho, sigma);
  real E_psi_next = E_theta_next + E_phi_next;
  real E_y_next_cont = inv_logit(E_phi_next);
  real E_y_next_treat = inv_logit(E_psi_next);
  real E_arr_next = E_y_next_treat - E_y_next_cont;
  // expected trial-specific event probability for treatment and control arms
  vector<lower=0,upper=1>[L] E_y_tilde;
  for (i in 1:L) {
    E_y_tilde[i] = inv_logit(phi[jj[i]] + theta[jj[i]] * x[i]);
  }
  vector[J] E_arr_tilde;
  for (i in 1:J) {
    E_arr_tilde[i] = E_y_tilde[2 * i] - E_y_tilde[2 * i - 1];
  }
  // posterior predictive distributions (ppds) of interest 
  // ppd of observed events for each arm of each trial
  vector<lower=0>[L] y_tilde = to_vector(binomial_rng(n[1:L], E_y_tilde)); 
  // ppd of trial specific observed event frequencies 
  vector<lower=0>[L] freq_tilde = y_tilde ./ (to_vector(n));
  // ppd of trial specific observed absolute risk reductions
  // the range of expected observations if each individual trial were to be repeated
  // given what we have observed in all the trials already
  vector[J] arr_tilde;
  for (i in 1:J) {
    arr_tilde[i] = freq_tilde[2 * i] - freq_tilde[2 * i - 1];
  }
}
