#### SET WORKING DIRECTORY:
#### (should point to the "Analysis of Human Data" -folder):

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")
dataFolder = "C:/Users/Joni/Documents/GitHub/Master_thesis/Simulation_and_experiment/Data/OK/"

##### READ DATA ####

source("fileIOFunctions.R")

dataOK = readDataFromFolder(dataFolder)

datMatYN  = dataOK$datMatYN
datMatAFC = dataOK$datMatAFC

#### LOAD LIBRARIES ####

library(rstan)
options(mc.cores = 2)

# Settings for sampling:
NChains = 4
NIter   = 2000

#### Compile models (comment this part out if you have already compiled them):

# source("compileAndSaveModels.R")

# Load pre-compiled models:

load(file = "../../compiled_models/mdlYN.rData")
load(file = "../../compiled_models/mdlYN_FL.rData")
load(file = "../../compiled_models/mdlYN_varshift_FL.rData")

load(file = "../../compiled_models/mdlAFC.rData")
load(file = "../../compiled_models/mdlAFC_FL.rData")
load(file = "../../compiled_models/mdlAFC_varshift_FL.rData")

load(file = "../../compiled_models/mdlYN_both.rData")
load(file = "../../compiled_models/mdlAFC_both.rData")

load(file = "../../compiled_models/mdlAFC_both_truncated.rData")

#### YES/NO MODELS ####

dataForStanYN = list(S = datMatYN[,1:2], R = datMatYN[,3:4], NTrials = nrow(datMatYN))

fitOKYesNo = list()

fitOKYesNo[[1]] = sampling(mdlYN, 
                                   data =  dataForStanYN, chains = NChains, iter = NIter)
fitOKYesNo[[2]] = sampling(mdlYN_FL, 
                                   data =  dataForStanYN, chains = NChains, iter = NIter)
fitOKYesNo[[3]] = sampling(mdlYN_varshift_FL, 
                                   data =  dataForStanYN, chains = NChains, iter = NIter)

fitOKYNBoth = sampling(mdlYN_both, data = dataForStanYN, chains = NChains, iter = NIter,
                       control = list(adapt_delta = 0.925))


#### AFC MODELS #####

dataForStanAFC = list(S = datMatAFC[,1:2], R = datMatAFC[,3:4], NTrials = nrow(datMatAFC))

fitOKAFC = list()

fitOKAFC[[1]] = sampling(mdlAFC, 
                                 data =  dataForStanAFC, chains = NChains, iter = NIter)
fitOKAFC[[2]] = sampling(mdlAFC_FL, 
                                 data =  dataForStanAFC, chains = NChains, iter = NIter)
fitOKAFC[[3]] = sampling(mdlAFC_varshift_FL, 
                                 data =  dataForStanAFC, chains = NChains, iter = NIter)
#

fitOKAFCBoth = sampling(mdlAFC_both, data = dataForStanAFC, chains = NChains, iter = NIter,
                        control = list(adapt_delta = 0.925))



###
  
dataToSave = list(dataForStanYN = dataForStanYN,
                  dataForStanAFC = dataForStanAFC,
                  fitYesNo = fitOKYesNo,
                  fitAFC = fitOKAFC,
                  fitYN_both = fitOKYNBoth,
                  fitAFC_both = fitOKAFCBoth)

save(dataToSave,
     file = "analysis_files/modelFits_OK.rData")
