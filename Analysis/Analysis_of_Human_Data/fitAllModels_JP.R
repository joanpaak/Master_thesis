
#### SET WORKING DIRECTORY:
#### (should point to the "Analysis of Human Data" -folder):

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")
dataFolder = "C:/Users/Joni/Documents/GitHub/Master_thesis/Simulation_and_experiment/Data/JP/"

##### READ DATA ####

source("fileIOFunctions.R")

dataJP = readDataFromFolder(dataFolder)

datMatYN  = dataJP$datMatYN
datMatAFC = dataJP$datMatAFC

#### LOAD LIBRARIES ####

library(rstan)
options(mc.cores = 2)

# Settings for sampling:

NChains = 4
NIter   = 2000

#### Compile models (comment this part out if you have already compiled them) ####

# Load pre-compiled models:

load(file = "../../compiled_models/mdlYN.rData")
load(file = "../../compiled_models/mdlYN_FL.rData")
load(file = "../../compiled_models/mdlYN_varshift_FL.rData")

load(file = "../../compiled_models/mdlAFC.rData")
load(file = "../../compiled_models/mdlAFC_FL.rData")
load(file = "../../compiled_models/mdlAFC_varshift_FL.rData")

load(file = "../../compiled_models/mdlYN_both.rData")
load(file = "../../compiled_models/mdlAFC_both.rData")

load(file = "../../compiled_models/mdlYN_both_truncated.rData")
load(file = "../../compiled_models/mdlAFC_both_truncated.rData")

#### YES/NO MODELS ####

dataForStanYN = list(S = datMatYN[,1:2], R = datMatYN[,3:4], NTrials = nrow(datMatYN))

fitYNModel_1 = sampling(mdlYN, 
                        data =  dataForStanYN, chains = NChains, iter = NIter)
fitYNModel_2 = sampling(mdlYN_FL, 
                        data =  dataForStanYN, chains = NChains, iter = NIter)
fitYNModel_3 = sampling(mdlYN_varshift_FL, 
                        data =  dataForStanYN, chains = NChains, iter = NIter)

#

fitYN_both = sampling(mdlYN_both, data = dataForStanYN, chains = NChains, iter = NIter,
                       control = list(adapt_delta = 0.925))

fitYN_both_T = sampling(mdlYN_both_truncated, data = dataForStanYN, chains = NChains, iter = NIter,
                         control = list(adapt_delta = 0.80))

#

save(dataForStanYN, file = "analysis_files/JP/dataForStanYN.rData")

save(fitYNModel_1, file = "analysis_files/JP/fitYNModel_1.rData")
save(fitYNModel_2, file = "analysis_files/JP/fitYNModel_2.rData")
save(fitYNModel_3, file = "analysis_files/JP/fitYNModel_3.rData")

save(fitYN_both, file = "analysis_files/JP/fitYN_both.rData")
save(fitYN_both_T, file = "analysis_files/JP/fitYN_both_T.rData")

#### AFC MODELS #####

dataForStanAFC = list(S = datMatAFC[,1:2], R = datMatAFC[,3:4], NTrials = nrow(datMatAFC))

fitAFCModel_1 = sampling(mdlAFC, 
                         data =  dataForStanAFC, chains = NChains, iter = NIter)
fitAFCModel_2 = sampling(mdlAFC_FL, 
                         data =  dataForStanAFC, chains = NChains, iter = NIter)
fitAFCModel_3 = sampling(mdlAFC_varshift_FL, 
                         data =  dataForStanAFC, chains = NChains, iter = NIter)


fitAFC_both = sampling(mdlAFC_both, data = dataForStanAFC, chains = NChains, iter = NIter,
                        control = list(adapt_delta = 0.925))

fitAFC_both_T = sampling(mdlAFC_both_truncated, data = dataForStanAFC, chains = NChains, iter = NIter,
                        control = list(adapt_delta = 0.80))

#

save(dataForStanAFC, file = "analysis_files/JP/dataForStanAFC.rData")

save(fitAFCModel_1, file = "analysis_files/JP/fitAFCModel_1.rData")
save(fitAFCModel_2, file = "analysis_files/JP/fitAFCModel_2.rData")
save(fitAFCModel_3, file = "analysis_files/JP/fitAFCModel_3.rData")

save(fitAFC_both, file = "analysis_files/JP/fitAFC_both.rData")
save(fitAFC_both_T, file = "analysis_files/JP/fitAFC_both_T.rData")

