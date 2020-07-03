require(rstan)
setwd("C:/Users/Joni/Documents/GitHub/Master_thesis/Analysis/Analysis_of_Human_Data")

mdlYN    = stan_model("../../Stan/mdlYN.stan")
mdlYN_FL = stan_model("../../Stan/mdlYN_FL.stan")
mdlYN_varshift_FL = stan_model("../../Stan/mdlYN_varshift_FL.stan")

save(mdlYN, file = "../../compiled_models/mdlYN.rData")
save(mdlYN_FL, file = "../../compiled_models/mdlYN_FL.rData")
save(mdlYN_varshift_FL, file = "../../compiled_models/mdlYN_varshift_FL.rData")

mdlAFC    = stan_model("../../Stan/mdlAFC.stan")
mdlAFC_FL = stan_model("../../Stan/mdlAFC_FL.stan")
mdlAFC_varshift_FL = stan_model("../../Stan/mdlAFC_varshift_FL.stan")

save(mdlAFC, file = "../../compiled_models/mdlAFC.rData")
save(mdlAFC_FL, file = "../../compiled_models/mdlAFC_FL.rData")
save(mdlAFC_varshift_FL, file = "../../compiled_models/mdlAFC_varshift_FL.rData")

mdlYN_both  = stan_model("../../Stan/mdlYN_both.stan")
mdlAFC_both = stan_model("../../Stan/mdlAFC_both.stan")

save(mdlYN_both, file = "../../compiled_models/mdlYN_both.rData")
save(mdlAFC_both, file = "../../compiled_models/mdlAFC_both.rData")

mdlYN_both_truncated  = stan_model("../../Stan/mdlYN_both_truncated.stan")
mdlAFC_both_truncated = stan_model("../../Stan/mdlAFC_both_truncated.stan")

save(mdlYN_both_truncated, file = "../../compiled_models/mdlYN_both_truncated.rData")
save(mdlAFC_both_truncated, file = "../../compiled_models/mdlAFC_both_truncated.rData")
