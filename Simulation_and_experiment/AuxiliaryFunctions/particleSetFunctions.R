#### FUNCTIONS RELATING TO OPERATIONS ON PARTICLE SETS, POSTERIOR EXPECTATIONS ####

initializeParticleSet = function(prior, experimentAttributes, priorParticleSet){
  #
  # prior: a list with vectors $sd and $mean
  # nParticles: integer, number of particles (duh)
  #
  # priorParticleSet = Particle set can be initialized based on a prior particle set
  #                    e.g. when continuing an experiment.
  #
  
  particleSet = list()
  
  particleSet$particles = matrix(NaN, ncol  = prior$nDim, 
                                 nrow = experimentAttributes$nParticles)
  
  if(!hasArg(priorParticleSet)){
    print("Sampling particles from prior...")
    for(i in 1:prior$nDim){
      particleSet$particles[,i] = rnorm(experimentAttributes$nParticles, prior$mean[i], prior$sd[i])
    }
    
    particleSet$w = rep(1/experimentAttributes$nParticles, 
                        experimentAttributes$nParticles)
  } else {
    print("Getting particles from the old particleset...")
    particleSet$particles = priorParticleSet$particles
    particleSet$w = priorParticleSet$w
  }
  
  particleSet$muTheta = matrix(NaN, nrow = experimentAttributes$nTrials, ncol = prior$nDim)
  particleSet$sdTheta = matrix(NaN, nrow = experimentAttributes$nTrials, ncol = prior$nDim)
  particleSet$covMats = array(NaN, dim = c(experimentAttributes$nTrials, prior$nDim, prior$nDim))
  
  return(particleSet)
}

resample = function(particleSet, t){
  
  particleSet$particles = mvtnorm::rmvnorm(nrow(particleSet$particles), mean = particleSet$muTheta[t,], 
                                                                        sigma = particleSet$covMats[t,,])
  particleSet$w = rep(1 / nrow(particleSet$particles), nrow(particleSet$particles))
  
  
  return(particleSet)
}

reweight = function(S, R, particleSet, pResp){
  #
  # Updates current estimates of posterior density by 
  # reweighting weights of a particle set based on the 
  # latest data point (latest stimulus and response pair)
  #
  # particleSet: list with elements $particles and $w
  #
  # S and R are expected to be two-dimensional vectors 
  # containing the latest stimulus and response pair
  #
  # pResp is a function for calculating the response probabilities
  #
  if(R[1] == -1 & R[2] == -1){
    ind = 1
  }
  if(R[1] == 1 & R[2] == -1){
    ind = 2
  }
  if(R[1] == -1 & R[2] == 1){
    ind = 3
  }
  if(R[1] == 1 & R[2] == 1){
    ind = 4
  }
  
  p = pResp(S, particleSet$particles)
  
  particleSet$w = particleSet$w * p[,ind]
  particleSet$w = particleSet$w / sum(particleSet$w)
  
  return(particleSet)
}

calculateEstimates = function(particleSet, t){
  # Provides some descriptive summaries of the posterior distribution
  # at time point t. 
  #
  # Current t is deduced from the number of non-nan values in the 
  # first column of the mu-matrix (in which posterior means are kept)
  
  # TODO: THIS IS A HORRIBLE HACK!!!
  # 
  # t = length(which(is.nan(particleSets[[1]]$muTheta[,1]) == F)) + 1
  # if(t == 0){
  #   stop("Attempting to calculate estimates when t = 0")
  # }
  
  nDim = ncol(particleSet$particles)
  
  covMat = matrix(NaN, nrow = nDim, ncol = nDim)
  
  muTheta = c()
  sdTheta = c()
   
  for(i in 1:nDim){
    muTheta[i] = sum(particleSet$particles[,i] * particleSet$w)
    sdTheta[i] = sqrt(sum((muTheta[i] - particleSet$particles[,i]) ^ 2 * particleSet$w))
  }
  
  for(i in 1:(nDim-1)){
    for(j in (i+1):nDim){
      covMat[j,i] = sum(particleSet$w * ((particleSet$particles[,i] - muTheta[i]) * 
                                           (particleSet$particles[,j] - muTheta[j])))
    }
  }
  
  diag(covMat) = sdTheta^2
  covMat = as.matrix(Matrix::forceSymmetric(covMat, uplo="L"))
  
  particleSet$muTheta[t,] = muTheta
  particleSet$sdTheta[t,] = sdTheta
  particleSet$covMats[t,,] = covMat
  
  return(particleSet)
}

doLaplaceApprox = function(S, R, NTrials, mdl){
  #
  # Does Laplace approximation in Stan for the stan model mdl (given as input)
  # S and R are expected to be matrices, ranging from 1 to nTrials (which can be 1)
  #
  
  fit = optimizing(mdl, data = 
                     list(NTrials = NTrials, 
                          S = S[1:NTrials,,drop=F], 
                          R = R[1:NTrials,,drop=F]), hessian = T)
                          
  covMat = as.matrix(Matrix::nearPD(solve(-fit$hessian))$mat)
  
  return(list(mu = fit$par, covMat = covMat))
}

testForDivergence = function(particleSets, t, prior){
# particleSets = a list of particle sets
# t = current trial
#
  
    for(i in 1:(length(particleSets) - 1)){
      for(j in 1:length(particleSets)){
        if(any(((particleSets[[i]]$muTheta[t,] - particleSets[[j]]$muTheta[t,]) / prior$sd) > 0.2)){
          #print("Divergence detected...")
          #flush.console()
          return(TRUE)
          break
        }
      }
    }
    return(FALSE)
}

