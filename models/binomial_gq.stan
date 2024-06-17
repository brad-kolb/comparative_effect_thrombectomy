data {
  int<lower=1> J; // total number of studies
  int<lower=1> L;  // total number of arms (each study has two arms)
  array[L] int<lower=1,upper=J> jj;  // study ID
  array[L] int<lower=1,upper=L> ll; // arm ID
  array[L] int<lower=0,upper=1> x;  // intervention covariate 
  array[L] int<lower=0> y;  // number of events in each arm
  array[L] int<lower=0> n;  // number of observations in each arm
  int<lower=0> estimate_posterior;  // switch for estimating posterior vs running prior predictive simulation
  int<lower=0> priors;  // switch for checking sensitivity of posterior to alternative specification for priors
}
parameters {
  real rho;  // population mean baseline log odds
  real<lower=0> sigma;  // population sd of baseline log odds
  vector<offset=rho, multiplier=sigma>[J] phi;  // per study baseline log odds
  real mu;  // population mean treatment effect (difference in log odds of outcome at baseline and with treatment)
  real<lower=0> tau;  // population sd of treatment effects
  vector<offset=mu, multiplier=tau>[J] theta;  // per study treatment effect (log odds difference)
}
generated quantities{
  // parameters of interest -------------------
  // trial specific odds ratio
  vector[J] oddsratio;
  for (i in 1:J) {
    oddsratio[i] = exp(theta[i]);
  }
  // population odds ratio
  real popor = normal_rng(mu, tau);
  
  // population level marginal effects of interest ---------------
  real y_marg_cont = inv_logit(rho);
  real y_marg_treat = inv_logit(rho + mu);
  real rr_marg = y_marg_treat / y_marg_cont;
  real arr_marg= y_marg_treat - y_marg_cont;
  
  // expected trial-specific event probability for treatment and control arms ------
  vector<lower=0,upper=1>[L] E_y_tilde;
  for (i in 1:L) {
    E_y_tilde[i] = inv_logit(phi[jj[i]] + theta[jj[i]] * x[i]);
  }
  // expected trial-specific relative risk
  vector[J] E_rr_tilde;
  for (i in 1:J) {
    E_rr_tilde[i] = E_y_tilde[2 * i] / E_y_tilde[2 * i - 1];
  }
  // expected trial-specific absolute risk reduction
  vector[J] E_arr_tilde;
  for (i in 1:J) {
    E_arr_tilde[i] = E_y_tilde[2 * i] - E_y_tilde[2 * i - 1];
  }
  
  // posterior predictive distributions (ppds) of interest ---------------------------
  // ppd of events for each arm of each trial
  vector<lower=0>[L] y_tilde = to_vector(binomial_rng(n[1:L], E_y_tilde)); 
  // ppd of trial specific event rates 
  vector<lower=0>[L] risk_tilde = y_tilde ./ (to_vector(n));
  // ppd of trial specific relative effects
  vector[J] rr_tilde;
  for (i in 1:J) {
    rr_tilde[i] = risk_tilde[2 * i] / risk_tilde[2 * i - 1];
  }
  vector[J] arr_tilde;
  for (i in 1:J) {
    arr_tilde[i] = risk_tilde[2 * i] - risk_tilde[2 * i - 1];
  }
  // next trial prediction
  real E_y_next_cont = inv_logit(normal_rng(rho, sigma));
  real E_y_next_treat = inv_logit(normal_rng(rho, sigma) + normal_rng(mu, tau));
  real E_arr_next = E_y_next_treat - E_y_next_cont;
  real E_rr_next = E_y_next_treat / E_y_next_cont;
}

