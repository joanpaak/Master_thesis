# DO NOT RUN THIS FILE BY ITSELF:
# This needs a bunch of functions and other sorts of crap to work:
# these can be found from e.g. runMultipleYesNo.R file
# A Yes/No-experiment
#
# Supports either entropy-based or random sampling of stimuli
#
#
#

# setwd("C:/Users/Joni/Desktop/Thesis/Simulation_final")

runSimulations = function(nSimulations, experimentAttributes, folder, saveFile = F){
  
  
  typeOfExperiment = "YesNo_stimCat"
  participantName = "Simulation"
  
  dataFolder = paste("Data/", folder, "/", sep = "")
  
  print("Initializing the experiment...")
  
  ## Some attributes for you to set, like number of trials, et:
  
  # experimentAttributes = fixed attributes of the experiment
  
  prior = setPrior(typeOfExperiment)
  
  #
  for(sim in 1:nSimulations){
    
    print("Starting simulation...")
    S = matrix(NaN, nrow = experimentAttributes$nTrials, ncol = 2)
    R = matrix(NaN, nrow = experimentAttributes$nTrials, ncol = 2)
     
    print("Creating a new particle set")
    particleSets = list()
    particleSets[[1]] = initializeParticleSet(prior, experimentAttributes)
    particleSets[[2]] = initializeParticleSet(prior, experimentAttributes)
    particleSets[[3]] = initializeParticleSet(prior, experimentAttributes)
    
    
    stimSet = computeStimRanges(apply(particleSets[[1]]$particles, 2, mean), 
                                apply(particleSets[[1]]$particles, 2, sd), typeOfExperiment)
      
    
    
    stimCat = sample(1:4, experimentAttributes$nTrials, T)
    
    ## Precomputation
    preComputedP = preComputePArrays(stimSet, particleSets[[1]], experimentAttributes$pResp)  
    
    genTheta = drawGeneratingTheta(typeOfExperiment)
    
    for(t in 1:experimentAttributes$nTrials){
      startTime = Sys.time()
      
      # Pick stimulus
      
      if(experimentAttributes$samplingScheme == "entropy"){  
        S[t,] = pickStimulusStimCat(particleSets[[1]], preComputedP, 
                                    stimSet, stimCat[t])$S
      } else if(experimentAttributes$samplingScheme == "random"){
        
        S[t,1] = stimSet$xVals[sample(1:length(stimSet$xVals), 1)]
        S[t,2] = stimSet$yVals[sample(1:length(stimSet$yVals), 1)]
        
        if(stimCat[t] == 1){
           S[t,1] = 0
           S[t,2] = 0
        }
        if(stimCat[t] == 2){
          S[t,1] = 0
        }
        if(stimCat[t] == 3){
          S[t,2] = 0
        }
        if(stimCat[t] == 4){
        
        }
      

      } else {
        stop("Sampling scheme not supported")
      }
      
      # Play stimulus and record the response
      
      R[t,] = genResp(S[t,], genTheta, experimentAttributes$pResp)
      
      #
      # POST-TRIAL COMPUTATIONS
      #
      
      # 1) Reweight particle sets, calculate estimates and resample if effective sample size is too low
      
      for(i in 1:length(particleSets)){
        particleSets[[i]] = reweight(S[t,], R[t,], particleSets[[i]], experimentAttributes$pResp)
        particleSets[[i]] = calculateEstimates(particleSets[[i]], t)
        
        if((1 / sum(particleSets[[i]]$w^2)) < (experimentAttributes$nParticles / 4)){
          particleSets[[i]] = resample(particleSets[[i]], t)
          particleSets[[i]]$wasResampled[t] = 1
        } else{
          particleSets[[i]]$wasResampled[t] = 0
        }
      }
      
      # 2) If the particle sets seem to diverge into different estimates, they are 
      #    all begun from scratch
      
      if(testForDivergence(particleSets, t, prior)){
        laplaceApprox = doLaplaceApprox(S, R, t, experimentAttributes$mdlFile)
        
        for(i in 1:length(particleSets)){
          particleSets[[i]]$particles = mvtnorm::rmvnorm(experimentAttributes$nParticles, 
                                                         mean = laplaceApprox$mu, sigma = laplaceApprox$covMat)
          particleSets[[i]]$w = rep(1/experimentAttributes$nParticles, experimentAttributes$nParticles)
          particleSets[[i]]$wasResampled[t] = 1   
        }
      }
      
      # If the first particle set was resampled AND the P-array is recomputed AND it has been designated
      # in experimentAttributes that the stimulus set should be recomputed. 
      
      if(particleSets[[1]]$wasResampled[t] == 1 && experimentAttributes$recomputeStimRange){
        
        stimSet = computeStimRanges(apply(particleSets[[1]]$particles, 2, mean), 
                                    apply(particleSets[[1]]$particles, 2, sd), typeOfExperiment)  
        print("Please wait a a moment...")
        preComputedP = preComputePArrays(stimSet, particleSets[[1]], experimentAttributes$pResp)
      }
      
    }
    
    d = list(S = S, R = R, genTheta = genTheta, particleSets = particleSets)
    #
    # Save or return data
    #
    if(saveFile){
      block = findNextIndex(dataFolder, typeOfExperiment)
      save(d, file = paste(dataFolder, typeOfExperiment, "_block_", block, ".dat", sep = ""))
    } else {
      return(d)
    }
  }
}

# 
# plot(S[,1])
# plot(S[,2])
# plot(S)
# 
# ## Convergence diagnostics for particle sets
# #
# # 1st, check that particle sets are internally consistent
# # 2nd, check particle sets agains trial-by-trial Laplace approximations
# # TODO: BTW, stan doesn't work AGAIN, when t = 1... that damn thing!
# 
# 
# x11()
# par(mfrow = c(3,3))
# for(i in 1:9){
#   plot(particleSets[[1]]$muTheta[,i], type = "l")
#   points(particleSets[[2]]$muTheta[,i], type = "l", col = "red")
#   points(particleSets[[3]]$muTheta[,i], type = "l", col = "green")
#   
# }
# 
# laplaceApprox = list()
# 
# for(t in 2:experimentAttributes$nTrials){
#   laplaceApprox[[t]] = doLaplaceApprox(S[1:t,], R[1:t,], t, experimentAttributes$mdlFile)
#   
# }
# particleSets[[1]]$muTheta[t,]
# laplaceApprox$mu
# 
# laplaceMus = matrix(NaN, ncol = 9, nrow = experimentAttributes$nTrials)
# laplaceSds = matrix(NaN, ncol = 9, nrow = experimentAttributes$nTrials)
# 
# for(t in 2:experimentAttributes$nTrials){
#   laplaceMus[t,] = laplaceApprox[[t]]$mu
#   laplaceSds[t,] = diag(laplaceApprox[[t]]$covMat)
#   
# }
# 
# x11()
# par(mfrow = c(3,3))
# 
# for(i in 1:9){
#   plot(laplaceMus[,i], type="l")
#   points(particleSets[[1]]$muTheta[,i], type = "l", col = "red")
# }
# 
# 
# x11()
# par(mfrow = c(3,3))
# for(i in 1:9){
#   plot(sqrt(laplaceSds[,i]), type="l")
#   points(particleSets[[1]]$sdTheta[,i], type = "l", col = "red")
# }
