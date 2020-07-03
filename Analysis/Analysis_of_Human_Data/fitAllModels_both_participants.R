
source("fitAllModels_JP.R")
source("fitAllModels_OK.R")

save(list = ls(), file = "wp_2.rData")

fitJPYNBoth
fitJPAFCBoth

shinystan::launch_shinystan(fitOKYNBoth)
shinystan::launch_shinystan(fitOKAFCBoth)
