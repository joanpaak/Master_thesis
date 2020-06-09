# HOW TO RUN SIMULATIONS

So you want to run some simulations? This file gives some tips for accomplishing that.

## Where the simulations are saved in? 

The folder in which data is saved is determined partially from the call to the 
function runSimulations. The third parameter is a folder, the final folder is:

    dataFolder = paste("Data/", folder, "/", sep = "")

# HOW TO RUN SIMULATION:

Open runMultipleYesNo.R or runMultiple2I4AFC.R
- First RStan is loaded, model is compiled and look-up table created
- After this three different simulations are run
  - One with random sampling of stimuli, no recomputing of the stimulus range
  - One with random sampling of stimuli, stimulus range is recomputed
  - One with adptive sampling, stimulus range is recomputed

# EXPERIMENT ATTRIBUTES OBJECT:

nParticles     = how many particles are used in the particle filter; note that three parallel filters are run
nTrials        = number of trials
samplingScheme = can be "random" "entropy". Obviously "entropy" is adaptive
pResp          = Function for calculating response probabilities. Can be pRespYN,or pRespAFC
mdlFile        = Model used for calculating posterior probabilities. Can be mdlYesNoBivarProbit or mdlAFCBivarProbit
recomputeStimRange = Should stimulus ranges be recomputed

# RECOMPUTING STIMULUS RANGES? WHAT'S THAT?

Range for selecting the stimuli is calculated from the prior distribution.  When data is collected, it makes  sense to recalculate the range, since we, hopefully, have more information. However, this is done only every now and then, since this requires recalculating matrices containing precalculated response probabilities.

# STIMULI ARE PICKED FROM A GRID

Sadly, stimuli aren't selected  from a continous scale. They are picked from a grid.  

# AMOUNTS OF SIMULATIONS

There are three categories, each further divided into two subcategories: Yes/No and 2I-4AFC. 

Since there are no "balanced" analyses, it is not of importance to have the same exact amount of stuff in each, but it'd be great if they were even closeish. 

There's an R script for counting the amounts of simulations in each category. The script can be found from the analysis folder, and is called simply countNumberOfSimulations.R

 