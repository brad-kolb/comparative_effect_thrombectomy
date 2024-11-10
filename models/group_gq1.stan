// posterior predictive quantities

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
generated quantities{
  // posterior predictive distribution //
  vector[L] q;
  for (i in 1:L) {
    q[i] = phi[jj[i]] + kappa_c[kk[i]] + theta[jj[i]] * x[i];
  }
  vector[L] p = inv_logit(q[1:L]);
  vector<lower=0>[L] y_tilde = to_vector(binomial_rng(n[1:L], p)); // posterior predictive distribution of the data
  
  // test statistics based on y_tilde
  
  vector<lower=0,upper=1>[L] freq_rep = y_tilde ./ (to_vector(n)); 
  
  vector[J] rr_rep; // risk ratio as replicated test statistic
  for (i in 1:J) {
    rr_rep[i] = freq_rep[2 * i] / freq_rep[2 * i - 1];
    }
  vector[J] rr_rep_gt_1;
  for (i in 1:J) {
    rr_rep_gt_1[i] = rr_rep[i] > 1 ? 1 : 0;
  }
  
  vector[J] rr_erep; // compare to expected value
  for (i in 1:J) {
    rr_erep[i] = p[2*i] / p[2*i-1];
  }
  vector[J] rr_erep_gt_1;
  for (i in 1:J) {
    rr_erep_gt_1[i] = rr_erep[i] > 1 ? 1 : 0;
  }
  
  vector[J] rd_rep; // risk difference as replicated test statistic
  for (i in 1:J) {
    rd_rep[i] = freq_rep[2*i] - freq_rep[2*i-1];
  }
  vector[J] rd_erep; // compare to expected value
  for (i in 1:J) {
    rd_erep[i] = p[2*i] - p[2*i-1];
  }
  
  // linear predictions (predicted log-odds)
  
  real theta_linpred = normal_rng(mu, tau); // common treatment effect
  real theta_linpred_gt_0 = theta_linpred > 0;

  vector[K] phi_linpred = normal_rng(rho, sigma) + kappa_c; // control group linear predictor
  vector[K] psi_linpred = theta_linpred + phi_linpred; // treatment group linear predictor
  
  // expected probabilities
  
  vector[K] x_epred = inv_logit(phi_linpred);
  vector[K] y_epred = inv_logit(psi_linpred);
  
  // predicted probabilities (estimation uncertainty plus sampling uncertainty)
  
  array[K] int x_pred = binomial_rng(100, x_epred);
  array[K] int y_pred = binomial_rng(100, y_epred);
  
  // predicted risk ratio and risk difference (both types of uncertainty)
  
  vector[K] rr_pred = to_vector(y_pred) ./ to_vector(x_pred);
  vector[K] rr_pred_gt_1;
  for (i in 1:K) {
    rr_pred_gt_1[i] = rr_pred[i] > 1 ? 1 : 0;
  }
  vector[K] rd_pred = to_vector(y_pred) - to_vector(x_pred);
  vector[K] rd_pred_gt_1;
  for (i in 1:K) {
    rd_pred_gt_1[i] = rd_pred[i] > 1 ? 1 : 0;
  }
  
  // compare to expected risk ratio and risk difference (just estimation uncertainty)
  
  vector[K] rd_epred = y_epred - x_epred;
  vector[K] rd_epred_gt_0;
  for (i in 1:K) {
    rd_epred_gt_0[i] = rd_epred[i] > 0 ? 1 : 0;
  }
  vector[K] rr_epred = y_epred ./ x_epred;
  vector[K] rr_epred_gt_1;
  for (i in 1:K) {
    rr_epred_gt_1[i] = rr_epred[i] > 1 ? 1 : 0;
  }
}
