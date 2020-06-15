#
# The point here is that you can open a couple of R sessions, then
# use this file to conveniently source functions needed for running 
# a YesNo simulations and then run a couple in parallel. 
#

# Set up the simulation:

library(rstan)
#setwd('/home/joni/Desktop/Thesis/Simulation_final/')
setwd('C:/Users/Joni/Desktop/Thesis/Simulation_final/')

# When running for the first time on your system, you should
# compile the stan model and save it to a file. C.f. the 
# commented out portion after this line
load("mdlYesNoBivarProbit.rData")
# 
# mdlYesNoBivarProbit = stan_model("YesNoBivarProbit.stan")
# save(mdlYesNoBivarProbit, file = "mdlYesNoBivarProbit.rData")

source("AuxiliaryFunctions/auxiliaryFunctions.R")
source("YesNoSimulation.R")

LUT = pbivnormLUT()

### RANDOM SAMPLING; DON'T RECOMPUTE STIM RANGE

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "random",
  pResp = pRespYN,
  mdlFile = mdlYesNoBivarProbit,
  recomputeStimRange = F
)

runSimulations(25, experimentAttributes, "random_fix_stim", T)


### RANDOM SAMPLING; RECOMPUTE STIM RANGE

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "random",
  pResp = pRespYN,
  mdlFile = mdlYesNoBivarProbit,
  recomputeStimRange = T
)

runSimulations(25, experimentAttributes, "random", T)


### ADAPTIVE SAMPLING; RECOMPUTE STIM RANGE

experimentAttributes = list(
  nParticles = 2000,
  nTrials = 800,
  samplingScheme = "entropy",
  pResp = pRespYN,
  mdlFile = mdlYesNoBivarProbit,
  recomputeStimRange = T
)

runSimulations(25, experimentAttributes, "adaptive", T)

