#include /bivariate_cdf.stan

data{
  int NTrials;
  vector[2] R[NTrials]; // Hierarkisessa R[NTrials, NParticipants]
  vector[2] S[NTrials]; 
}

parameters{
  
  vector[2] alpha;
  vector[2] crit;
  vector[2] beta;
  vector[2] kappa_mu;
  
  real rho; 
}

model{
  real zVals[2];
  real p[NTrials];
  
  alpha ~ normal(log(2.5), 0.75);
  crit  ~ normal(1.5, 0.30);
  beta  ~ normal(log(1), 0.30);
  
  kappa_mu ~ normal(0, 0.30);
  
  rho ~ normal(0, 0.70);
  
  // Trial loop:
  for(t in 1:NTrials){ 
    
    zVals[1] = -crit[1] + (pow(S[t][1] / exp(alpha[1]), exp(beta[1])) + kappa_mu[1] * S[t][2]);
    zVals[2] = -crit[2] + (pow(S[t][2] / exp(alpha[2]), exp(beta[2])) + kappa_mu[2] * S[t][1]);
    
    p[t] = 0.02 * 0.25 + 0.98 * bivariate_cdf(R[t][1] * zVals[1], R[t][2] * zVals[2], R[t][1] * R[t][2] * tanh(rho));
    
  }
  target += sum(log(p));
}
