#
# Sort of clunky functions for plotting posterior predictive distributions. 
# You have to change a couple of things by hand: 
#   - The part where data set is loaded: load("analysis_files/postPredOK.rData")
#   - All of the png-functions (there should be four)

#### Prequisites ####

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")

for(fname in dir("analysis_files/OK/", pattern = "post_pred")){
    load(paste("analysis_files/OK/", fname, sep = ""))
}

source("plotPosteriorPredictive_sharedFunctions.R")

#### Plot basic models ####

#### Yes/No ####

# All mtext texts are added at this point,not inside the main plotting function

png(file = "../../PDF/figures/OK_YN_post_pred.png", 
    width = 10, 
    height = 7, 
    units = "in", 
    res = 700)
par(mfrow = c(2,3))

plotRepData(post_pred_YN_model_1, post_pred_YN_obs, "x")
mtext("Model 1", 3, line = 1)
mtext("P(Yes) Pitch", 2, line = 2.5)
plotRepData(post_pred_YN_model_2, post_pred_YN_obs, "x")
mtext("Model 2", 3, line = 1)
mtext("Timbre category", 1, line = 3)
plotRepData(post_pred_YN_model_3, post_pred_YN_obs, "x")
mtext("Model 3", 3, line = 1)

plotRepData(post_pred_YN_model_1, post_pred_YN_obs, "y")
mtext("P(Yes) Timbre", 2, line = 2.5)
plotRepData(post_pred_YN_model_2, post_pred_YN_obs, "y")
mtext("Pitch category", 1, line = 3)
plotRepData(post_pred_YN_model_3, post_pred_YN_obs, "y")

dev.off()

#### AFC ####

# x11()

png(file = "../../PDF/figures/OK_AFC_post_pred.png", 
    width = 10,
    height = 7,
    units = "in",
    res = 700)

par(mfrow = c(2,3))
plotRepData(post_pred_AFC_model_1, post_pred_AFC_obs, "x")
mtext("Model 1", 3, line = 1)
mtext("P(Correct) Pitch", 2, line = 2.5)
plotRepData(post_pred_AFC_model_2, post_pred_AFC_obs, "x")
mtext("Model 2", 3, line = 1)
mtext("Timbre category", 1, line = 3)
plotRepData(post_pred_AFC_model_3, post_pred_AFC_obs, "x")
mtext("Model 3", 3, line = 1)

plotRepData(post_pred_AFC_model_1, post_pred_AFC_obs, "y")
mtext("P(Correct) Timbre", 2, line = 2.5)
plotRepData(post_pred_AFC_model_2, post_pred_AFC_obs, "y")
mtext("Pitch category", 1, line = 3)
plotRepData(post_pred_AFC_model_3, post_pred_AFC_obs, "y")

dev.off()

##### Plot models with both interaction coefficients ####

png(file = "../../PDF/figures/OK_post_pred_both.png", 
    width = 10,
    height = 10,
    units = "in",
    res = 700)
# x11(width = 10, height = 10)
par(mfrow = c(2,2))
plotRepData(post_pred_YN_both, post_pred_YN_obs, "x")
mtext("Yes/No, Both interactions", side = 3, line = 1, adj = 0)
mtext("P(Correct) Pitch", 2, line = 2.5)
plotRepData(post_pred_YN_both, post_pred_YN_obs, "y")
mtext("P(Correct) Timbre", 2, line = 2.5)

plotRepData(post_pred_AFC_both, post_pred_AFC_obs, "x")
mtext("2I-4AFC, Both interactions", side = 3, line = 1, adj = 0)
mtext("P(Correct) Pitch", 2, line = 2.5)
plotRepData(post_pred_AFC_both, post_pred_AFC_obs, "y")
mtext("P(Correct) Timbre", 2, line = 2.5)

dev.off()

