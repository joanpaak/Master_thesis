# Several pdf-figures are created in this file:
#
# simulation_YN_sensory_sq_error.pdf
# simulation_YN_interaction_sq_error.pdf
# simulation_YN_sensory_SD.pdf
# simulation_YN_interaction_SD.pdf
#
# simulation_AFC_sensory_sq_error.pdf
# simulation_AFC_interaction_sq_error.pdf
# simulation_AFC_sensory_SD.pdf
# simulation_AFC_interaction_SD.pdf
# 
# The filename after "simulation" consists of these modifiers:
# YN/AFC : Yes/No or AFC experimental paradigm
# sensory/interaction : are sensory or interaction parameters plotted
# sq_error/SD : do we plot the distribution of squared errors (in relation
#   to the generating parameters) or marginal standard deviations
#

#
# Set folders: 1) where to find "dataObjects_YN" and "dataObjects_AFC"
#              2) where to save figures

dataFolder   = "C:/Users/Joni/Documents/GitHub/Master_thesis/Simulation_and_experiment/Data/Simulation_data/"
figureFolder = "C:/Users/Joni/Documents/GitHub/Master_thesis/PDF/figures/"

load(paste(dataFolder, "dataObjects_YN.rdata", sep = ""))
load(paste(dataFolder, "dataObjects_AFC.rdata", sep = ""))

# From:
# https://stackoverflow.com/questions/57153428/r-plot-color-combinations-that-are-colorblind-accessible

colPalette_transparency = 
  c(rgb(213/255, 94/255, 0, 0.5),
    rgb(0, 0, 0, 0.5))

colPalette = 
  c(rgb(213/255, 94/255, 0),
    rgb(0, 0, 0))

####

plotSds = function(dimsToPlot, 
                   dataObjects, 
                   mainTitle = ""){
  
  # Prepare data:
  
  medians = matrix(nrow = length(dataObjects), ncol = 800)
  lowq    = matrix(nrow = length(dataObjects), ncol = 800)
  highq   = matrix(nrow = length(dataObjects), ncol = 800)
  
 
  for(i in 1:length(dataObjects)){
    sdtheta = rbind(dataObjects[[i]]$sdTheta[[dimsToPlot[1]]],
                    dataObjects[[i]]$sdTheta[[dimsToPlot[2]]])
    medians[i,] = apply(sdtheta, 2, median)
    lowq[i,]    = apply(sdtheta, 2, function(x){ quantile(x, 0.25)})
    highq[i,]   = apply(sdtheta, 2, function(x){ quantile(x, 0.75)})
  }
   
  # Plot the plot:
  
  plot(NULL, xlim = c(1, 800), ylim = range(c(highq, lowq)), 
       axes = F, ylab = expression(paste("Marg.", sigma)), xlab = "Trial", log = "x", 
       main = mainTitle)
  
  abline(h = pretty(range(c(highq, lowq))), lty = 2, col = c(1, 1, 1, 0.25))
  
  polygon(c(1:800, 800:1), c(lowq[1,], rev(highq[1,])), col = colPalette_transparency[1], border = NA)
  polygon(c(1:800, 800:1), c(lowq[2,], rev(highq[2,])), col = colPalette_transparency[2], border = NA)
  
  points(medians[1,], type = "l", col = colPalette[1], lwd = 2)
  points(medians[2,], type = "l", col = colPalette[2], lwd = 2)
  
  axis(side = 1); axis(side = 2)
  
  
}

plotSqError = function(dimsToPlot, 
                       dataObjects, 
                       mainTitle = ""){
  
  # Prepare data:
  
  medians = matrix(nrow = length(dataObjects), ncol = 800)
  lowq    = matrix(nrow = length(dataObjects), ncol = 800)
  highq   = matrix(nrow = length(dataObjects), ncol = 800)
  

  for(i in 1:length(dataObjects)){
    mutheta = rbind((dataObjects[[i]]$muTheta[[dimsToPlot[1]]] - 
                       dataObjects[[i]]$genTheta[,dimsToPlot[1]])^2,
                    (dataObjects[[i]]$muTheta[[dimsToPlot[2]]] - 
                       dataObjects[[i]]$genTheta[,dimsToPlot[2]])^2)
    medians[i,] = apply(mutheta, 2, median)
    lowq[i,]    = apply(mutheta, 2, function(x){ quantile(x, 0.25)})
    highq[i,]   = apply(mutheta, 2, function(x){ quantile(x, 0.75)})
  }

  # Plot the plot:
  
  plot(NULL, xlim = c(1, 800), ylim = range(c(highq, lowq)), 
       axes = F, ylab = expression("Error"^"2"), xlab = "Trial", log = "x", 
       main = mainTitle)
  
  abline(h = pretty(range(c(highq, lowq))), lty = 2, col = c(1, 1, 1, 0.25))
  
  polygon(c(1:800, 800:1), c(lowq[1,], rev(highq[1,])), col = colPalette_transparency[1], border = NA)
  polygon(c(1:800, 800:1), c(lowq[2,], rev(highq[2,])), col = colPalette_transparency[2], border = NA)
  
  points(medians[1,], type = "l", col = colPalette[1], lwd = 2)
  points(medians[2,], type = "l", col = colPalette[2], lwd = 2)
  
  axis(side = 1); axis(side = 2)
  
}

##### COMPARE ADAPTIVE ALGORITHM WITH RANDOM SAMPLING: ####
#########
#
# YES/NO
#
#######

dataSetsToPlot = list(dataObjects_YN["adaptive"]$adaptive, dataObjects_YN["random"]$random)

pdf(file = paste(figureFolder, "simulation_YN_sensory_sq_error.pdf", sep = ""), 
    width = 7,
    height = 3.5)

  par(mfrow = c(1, 3))
  plotSqError(c(1,2), dataSetsToPlot, 
              mainTitle = expression(sigma))
  plotSqError(c(3,4), dataSetsToPlot, 
              mainTitle = "crit")
  plotSqError(c(5,6), dataSetsToPlot, 
              mainTitle = expression(beta))
  
dev.off()

#

pdf(file = paste(figureFolder, "simulation_YN_interaction_sq_error.pdf", sep = ""), 
    width = 7,
    height = 3.5)

  par(mfrow = c(1,2))
  plotSqError(c(7,8), dataSetsToPlot, 
              mainTitle = expression(paste(kappa, mu)))
  plotSqError(c(9), dataSetsToPlot,  
              mainTitle = expression(rho))

dev.off()

#

pdf(file = paste(figureFolder, "simulation_YN_sensory_SD.pdf", sep = ""), 
    width = 7,
    height = 3.5)

  par(mfrow = c(1, 3))
  plotSds(c(1,2), dataSetsToPlot, 
              mainTitle = expression(sigma))
  plotSds(c(3,4), dataSetsToPlot, 
              mainTitle = "crit")
  plotSds(c(5,6), dataSetsToPlot, 
              mainTitle = expression(beta))

dev.off()

#

pdf(file = paste(figureFolder, "simulation_YN_interaction_SD.pdf", sep = ""), 
    width = 7,
    height = 3.5)

  par(mfrow = c(1,2))
  plotSds(c(7,8), dataSetsToPlot, 
              mainTitle = expression(paste(kappa, mu)))
  plotSds(c(9), dataSetsToPlot,  
              mainTitle = expression(rho))

dev.off()

#############
#
# AFC 
#
#############

dataSetsToPlot = list(dataObjects_AFC["adaptive"]$adaptive, dataObjects_AFC["random"]$random)


pdf(file = paste(figureFolder, "simulation_AFC_sensory_sq_error.pdf", sep = ""), 
    width = 7,
    height = 3.5)

par(mfrow = c(1, 2))
plotSqError(c(1,2), dataSetsToPlot, 
            mainTitle = expression(sigma))
plotSqError(c(3,4), dataSetsToPlot, 
            mainTitle = expression(beta))

dev.off()

#

pdf(file = paste(figureFolder, "simulation_AFC_interaction_sq_error.pdf", sep = ""), 
    width = 7,
    height = 3.5)

par(mfrow = c(1,2))
plotSqError(c(5,6), dataSetsToPlot, 
            mainTitle = expression(paste(kappa, mu)))
plotSqError(c(7), dataSetsToPlot,  
            mainTitle = expression(rho))

dev.off()

#

pdf(file = paste(figureFolder, "simulation_AFC_sensory_SD.pdf", sep = ""), 
    width = 7,
    height = 3.5)

par(mfrow = c(1, 2))
plotSds(c(1,2), dataSetsToPlot, 
        mainTitle = expression(sigma))
plotSds(c(3,4), dataSetsToPlot, 
        mainTitle = expression(beta))

dev.off()

#

pdf(file = paste(figureFolder, "simulation_AFC_interaction_SD.pdf", sep = ""), 
    width = 7,
    height = 3.5)

  par(mfrow = c(1,2))
  plotSds(c(5,6), dataSetsToPlot, 
          mainTitle = expression(paste(kappa, mu)))
  plotSds(c(7), dataSetsToPlot,  
          mainTitle = expression(rho))

dev.off()


##### COMPARE ADAPTIVE ALGORITHM WITH RANDOM SAMPLING WITH ADAPTIVE GRID: ####
#
# These aren't saved, and are only for the Internet to ogle at.
#
