#include /bivariate_cdf.stan

data{
  int  NTrials;
  int  R[NTrials, 2];
  real S[NTrials, 2]; 
}

parameters{
  
  vector[2] sigma;
  vector[2] crit;
  vector[2] beta;
  vector[2] kappa;
  real rho; 
  
  real<lower = 0, upper = 1> lambda;
}

model{
  real zVals[2];
  real p[NTrials];
  real sigmas[2];
  
  sigma ~ normal(log(2.5), 0.75);
  crit  ~ normal(2.0, 1.00);
  beta  ~ normal(log(1), 0.30);
  
  kappa ~ normal(0, 1.00);
  
  rho ~ normal(0, 0.70);
  
  lambda ~ beta(2, 12);
  
  // Trial loop:
  for(t in 1:NTrials){ 
  
    sigmas[1] = exp(sigma[1] + kappa[1] * S[t,2]);
    sigmas[2] = exp(sigma[2] + kappa[2] * S[t,1]);
    
    zVals[1] = -crit[1]/sigmas[1] + pow(S[t,1] / 
      sigmas[1], exp(beta[1]));
    zVals[2] = -crit[2]/sigmas[2] + pow(S[t,2] / 
      sigmas[2], exp(beta[2]));
    
    p[t] = lambda * 0.25 + (1 - lambda) * 
      bivariate_cdf(R[t,1] * zVals[1], R[t,2] * zVals[2], 
      R[t,1] * R[t,2] * tanh(rho));
    
  }
  target += sum(log(p));
} 