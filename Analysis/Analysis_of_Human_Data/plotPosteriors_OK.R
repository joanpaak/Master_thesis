#### Load libraries and data ####

library(rstan)
library(ggplot2)
library(gridExtra)

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")

source("plotPosteriorsFunctions.R")

# Load all stanfit objevts:

for(fname in dir("analysis_files/OK/", pattern = "fit")){
  load(paste("analysis_files/OK/", fname, sep = ""))
}


#### OK: YN / BASIC MODELS ####

p1 = createViolinPlots(as.matrix(fitYNModel_1), 
                       "OK/YN/Model 1", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_simple)
p2 = createViolinPlots(as.matrix(fitYNModel_2), 
                       "OK/YN/Model 2", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_YN_kmu)
p3 = createViolinPlots(as.matrix(fitYNModel_3), 
                       "OK/YN/Model 3", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_YN_ksigma)

png("../../PDF/figures/OK_YN_Basic_models.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
grid.arrange(p1, p2, p3, nrow = 3)
dev.off()

#### OK: AFC / BASIC MODELS ####

p1 = createViolinPlots(as.matrix(fitAFCModel_1), 
                       "OK/AFC/Model 1", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_simple_AFC)
p2 = createViolinPlots(as.matrix(fitAFCModel_2), 
                       "OK/AFC/Model 2", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_AFC_kmu)
p3 = createViolinPlots(as.matrix(fitAFCModel_3), 
                       "OK/AFC/Model 3",
                       transformRho = TRUE,
                       tickmarks = tickmarks_AFC_ksigma)

png("../../PDF/figures/OK_AFC_Basic_models.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
grid.arrange(p1, p2, p3, nrow = 3)
dev.off()


#### OK: BOTH INTERACTIONS #### 

#### OK: COMPARE YN AND AFC#####

p = plotBoth(prepDataPlotBoth(fitAFC_both, fitYN_both),
             mainTitle = "OK/Both")

png("../../PDF/figures/OK_YN_AFC_Both.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
p
dev.off()
