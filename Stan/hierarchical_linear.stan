//
// Simple hierarchical linear model
// 
  
data{
  int  N;
  int  N_param;
  int  param[N];
  real x[N];
  real y[N];
}

parameters{
  // Hyperparameters
  real mu_intercept;
  real<lower = 0> sd_intercept;
  
  real mu_slope;
  real<lower = 0> sd_slope;
  
  real<lower = 0> mu_sdev;
  real<lower = 0> sd_sdev;
  
  // Individual parameters
  real intercept[N_param];
  real slope[N_param];
  
  real<lower = 0> sdev[N_param];
}

model{
  mu_intercept ~ std_normal();
  sd_intercept ~ std_normal();
  
  mu_slope ~ std_normal();
  sd_slope ~ std_normal();
  
  mu_sdev ~ std_normal();
  sd_sdev ~ std_normal();;
  
  intercept ~ normal(mu_intercept, sd_intercept);
  slope     ~ normal(mu_slope, sd_slope);
  
  sdev ~ normal(mu_sdev, sd_sdev);
  
  for(i in 1:N){
    y[i] ~ normal(intercept[param[i]] + slope[param[i]] * x[i], sdev[param[i]]);
  }
}
