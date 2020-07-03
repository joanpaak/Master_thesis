#

pRespYN = function(S, theta){
  
  if(!is.matrix(theta)){
    theta = t(as.matrix(theta))
  }
  
  NParticles = nrow(theta)
  
  zVals = matrix(NaN, nrow = NParticles, ncol = 2)
  
  zVals[,1] = -theta[,3] + ((S[1] / exp(theta[,1])) ^ exp(theta[,5]) + theta[,7] * S[2])
  zVals[,2] = -theta[,4] + ((S[2] / exp(theta[,2])) ^ exp(theta[,6]) + theta[,8] * S[1])
  
  rho = tanh(theta[,9])
 
  p = LUT$p(zVals[,1], zVals[,2], rho)
 
  p = 0.25 * 0.02 + 0.98 * p
  
  return(p)
}

pRespAFC = function(S, theta){
  
  if(!is.matrix(theta)){
    theta = t(as.matrix(theta))
  }
  
  NParticles = nrow(theta)
  
  zVals = matrix(NaN, nrow = NParticles, ncol = 2)
  
  zVals[,1] = (S[1] / exp(theta[,1])) ^ exp(theta[,3]) / sqrt(2) + theta[,5] * S[2]
  zVals[,2] = (S[2] / exp(theta[,2])) ^ exp(theta[,4]) / sqrt(2) + theta[,6] * S[1]
  
  rho = tanh(theta[,7])
  
  p = LUT$p(zVals[,1], zVals[,2], rho)
  p = 0.25 * 0.02 + 0.98 * p
  
  return(p)
}

genResp = function(S, theta, pResp){
  #
  # pResp: a function for calculating the response probilities
  # 
  p = pResp(S, theta)
  
  r = sample(1:4, 1, F, p)
  # Returns should correspond to the multipliers inside the bivarate gaussian CDF:
  if(r == 1){
    return(c(-1, -1))
  }
  if(r == 2){
    return(c(1, -1))
  }
  if(r == 3){
    return(c(-1, 1))
  }
  if(r == 4){
    return(c(1, 1))
  }
}


preComputePArrays = function(stimSet, particleSet, pResp){
  #
  # Pre-computes response probabilities given stimulus values (in stimSet)
  # and combinations of parameter values (in particleSet)
  #
  # stimSet      = list with vectors $xVals and $yVals
  # particleSet  = list with a matrix $particles and $w (weights)
  
  
  preComputedP = array(NaN, dim = c(length(stimSet$xVals), 
                                    length(stimSet$yVals), nrow(particleSet$particles), 4))
  
  for(i in 1:length(stimSet$xVals)){
    for(j in 1:length(stimSet$yVals)){
      preComputedP[i,j,,] = pResp(c(stimSet$xVals[i], stimSet$yVals[j]), particleSet$particles)
    }
  } 
  return(preComputedP)
}

#### PRIORS AND THETA GENERATING DISTRIBUTIONS ####

loadPrior = function(){
  #
  # Returns a list of two elements:
  # $prior = prior as a string table
  # $p = prior as a numeric matrix
  #
  
  
  # TODO: tryCatch
  # tryCatch(expr = { read.table("Ksdk")},
  #          catch = {stop("Couldn't load prior file.")})
  # 
  
  prior = read.table("Priors.dat", header = T)
  
  p = sapply(as.matrix(prior), function(x) {eval(expr = parse(text = toString(x)))})
  p = matrix(as.vector(p), ncol = 5, nrow = 5)
  
  return(list(prior = prior, p = p))
}

drawGeneratingTheta = function(typeOfExperiment){
  #
  # Information about prior distributions is stored in the 
  # file "Prior.dat". This is used for both conditions: 
  # in the forced choice condition priors for criteria 
  # are skipped.
  #
  
  p = loadPrior()$p
  
  theta = numeric(9)
  
  # Sigmas:
  theta[1] = c(rnorm(1, p[1,3], p[1,5]), 
               rnorm(1, p[1,4], p[1,5]))[sample(1:2, 1)]
  theta[2] = c(rnorm(1, p[1,3], p[1,5]), 
               rnorm(1, p[1,4], p[1,5]))[sample(1:2, 1)]
  
  # Criteria:
  theta[3] = c(rnorm(1, p[2,3], p[2,5]), 
               rnorm(1, p[2,4], p[2,5]))[sample(1:2, 1)]
  theta[4] = c(rnorm(1, p[2,3], p[2,5]), 
               rnorm(1, p[2,4], p[2,5]))[sample(1:2, 1)]
  
  # Betas:
  theta[5] = c(rnorm(1, p[3,3], p[3,5]), 
               rnorm(1, p[3,4], p[3,5]))[sample(1:2, 1)]
  theta[6] = c(rnorm(1, p[3,3], p[3,5]), 
               rnorm(1, p[3,4], p[3,5]))[sample(1:2, 1)]
  
  # Kappa
  theta[7] = c(rnorm(1, p[4,3], p[4,5]), 
               rnorm(1, p[4,4], p[4,5]))[sample(1:2, 1)]
  theta[8] = c(rnorm(1, p[4,3], p[4,5]), 
               rnorm(1, p[4,4], p[4,5]))[sample(1:2, 1)]
  
  # Rho:
  theta[9] = c(rnorm(1, p[5,3], p[5,5]), rnorm(1, p[5,4], p[5,5]))[sample(1:2, 1)]
 
  if(grepl("YesNo", typeOfExperiment)){
    return(theta)

  } else if(grepl("AFC", typeOfExperiment)){
    # Yeah I know this is kind of a hack, but deal with it
    return(theta[c(1, 2, 5, 6, 7, 8, 9)])
    
  } else {
    stop("Couldn't draw generating theta, did not recognize type of experiment (variable: typeOfExperiment).")
  }
}

setPrior = function(typeOfExperiment){
  #
  # Information about prior distributions is stored in the 
  # file "Prior.dat". This is used for both conditions: 
  # in the forced choice condition priors for criteria 
  # are skipped.
  
  p = loadPrior()$p
  
  if(grepl("YesNo", typeOfExperiment)){
    return(list(
      mean = p[c(1,1,2,2,3,3,4,4,5),1],
      sd   = p[c(1,1,2,2,3,3,4,4,5),2],
      nDim = 9))
  } else if(grepl("AFC", typeOfExperiment)){
    return(list(
      mean = p[c(1,1,3,3,4,4,5),1],
      sd   = p[c(1,1,3,3,4,4,5),2],
      nDim = 7))
  } else {
    stop("Couldn't set prior, did not recognize type of experiment (variable: typeOfExperiment).")
  }
  
}


