#### FUNCTIONS RELATING TO PICKING STIMULI AND CALCULATING INFORMATION GAINS ####

print("Compiling c++ code...")
Rcpp::sourceCpp("AuxiliaryFunctions/cppLoop.cpp")
print("Done.")

informationGainLUT = function(S, particles, w, p){
  # The L-BFGS-B routine will sometimes try values that are slightly
  # over the limits; that is, sometimes stimulus values less than zero
  # are passed, crashing the whole thing.
  
  NParticles = nrow(particles)
  
  # p can be precomputed for a set of stimulus values... 
  # it has to be recomputed when particles are resampled, though
  
  # Term 1:
  #g = p * w
  sum_1 = colSums(p * w)
  oldEntropy = -sum(sum_1 * log(sum_1))
  
  # Term 2:
  newEntropy = cppLoop(p, w, NParticles)
  # for(i in 1:NParticles){
  #   newEntropy = newEntropy + -sum(p[i,] * log(p[i,])) * w[i] 
  # }
  # 
  # Information gain:
  return(-(oldEntropy - newEntropy))
}

pickStimulusStimCat = function(particleSet, preComputedP, stimSet, stimCat){
  
  informationGains = matrix(NaN, nrow = length(stimSet$xVals), ncol = length(stimSet$yVals))
  
    if(stimCat == 4){
      for(i in 2:length(stimSet$xVals)){
        for(j in 2:length(stimSet$yVals)){
          informationGains[i,j] = informationGainLUT(c(stimSet$xVals[i], stimSet$yVals[j]), 
                                                     particleSet$particles, particleSet$w, preComputedP[i,j,,])
        }
      }
      minInd = arrayInd(which.min(informationGains), dim(informationGains))
      stim = c(stimSet$xVals[minInd[1]], stimSet$yVals[minInd[2]])
    }

    if(stimCat == 3){
      for(i in 2:length(stimSet$xVals)){
        for(j in 2:length(stimSet$yVals)){
          informationGains[i,j] = informationGainLUT(c(0, stimSet$yVals[j]), 
                                                     particleSet$particles, particleSet$w, preComputedP[1,j,,])
        }
      }
      minInd = arrayInd(which.min(informationGains), dim(informationGains))
      stim = c(0, stimSet$yVals[minInd[2]])
    }

    if(stimCat == 2){
      for(i in 2:length(stimSet$xVals)){
        for(j in 2:length(stimSet$yVals)){
          informationGains[i,j] = informationGainLUT(c(stimSet$xVals[i], 0), 
                                                     particleSet$particles, particleSet$w, preComputedP[i,1,,])
        }
      }
      minInd = arrayInd(which.min(informationGains), dim(informationGains))
      stim = c(stimSet$xVals[minInd[1]], 0)
    }


    if(stimCat == 1){
      for(i in 2:length(stimSet$xVals)){
        for(j in 2:length(stimSet$yVals)){
          informationGains[i,j] = informationGainLUT(c(0, 0), 
                                                     particleSet$particles, particleSet$w, preComputedP[1,1,,])
        }
      }
      minInd = arrayInd(which.min(informationGains), dim(informationGains))
      stim = c(0, 0)
    }

  
  bestIg = informationGains[minInd[1], minInd[2]]
  
  return(list(S = stim, ig = bestIg))
}

computeStimRanges = function(muTheta, sdTheta, typeOfExperiment){
  #
  # Idea here is to calculate stimulus range proposals in two scenarios:
  # 1) shallow slope, high threshold
  # 2) steep slope, low threshold
  # Generally, the upper limit is gotten from the first one and
  # the lower limit for the second.
  
  
  #
  # In the YesNo experiment betas are in indices 5 and 6, whereas 
  # in the 2AFC experimet they lurk in the indices 3 and 4.
  #
  
  if(grepl("YesNo", typeOfExperiment)){
    betaInd = c(5, 6)
  } else if(grepl("AFC", typeOfExperiment)){
    betaInd = c(3, 4)
  } else {
    stop("Error in function 'computeStimRanges': typeOfExperiment variable is not recognized")
  }
  targetDPrime = c(0.1, 2.0)
  
  proposals_x = matrix(NaN, 2, 2)
  proposals_y = matrix(NaN, 2, 2)
  
  # 
  proposals_x[1,] = targetDPrime ^ (1 / exp(muTheta[betaInd[1]] - 1.96 * sdTheta[betaInd[1]])) * 
    exp(muTheta[1] + 1.96 * sdTheta[1])
  #
  proposals_x[2,] = targetDPrime ^ (1 / exp(muTheta[betaInd[1]] + 1.96 * sdTheta[betaInd[1]])) * 
    exp(muTheta[1] - 1.96 * sdTheta[1])
  #
  proposals_y[1,] = targetDPrime ^ (1 / exp(muTheta[betaInd[2]] - 1.96 * sdTheta[betaInd[2]])) * 
    exp(muTheta[2] + 1.96 * sdTheta[2])
  #
  proposals_y[2,] = targetDPrime ^ (1 / exp(muTheta[betaInd[2]] + 1.96 * sdTheta[betaInd[2]])) * 
    exp(muTheta[2] - 1.96 * sdTheta[2])
  
  # Maximum values: 10
  proposals_x[proposals_x > 10] = 10
  proposals_y[proposals_y > 10] = 10
  
  x_range = range(proposals_x)
  y_range = range(proposals_y)
  
  x_range
  y_range
  
  # return(list(xVals = c(0, exp(seq(log(x_range[1]), log(x_range[2]), length.out = 14))),
              # yVals = c(0, exp(seq(log(y_range[1]), log(y_range[2]), length.out = 14)))))
              
  return(list(xVals = c(0, seq(x_range[1], x_range[2], length.out = 14)),
              yVals = c(0, seq(y_range[1], y_range[2], length.out = 14))))
}
