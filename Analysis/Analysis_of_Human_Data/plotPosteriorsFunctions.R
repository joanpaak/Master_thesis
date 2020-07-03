#
#
#

#### Functions ####

transformParameters = function(fitAsMatrix, transformRho){
  log_link = which(grepl("sigma|beta", colnames(fitAsMatrix)))
  
  fitAsMatrix[,log_link] = exp(fitAsMatrix[,log_link])
  
  if(transformRho){
    atanh_link = which(grepl("rho", colnames(fitAsMatrix)))
    fitAsMatrix[,atanh_link] = tanh(fitAsMatrix[,atanh_link])
  }
  
  return(fitAsMatrix)
}

meltToLongForm = function(fitAsMatrix){
  
  dims = ncol(fitAsMatrix) - 1
  
  x = c()
  y = c()
  
  for(i in 1:dims){
    y = append(y, fitAsMatrix[,i])
    x = append(x, rep(colnames(fitAsMatrix)[i], dim(fitAsMatrix)[1]))
  }
  
  fitInLongForm = data.frame("Parameter" = as.factor(x), "Value" = as.numeric(y))
  return(fitInLongForm)
}

createViolinPlots = function(fitAsMatrix, 
                             mainTitle = "", 
                             flipCoordinate = FALSE,
                             transformRho = FALSE,
                             tickmarks = c()){
  
  # fitAsMatric : as.matrix(stanFitObject)
  # mainTitle   : main title of the plot
  # flipCoordinate : should the plot be flipped on its side
  # transforRho : should rho be inverse tanh transformed
  # tickMarks : tickmarks to add to the plot
  
  # fitAsMatrix = as.matrix(stanFit)
  
  
  # Apply transformations
  fitAsMatrix = transformParameters(fitAsMatrix, transformRho)
  
  #
  
  fitInLongForm = meltToLongForm(fitAsMatrix)
  
  p = ggplot(fitInLongForm, aes(x = Parameter, y = Value)) + 
    geom_violin(scale = "width") + ggtitle(mainTitle) +
    labs(x = "", y = "") + 
    scale_x_discrete(limits=unique(fitInLongForm$Parameter),
                     labels = tickmarks) + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red")
  
  if(flipCoordinate){
    p = p + coord_flip()
  }
  
  # + scale_x_discrete(limits=unique(x)) is for avoiding
  # ordering the parameters alphabeticaly
  
  return(p)
  
}

prepDataPlotBoth = function(fitAFC, fitYN){
  df_afc = meltToLongForm(transformParameters(as.matrix(fitAFC),
                                              transformRho = FALSE))
  df_yn  = meltToLongForm(transformParameters(as.matrix(fitYN), 
                                              transformRho = FALSE))
  
  df_both = data.frame("Parameter" = factor(c(as.character(df_afc$Parameter), as.character(df_yn$Parameter))), 
                       "Value" = as.numeric(c(df_afc$Value, df_yn$Value)),
                       "Condition" = as.factor(c(rep("AFC", length(df_afc$Parameter)), 
                                                 rep("YN", length(df_yn$Parameter))))) 
  
  return(df_both)
}

plotBoth = function(df_both, mainTitle){
  p = ggplot(df_both, aes(x = Parameter, y = Value, fill = Condition)) + 
    geom_violin(scale = "width", position=position_dodge(0.5)) + coord_flip()  +
    labs(x = "", y = "") + 
    scale_x_discrete(limits=unique(df_both$Parameter), labels = tickmarks) +
    ggtitle(mainTitle) + 
    scale_fill_manual(values=c(rgb(0, 0, 0, 0.7), rgb(0.8, 0.3, 0.2, 0.7))) + 
    geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    theme(axis.text.y = element_text(size = 12.5)) 
  
  return(p)
}

#### Define tickmarks ####
#
# Lots of different tickmark sets for different models. 
# They are all defined here. 

# "Both" type models:

tickmarks = c(expression(sigma[pitch]),
              expression(sigma[timbre]),
              expression(beta[pitch]),
              expression(beta[timbre]),
              expression(kappa[pitch]^mu),
              expression(kappa[timbre]^mu),
              expression(kappa[pitch]^sigma),
              expression(kappa[timbre]^sigma),
              expression(rho),
              expression(lambda),
              expression("crit'"[pitch]),
              expression("crit'"[timbre]))

# Single models:

tickmarks_simple = c(expression(sigma[pitch]),
                     expression(sigma[timbre]),
                     expression(crit[pitch]),
                     expression(crit[timbre]),
                     expression(beta[pitch]),
                     expression(beta[timbre]),
                     expression(kappa[pitch]^mu),
                     expression(kappa[timbre]^mu),
                     expression(rho))


tickmarks_simple_AFC = c(expression(sigma[pitch]),
                         expression(sigma[timbre]),
                         expression(beta[pitch]),
                         expression(beta[timbre]),
                         expression(kappa[pitch]^mu),
                         expression(kappa[timbre]^mu),
                         expression(rho))

#

tickmarks_YN_kmu = c(expression(sigma[pitch]),
                     expression(sigma[timbre]),
                     expression(crit[pitch]),
                     expression(crit[timbre]),
                     expression(beta[pitch]),
                     expression(beta[timbre]),
                     expression(kappa[pitch]^mu),
                     expression(kappa[timbre]^mu),
                     expression(rho),
                     expression(lambda))

tickmarks_AFC_kmu = c(expression(sigma[pitch]),
                      expression(sigma[timbre]),
                      expression(beta[pitch]),
                      expression(beta[timbre]),
                      expression(kappa[pitch]^mu),
                      expression(kappa[timbre]^mu),
                      expression(rho),
                      expression(lambda))

#

tickmarks_YN_ksigma = c(expression(sigma[pitch]),
                        expression(sigma[timbre]),
                        expression("crit'"[pitch]),
                        expression("crit'"[timbre]),
                        expression(beta[pitch]),
                        expression(beta[timbre]),
                        expression(kappa[pitch]^sigma),
                        expression(kappa[timbre]^sigma),
                        expression(rho),
                        expression(lambda))

tickmarks_AFC_ksigma = c(expression(sigma[pitch]),
                         expression(sigma[timbre]),
                         expression(beta[pitch]),
                         expression(beta[timbre]),
                         expression(kappa[pitch]^sigma),
                         expression(kappa[timbre]^sigma),
                         expression(rho),
                         expression(lambda))