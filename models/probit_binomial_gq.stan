data {
  int<lower=1> J; // total number of trials
  int<lower=1> K; // total number of trial types
  int<lower=1> N;  // total number of arms across all trials
  array[N] int<lower=1,upper=J> j;  // trial ID for each arm
  array[N] int<lower=1,upper=K> k; // trial type ID for each arm
  array[N] int<lower=0,upper=1> x;  // intervention covariate (0 for control, 1 for treatment)
  array[N] int<lower=0> n;  // number of patients in each arm
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
generated quantities{
    // marginal effect in each trial
  vector<lower=0,upper=1>[N] p;
  for (i in 1:N) {
    p[i] = Phi(phi[j[i]] + beta_control[k[i]] + (theta[j[i]] + beta_treatment[k[i]]) * x[i]);
  }
  vector[N%/%2] arr;
  for (i in 1:N%/%2) {
    arr[i] = p[2 * i] - p[2 * i - 1];
  }
  // posterior predictive check
  vector<lower=0>[N] y_tilde = to_vector(binomial_rng(n[1:N], p));
  vector<lower=0>[N] p_tilde = y_tilde ./ to_vector(n);
  vector[N%/%2] arr_tilde;
  for (i in 1:N%/%2) {
    arr_tilde[i] = p_tilde[2*i] - p_tilde[2*i - 1];
  }
  // average effect across trials
  vector[K] p_control_av = Phi(rho + beta_control);
  vector[K] p_treatment_av = Phi(rho + beta_control + mu + beta_treatment);
  vector[K] arr_av = p_treatment_av - p_control_av;
  // anticipated effect in the next trial
  vector[K] p_control_next = Phi(normal_rng(rho, sigma) + beta_control);
  vector[K] p_treatment_next = Phi(normal_rng(rho, sigma) + beta_control + normal_rng(mu, tau) + beta_treatment);
  vector[K] arr_next = p_treatment_next - p_control_next;
}
