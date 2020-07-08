#include /bivariate_cdf.stan

data{
  int  NTrials;
  real R[NTrials,2]; 
  real S[NTrials,2];   
}

parameters{
  real sigma[2];
  real crit[2];
  real beta[2];
  real kappa_mu[2];
  real<lower = 0> kappa_sig[2];
  
  real<lower = -0.8, upper = 0.8> rho; 
  real<lower = 0, upper = 1> lambda;
}

model{ 
  real p[NTrials];
  real zVals[2];
  
  sigma ~ normal(log(2.5), 0.75);
  
  for(i in 1:2){
    crit[i]/exp(sigma[i])  ~ normal(2.0, 1.00);
  }
  
  beta  ~ normal(log(1), 0.30);
  
  kappa_mu  ~ normal(0, 0.30); 
  kappa_sig ~ normal(0, 0.30);
  
  rho ~ uniform(-0.8, 0.8);
  lambda ~ beta(2, 48);  

  // Trial loop:
  for(t in 1:NTrials){ 
    
   zVals[1] = -crit[1] / exp(sigma[1] + kappa_sig[1] * S[t,2]) + 
    (pow(S[t,1] / exp(sigma[1] + kappa_sig[1] * S[t,2]), 
     exp(beta[1]))) + kappa_mu[1] * S[t,2];
   zVals[2] = -crit[2] / exp(sigma[2] + kappa_sig[2] * S[t,1]) + 
    (pow(S[t,2] / exp(sigma[2] + kappa_sig[2] * S[t,1]), 
     exp(beta[2]))) + kappa_mu[2] * S[t,1];
    
    p[t] = lambda * 0.25 + (1 - lambda) * 
      bivariate_cdf(R[t,1] * zVals[1], R[t,2] * zVals[2], 
     (R[t,1] * R[t,2]) * rho);
  }
  
  target += sum(log(p));
}
