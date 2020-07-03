#### Preamble ####

library(rstan)

setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")

source("posteriorPredictiveFunctions.R")

#

load("analysis_files/JP/dataForStanAFC.rData")
load("analysis_files/JP/dataForStanYN.rData")

for(fname in  dir("analysis_files/JP/", pattern = "fit")){
  load(paste("analysis_files/JP/", fname, sep = ""))
}

#### Yes/No models ####

limits_YN = list(
  lim_x = c(-Inf, 0, 0.72, max(dataForStanYN$S[,1])),
  lim_y = c(-Inf, 0, 0.45, max(dataForStanYN$S[,2]))
)

categories_YN = createCategories(dataForStanYN$S, limits_YN$lim_x, limits_YN$lim_y)
post_pred_YN_obs = createCatMat(dataForStanYN$R, categories_YN)

# Number of data points ber bin:
unlist(lapply(categories_YN, function(x){length(x$inds)}))
# Should be nine categories:
length(unlist(lapply(categories_YN, function(x){length(x$inds)})))
# Should sum to 400:
sum(unlist(lapply(categories_YN, function(x){length(x$inds)})))

#

post_pred_YN_model_1 = splitRepData(drawPostPred_YN_mdl_1(as.matrix(fitYNModel_1), 
                                                          dataForStanYN$S), categories_YN)
post_pred_YN_model_2 = splitRepData(drawPostPred_YN_mdl_2(as.matrix(fitYNModel_2), 
                                                          dataForStanYN$S), categories_YN)
post_pred_YN_model_3 = splitRepData(drawPostPred_YN_mdl_3(as.matrix(fitYNModel_3), 
                                                          dataForStanYN$S), categories_YN)
post_pred_YN_both = splitRepData(drawPostPred_YN_both(as.matrix(fitYN_both), 
                                                      dataForStanYN$S), categories_YN)
post_pred_YN_both_T = splitRepData(drawPostPred_YN_both(as.matrix(fitYN_both_T), 
                                                        dataForStanYN$S), categories_YN)

#

save(post_pred_YN_obs, 
     file = "analysis_files/JP/post_pred_YN_obs.rData")

save(post_pred_YN_model_1, 
     file = "analysis_files/JP/post_pred_YN_model_1.rData")
save(post_pred_YN_model_2, 
     file = "analysis_files/JP/post_pred_YN_model_2.rData")
save(post_pred_YN_model_3, 
     file = "analysis_files/JP/post_pred_YN_model_3.rData")

save(post_pred_YN_both, 
     file = "analysis_files/JP/post_pred_YN_both.rData")

save(post_pred_YN_both_T, 
     file = "analysis_files/JP/post_pred_YN_both_T.rData")

##### AFC Models #### 

limits_AFC = list(
  lim_x = c(-Inf, quantile(dataForStanAFC$S[,1], c(0.35, 0.7)), Inf),
  lim_y = c(-Inf, quantile(dataForStanAFC$S[,2], c(0.35, 0.7)), Inf)
)

categories_AFC = createCategories(dataForStanAFC$S, limits_AFC$lim_x, limits_AFC$lim_y)
post_pred_AFC_obs = createCatMat(dataForStanAFC$R, categories_AFC)

# Number of data points ber bin:
unlist(lapply(categories_AFC, function(x){length(x$inds)}))
# Should be nine categories:
length(unlist(lapply(categories_AFC, function(x){length(x$inds)})))
# Should sum to 400:
sum(unlist(lapply(categories_AFC, function(x){length(x$inds)})))

#

post_pred_AFC_model_1 = splitRepData(drawPostPred_AFC_mdl_1(as.matrix(fitAFCModel_1), 
                                                            dataForStanAFC$S), categories_AFC)
post_pred_AFC_model_2 = splitRepData(drawPostPred_AFC_mdl_2(as.matrix(fitAFCModel_2), 
                                                            dataForStanAFC$S), categories_AFC)
post_pred_AFC_model_3 = splitRepData(drawPostPred_AFC_mdl_3(as.matrix(fitAFCModel_3), 
                                                            dataForStanAFC$S), categories_AFC)
post_pred_AFC_both = splitRepData(drawPostPred_AFC_both(as.matrix(fitAFC_both), 
                                                        dataForStanAFC$S), categories_AFC)
post_pred_AFC_both_T = splitRepData(drawPostPred_AFC_both(as.matrix(fitAFC_both_T), 
                                                          dataForStanAFC$S), categories_AFC)
#

save(post_pred_AFC_obs, 
     file = "analysis_files/JP/post_pred_AFC_obs.rData")

save(post_pred_AFC_model_1, 
     file = "analysis_files/JP/post_pred_AFC_model_1.rData")
save(post_pred_AFC_model_2, 
     file = "analysis_files/JP/post_pred_AFC_model_2.rData")
save(post_pred_AFC_model_3, 
     file = "analysis_files/JP/post_pred_AFC_model_3.rData")

save(post_pred_AFC_both, 
     file = "analysis_files/JP/post_pred_AFC_both.rData")
save(post_pred_AFC_both_T, 
     file = "analysis_files/JP/post_pred_AFC_both_T.rData")

