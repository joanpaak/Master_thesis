#
# The point here is that you can open a couple of R sessions, then
# use this file to conveniently source functions needed for running 
# a 2I4AFC simulations and then run a couple in parallel. 
#

# Set up the simulation:

library(rstan)
setwd('C:/Users/Joni/Documents/GitHub/Master_thesis/Simulation_and_experiment')

# When running for the first time on your system, you should
# compile the stan model and save it to a file. C.f. the 
# commented out portion after this line
load("../compiled_models/mdlAFC.rData")
# 
# mdlAFCBivarProbit = stan_model("../Stan/mdlAFC.stan")
# save(mdlAFCBivarProbit, file = "../compiled_models/mdlAFC.rData")

source("AuxiliaryFunctions/auxiliaryFunctions.R")
source("2I4AFCSimulation.R")

LUT = pbivnormLUT()


### Random, no recomputing of stim range

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "random",
  pResp = pRespAFC,
  mdlFile = mdlAFC,
  recomputeStimRange = F
)

runSimulations(50, experimentAttributes, "random_fix_stim",  T)


### Random, nrecompute  stim range

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "random",
  pResp = pRespAFC,
  mdlFile = mdlAFC,
  recomputeStimRange = T
)

runSimulations(50, experimentAttributes, "random",  T)


### adaptive

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "entropy",
  pResp = pRespAFC,
  mdlFile = mdlAFC,
  recomputeStimRange = T
)

runSimulations(1, experimentAttributes, "adaptive",  T)
