# How to run simulations

So you want to run some simulations? This file gives some tips for accomplishing that.

## Where the simulations are saved in? 

The folder in which data is saved is determined partially from the call to the 
function runSimulations. The third parameter is a folder, the final folder is:

    dataFolder = paste("Data/", folder, "/", sep = "")
    
As a default choice the folders are

    random_fix_stim
    random
    adaptive

The folder Simulation_data houses pre-processed data.

# Running a simulation:

Open runMultipleYesNo.R or runMultiple2I4AFC.R
- First RStan is loaded, model is compiled and look-up table created
- After this three different simulations are run
  - One with random sampling of stimuli, no recomputing of the stimulus range
  - One with random sampling of stimuli, stimulus range is recomputed
  - One with adaptive sampling, stimulus range is recomputed

# Experiment attributes object:

nParticles     = how many particles are used in the particle filter; note that three parallel filters are run
nTrials        = number of trials
samplingScheme = can be "random" "entropy". Obviously "entropy" is adaptive
pResp          = Function for calculating response probabilities. Can be pRespYN,or pRespAFC
mdlFile        = Model used for calculating posterior probabilities. Can be mdlYesNoBivarProbit or mdlAFCBivarProbit
recomputeStimRange = Should stimulus ranges be recomputed

# Recomputing stimulus ranges? What's that?

Range for selecting the stimuli is calculated from the prior distribution.  When data is collected, it makes  sense to recalculate the range, since we, hopefully, have more information. However, this is done only every now and then, since this requires recalculating matrices containing precalculated response probabilities.

# Stimuli are picked from a grid

Sadly, stimuli aren't selected  from a continous scale. They are picked from a grid.  
