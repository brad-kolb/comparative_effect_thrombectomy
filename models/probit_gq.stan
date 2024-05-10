data {
  int<lower=1> N; // number observations
  int<lower=1> J; // number trials
  array[N] int<lower=1,upper=J> jj; // trial covariate
  array[N] int<lower=0,upper=1> x; // intervention covariate
}
parameters {
  real rho; 
  real<lower=0> sigma; 
  vector<offset=rho, multiplier=sigma>[J] phi; 
  real mu; 
  real<lower=0> tau;
  vector<offset=mu, multiplier=tau>[J] theta;
}
generated quantities{
  real phi_tilde = normal_rng(rho, sigma);
  real theta_tilde = normal_rng(mu, tau);
  vector[N] q_rep;
  for (n in 1:N) {
    q_rep[n] = phi_tilde + theta_tilde * x[n];
  }
  vector<lower=0>[N] y_rep = to_vector(bernoulli_rng(Phi(q_rep[1:N])));
}
