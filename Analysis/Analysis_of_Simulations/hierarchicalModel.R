#
# Fit hierarchical models to quantify what's going on after 
# 800 trials in the simulations. After this, png-plots will
# be done.
#
# Libraries required:
#  - Rstan
#
# Four models are fit:
# Y/N - standard deviations
# Y/N - squared error
# AFC - standard deviations
# AFC - squared error
#
# In all cases the groups are coded in such a way that POSITIVE beta coefficients 
# imply that the adaptive algorithm is more efficient.
#
# Set folders: 1) where to find "dataObjects_YN" and "dataObjects_AFC"
#              2) where to save figures
#              3) where to find stan models from

dataFolder   = "C:/Users/Joni/Documents/GitHub/Master_thesis/Simulation_and_experiment/Data/Simulation_data/"
figureFolder = "C:/Users/Joni/Documents/GitHub/Master_thesis/PDF/figures/"
stanFolder   = "C:/Users/Joni/Documents/GitHub/Master_thesis/Stan/"

load(paste(dataFolder, "dataObjects_YN.rdata", sep = ""))
load(paste(dataFolder, "dataObjects_AFC.rdata", sep = ""))

#### Compile stan model ####

library(rstan)
linmod_hiera = stan_model(paste(stanFolder, "hierarchical_linear.stan", sep = ""))

#### Collect data into lists ####

collectData = function(dataAdapt, dataRandom, N_param){
  x = c()
  y = c()
  param = c()
  
  for(i in 1:N_param){
    y_1 = dataAdapt[[i]][,800]
    y_2 = dataRandom[[i]][,800]
    
    x_0 = c(rep(0, length(y_1)), rep(1, length(y_2)))
    
    y = append(y, c(y_1, y_2))
    x = append(x, x_0)
    param = append(param, rep(i, length(x_0)))
  }
  
  y = (y - mean(y)) / sd(y)
  N = length(y)
  
  return(list(x = x, y = y, N = N, N_param = N_param, param = param))
}

data_YN_SD = list()
data_YN_sq_error = list()
data_AFC_SD = list()
data_AFC_sq_error = list()

# Calculate squared errors:
sq_error_YN_adapt = list()
sq_error_YN_rand  = list()

sq_error_AFC_adapt = list()
sq_error_AFC_rand  = list()

for(i in 1:9){
  sq_error_YN_adapt[[i]] = (dataObjects_YN$adaptive$muTheta[[i]]  - dataObjects_YN$adaptive$genTheta[,i])^2
  sq_error_YN_rand[[i]]  = (dataObjects_YN$random_fs$muTheta[[i]] - dataObjects_YN$random_fs$genTheta[,i])^2
}

for(i in 1:7){
  sq_error_AFC_adapt[[i]] = (dataObjects_AFC$adaptive$muTheta[[i]]  - dataObjects_AFC$adaptive$genTheta[,i])^2
  sq_error_AFC_rand[[i]]  = (dataObjects_AFC$random_fs$muTheta[[i]] - dataObjects_AFC$random_fs$genTheta[,i])^2  
}

# Collect data:

data_YN_SD = collectData(dataObjects_YN$adaptive$sdTheta, dataObjects_YN$random_fs$sdTheta, 9)
data_YN_sq_error = collectData(sq_error_YN_adapt, sq_error_YN_rand, 9)
data_AFC_SD = collectData(dataObjects_AFC$adaptive$sdTheta, dataObjects_AFC$random_fs$sdTheta, 7)
data_AFC_sq_error = collectData(sq_error_AFC_adapt, sq_error_AFC_rand, 7)

#### Fit models ####

fit_YN_SD = sampling(linmod_hiera, data = data_YN_SD, chains = 4, iter = 1500)
fit_YN_sq_error = sampling(linmod_hiera, data = data_YN_sq_error, chains = 4, iter = 1500)
fit_AFC_SD = sampling(linmod_hiera, data = data_AFC_SD, chains = 4, iter = 1500)
fit_AFC_sq_error = sampling(linmod_hiera, data = data_AFC_sq_error, chains = 4, iter = 1500)

#### Create plots ####

#
# Collect quantiles (95% and 50%) into matrices:

qs_YN_SD = matrix(NaN, ncol = 4, nrow = 9)
qs_YN_sq_error = matrix(NaN, ncol = 4, nrow = 9)

qs_AFC_SD = matrix(NaN, ncol = 4, nrow = 7)
qs_AFC_sq_error = matrix(NaN, ncol = 4, nrow = 7)

for(i in 1:9){
  qs_YN_SD[i,] =  quantile(extract(fit_YN_SD, pars = "slope")[[1]][,i], 
                           c(0.025, 0.25, 0.75, 0.975))
  qs_YN_sq_error[i,] =  quantile(extract(fit_YN_sq_error, pars = "slope")[[1]][,i], 
                                 c(0.025, 0.25, 0.75, 0.975))
}

for(i in 1:7){
  qs_AFC_SD[i,] =  quantile(extract(fit_AFC_SD, pars = "slope")[[1]][,i], 
                           c(0.025, 0.25, 0.75, 0.975))
  qs_AFC_sq_error[i,] =  quantile(extract(fit_AFC_sq_error, pars = "slope")[[1]][,i], 
                                 c(0.025, 0.25, 0.75, 0.975))
}

#

plotQuantiles = function(qs, parnames, N_param, mainTitle){
  
  plot(NULL, ylim = c(1, N_param), xlim = range(qs), axes = F,
       xlab = expression(paste(beta, "'")), ylab = "Parameter",
       main = mainTitle)
  
  abline(v = 0)
  abline(v = pretty(range(qs)), lty = 2)
  
  for(i in seq(1, N_param, 4)){
    polygon(c(range(qs), rev(range(qs))), c(i-0.5, i-0.5, i+1.5, i+1.5), 
            col = rgb(0, 0, 0, 0.2), 
            border = NA)
  }
  
  for(i in 1:N_param){
    lines(c(qs[i,c(1, 4)]), c(i, i), lwd = 4, lend = 1)
    lines(c(qs[i,c(2, 3)]), c(i, i), lwd = 8, lend = 1)
  }
  
  axis(side = 1)
  axis(side = 2, at = c(1.5 + 2 * 0:(length(parnames) - 2), N_param), 
       labels = parnames, las = 1)
}

#

parnames_YN = c(expression(sigma), 
                "crit", 
                expression(beta), 
                expression(paste(kappa, mu)),
                expression(rho))

parnames_AFC = c(expression(sigma), 
                expression(beta), 
                expression(paste(kappa, mu)),
                expression(rho))

# Save plots

png(filename = paste(figureFolder, "qs_YN_SD.png", sep = ""), 
    width = 5, height = 4, units = "in", res = 700)
plotQuantiles(qs_YN_SD, parnames_YN, 9, expression(paste("Y/N, marg.", sigma)))
dev.off()

png(filename = paste(figureFolder, "qs_YN_sq_error.png", sep = ""), 
    width = 5, height = 4, units = "in", res = 700)
plotQuantiles(qs_YN_sq_error, parnames_YN, 9, "Y/N, sq. error")
dev.off()

png(filename = paste(figureFolder, "qs_AFC_SD.png", sep = ""), 
    width = 5, height = 3.5, units = "in", res = 700)
plotQuantiles(qs_AFC_SD, parnames_AFC, 7, expression(paste("AFC, marg.", sigma)))
dev.off()

png(filename = paste(figureFolder, "qs_AFC_sq_error.png", sep = ""), 
    width = 5, height = 3.5, units = "in", res = 700)
plotQuantiles(qs_AFC_sq_error, parnames_AFC, 7, "AFC, sq. error")
dev.off()
