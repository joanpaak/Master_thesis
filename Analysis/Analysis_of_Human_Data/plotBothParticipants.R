#### Load libraries and data ####

library(rstan)
library(ggplot2)
library(gridExtra)

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")

source("plotPosteriorsFunctions.R")

# Load all stanfit objevts:

for(fname in dir("analysis_files/JP/", pattern = "fit")){
  load(paste("analysis_files/JP/", fname, sep = ""))
}

#### JP: YN / BASIC MODELS ####

p1 = createViolinPlots(as.matrix(fitYNModel_1), 
                       mainTitle = "JP/YN/Model 1", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_simple)
p2 = createViolinPlots(as.matrix(fitYNModel_2), 
                       mainTitle = "JP/YN/Model 2", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_YN_kmu)
p3 = createViolinPlots(as.matrix(fitYNModel_3), 
                       mainTitle = "JP/YN/Model 3", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_YN_ksigma)

# x11()
png("../../PDF/figures/JP_YN_Basic_models.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
grid.arrange(p1, p2, p3, nrow = 3)
dev.off()

#### JP: AFC / BASIC MODELS ####

p1 = createViolinPlots(as.matrix(fitAFCModel_1), 
                       mainTitle = "JP/AFC/Model 1", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_simple_AFC)
p2 = createViolinPlots(as.matrix(fitAFCModel_2), 
                       mainTitle = "JP/AFC/Model 2", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_AFC_kmu)
p3 = createViolinPlots(as.matrix(fitAFCModel_3), 
                       mainTitle = "JP/AFC/Model 3", 
                       transformRho = TRUE,
                       tickmarks = tickmarks_AFC_ksigma)

# x11()
png("../../PDF/figures/JP_AFC_Basic_models.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
grid.arrange(p1, p2, p3, nrow = 3)
dev.off()

#### JP: BOTH INTERACTIONS ####

#### JP: COMPARE YN AND AFC ####

p = plotBoth(prepDataPlotBoth(fitAFC_both, fitYN_both),
             mainTitle = "JP/Both")

png("../../PDF/figures/JP_YN_AFC_Both.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
p
dev.off()

#### JP: TRUNCATED ####


p = plotBoth(prepDataPlotBoth(fitAFC_both_T, fitYN_both_T),
             mainTitle = "JP/Both (Truncated)")

png("../../PDF/figures/JP_YN_AFC_Both_T.png", 
    width = 7, 
    height = 10, 
    units = "in", 
    res = 700)
p
dev.off()

