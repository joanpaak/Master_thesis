#
# usually you want to do something like...
# playStimulus(createYesNoStimulus(S, stimProperties))
# ...to play a stimulus.  
#

createSilbertStimulus = function(S, stimProperties){
  # Creates a SINGLE stimulus, no noise masking, no nothing. 
  # For this reason this will be mostly (always?) called from
  # createStimulus, which creates a pair of stimuli (since the
  # task is that of discrimination), puts some noise there etc.
 
  # Begin by creating a 13-component harmonic complex:
  
  components = matrix(NaN, nrow = 13, 
                           ncol = stimProperties$sRate * 
                                  stimProperties$stimLength)
  
  t = seq(0, stimProperties$stimLength, length.out = stimProperties$stimLength * stimProperties$sRate)
  
  for(i in 1:13){
    components[i,] = sin(2 * pi * t * (S[1] * i))
  }
  
  x = colSums(components)
  x = x/max(abs(x))
  
  # Transform signal into frequency-domain and create a vector of center frequencies
  # for the bins in the FFT
  
  xfft = fft(x)
  f = c(seq(0, stimProperties$sRate/2, length.out = length(xfft)/2), 
        seq(stimProperties$sRate/2, 0, length.out = length(xfft)/2))
  
  # Gaussian filter placed at S[2], SD = 150Hz
  
  filtDensity = dnorm(f, S[2], 150)
  filtDensity = filtDensity / max(filtDensity)
  filtDensity = filtDensity * 0.85 + 0.15
  
  filtered_x = xfft * filtDensity

  # Using inverse Fourier transform, we get the signal in
  # time domain:
  stimulus = Re(fft(filtered_x, inverse = T))
  stimulus = stimulus / max(abs(stimulus))  
  
  return(stimulus)
}

createStimulus = function(deltaS, stimProperties){
  #
  # Creates a frequency/timbre difference stimulus and embeds it in some noise
  
  deltaS[2] = deltaS[2] * 100
  
  referenceTone = createSilbertStimulus(stimProperties$referenceStim, stimProperties)
  testTone      = createSilbertStimulus(stimProperties$referenceStim + deltaS, stimProperties)
  
  stimulus = c(referenceTone, rep(0, round(stimProperties$sRate * stimProperties$gapLength)), testTone)
  
  # Create noise mask that's 5.5 dB quieter than the signal
  # 
  # rms_signal = sqrt(mean(stimulus^2))
  # rms_noise  = 10 ^ (-5.5/20) * rms_signal
  # 
  # stimulusPlusNoise = 
  # c(rnorm(round(stimProperties$noiseLength * stimProperties$sRate), 0, rms_noise),
  #   stimulus +s rnorm(length(stimulus), 0, rms_noise),
  #   rnorm(round(stimProperties$noiseLength * stimProperties$sRate), 0, rms_noise))
  # 
  # 
  stimulusPlusNoise = 
    c(runif(round(stimProperties$noiseLength * stimProperties$sRate), -1, 1) * stimProperties$noiseAmplitude,
      stimulus + runif(length(stimulus), -1, 1) * stimProperties$noiseAmplitude,
      runif(round(stimProperties$noiseLength * stimProperties$sRate), -1, 1) * stimProperties$noiseAmplitude)
  
  stimulusPlusNoise = stimulusPlusNoise / max(abs(stimulusPlusNoise))
  
  return(stimulusPlusNoise)
}

createYesNoStimulus = function(deltaS, stimProperties){
  return(list(samples = createStimulus(deltaS, stimProperties),
              sRate = stimProperties$sRate, 
              bitDepth = stimProperties$bitDepth))
}

createAFCStimulus = function(deltaS, stimProperties, corrInt){
  betweenIntervalSilence = rep(0, stimProperties$sRate * stimProperties$noiseLength)  
  
  if(corrInt[1] == 1 & corrInt[2] == 1){
    interval_1 = createStimulus(deltaS, stimProperties)
    interval_2 = createStimulus(c(0, 0), stimProperties)  
  }
  if(corrInt[1] == 2 & corrInt[2] == 1){
    interval_1 = createStimulus(c(0.0, deltaS[2]), stimProperties)
    interval_2 = createStimulus(c(deltaS[1], 0.0), stimProperties)  
  }
  if(corrInt[1] == 1 & corrInt[2] == 2){
    interval_1 = createStimulus(c(deltaS[1], 0.0), stimProperties)
    interval_2 = createStimulus(c(0.0, deltaS[2]), stimProperties)  
  }
  if(corrInt[1] == 2 & corrInt[2] == 2){
    interval_1 = createStimulus(c(0, 0), stimProperties)
    interval_2 = createStimulus(deltaS, stimProperties)  
  }
  
  return(list(samples = c(interval_1, betweenIntervalSilence,  interval_2),
              sRate = stimProperties$sRate, 
              bitDepth = stimProperties$bitDepth))
}

applyEnvelope = function(signal, stimProperties){
  

}

playStimulus = function(stimObject){
  play(stimObject$samples, stimObject$sRate)
}

############## Response collectors


getResponseYesNo = function(){
  acceptableResponses = c("00", "10", "01", "11")
  acceptableResponseGiven = F
  
  while(!acceptableResponseGiven){
    print("Please type your response now (Did pitch change, did brightness change):")
    response = readline()
    if(response %in% acceptableResponses){
      acceptableResponseGiven = T
    } else if (response == "q"){
      stop("Stopping the experiment...")
    } else {
      print("Please pick one of the following responses: 00, 10, 01 or 11.")
    }
  }
  # The little math there is to code responses to -1 for no and 1 for yes
  return(as.numeric(strsplit(response, "")[[1]]) * 2 - 1)
}

getResponseAFC = function(corrInt){
  # S = corrInt
  acceptableResponses = c("11", "12", "21", "22")
  acceptableResponseGiven = F
  
  while(!acceptableResponseGiven){
    print("Please type your response now (In which intervals pitch and brightness changed):")
    response = readline()
    if(response %in% acceptableResponses){
      acceptableResponseGiven = T
    } else if(response == "q"){
      stop("Stopping the experiment...")
    } else{
      print("Please pick one of the following responses: 11, 21, 12 or 22.")
    }
  }
  
  response = strsplit(response, "")
  codedResponse = c()
  
  codedResponse[1] = checkAns(corrInt[1], as.numeric(response[[1]][1]))
  codedResponse[2] = checkAns(corrInt[2], as.numeric(response[[1]][2]))
  
  return(codedResponse)
}

checkAns = function(S, R){
  if((R - S) == 0){
    return(1)
  } else{
    return(-1)
  }
}