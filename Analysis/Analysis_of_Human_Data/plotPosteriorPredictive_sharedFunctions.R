#### Plotting funtions ####

drawArrow = function(x, y, col = "black"){
  # A wrapper for the arrow drawing function, to make it  more similar
  # to lines() function
  arrows(x[1], y[1], x[2], y[2], angle = 90, code = 3, length = 0.1, col = col)
}

# Some attributes for the plots:

colPalette  = c("#E69F00", "#56B4E9", "#009E73")
catSpacing  = 0.25
predLwd     = c(4.5, 7.5) * 1.5
plotQ_1     = c(0.025, 0.975)
plotQ_2     = c(0.125, 0.875)
p_cex       = 2.0

plotRepData = function(simPmat, obsProp, dim = "x"){
  
  # Calculate quantiles:
  
  if(dim == "x"){
    y_0_Q1 = apply(simPmat[,simPmat[1,,4] == 1,1], 2, function(x){quantile(x, plotQ_1)})
    y_1_Q1 = apply(simPmat[,simPmat[1,,4] == 2,1], 2, function(x){quantile(x, plotQ_1)})
    y_2_Q1 = apply(simPmat[,simPmat[1,,4] == 3,1], 2, function(x){quantile(x, plotQ_1)})
    
    y_0_Q2 = apply(simPmat[,simPmat[1,,4] == 1,1], 2, function(x){quantile(x, plotQ_2)})
    y_1_Q2 = apply(simPmat[,simPmat[1,,4] == 2,1], 2, function(x){quantile(x, plotQ_2)})
    y_2_Q2 = apply(simPmat[,simPmat[1,,4] == 3,1], 2, function(x){quantile(x, plotQ_2)})
  } else {
    y_0_Q1 = apply(simPmat[,simPmat[1,,3] == 1,2], 2, function(x){quantile(x, plotQ_1)})
    y_1_Q1 = apply(simPmat[,simPmat[1,,3] == 2,2], 2, function(x){quantile(x, plotQ_1)})
    y_2_Q1 = apply(simPmat[,simPmat[1,,3] == 3,2], 2, function(x){quantile(x, plotQ_1)})
    
    y_0_Q2 = apply(simPmat[,simPmat[1,,3] == 1,2], 2, function(x){quantile(x, plotQ_2)})
    y_1_Q2 = apply(simPmat[,simPmat[1,,3] == 2,2], 2, function(x){quantile(x, plotQ_2)})
    y_2_Q2 = apply(simPmat[,simPmat[1,,3] == 3,2], 2, function(x){quantile(x, plotQ_2)})
  }
  
  # Initialize plot:
  
  plot(NULL, xlim = c(1 - catSpacing, 3 + catSpacing), 
       ylim = c(0, 1), xlab = "", 
       ylab = "", axes = F); axis(side = 1, at = 1:3, labels = 1:3); 
  axis(side = 2)
  
  # Create grid:
  
  # abline(v = 1:3, lty = 2)
  # abline(v = (1:3) - catSpacing, lty = 2)
  # abline(v = (1:3) + catSpacing, lty = 2)
  # 
  abline(h = seq(0, 1, 0.2), lty = 3, col = rgb(0, 0, 0, 0.9))
  
  # Plot replications:
  
  lines(rep(1 - catSpacing, 2), y_0_Q1[,1], col = colPalette[1], lwd = predLwd[1], lend = 2)
  lines(rep(1, 2),              y_0_Q1[,2], col = colPalette[2], lwd = predLwd[1], lend = 2)
  lines(rep(1 + catSpacing, 2), y_0_Q1[,3], col = colPalette[3], lwd = predLwd[1], lend = 2)
  
  lines(rep(2 - catSpacing, 2), y_1_Q1[,1], col = colPalette[1], lwd = predLwd[1], lend = 2)
  lines(rep(2, 2),              y_1_Q1[,2], col = colPalette[2], lwd = predLwd[1], lend = 2)
  lines(rep(2 + catSpacing, 2), y_1_Q1[,3], col = colPalette[3], lwd = predLwd[1], lend = 2)
  
  lines(rep(3 - catSpacing, 2), y_2_Q1[,1], col = colPalette[1], lwd = predLwd[1], lend = 2)
  lines(rep(3, 2),              y_2_Q1[,2], col = colPalette[2], lwd = predLwd[1], lend = 2)
  lines(rep(3 + catSpacing, 2), y_2_Q1[,3], col = colPalette[3], lwd = predLwd[1], lend = 2)
  
  #
  
  lines(rep(1 - catSpacing, 2), y_0_Q2[,1], col = colPalette[1], lwd = predLwd[2], lend = 2)
  lines(rep(1, 2),              y_0_Q2[,2], col = colPalette[2], lwd = predLwd[2], lend = 2)
  lines(rep(1 + catSpacing, 2), y_0_Q2[,3], col = colPalette[3], lwd = predLwd[2], lend = 2)
  
  lines(rep(2 - catSpacing, 2), y_1_Q2[,1], col = colPalette[1], lwd = predLwd[2], lend = 2)
  lines(rep(2, 2),              y_1_Q2[,2], col = colPalette[2], lwd = predLwd[2], lend = 2)
  lines(rep(2 + catSpacing, 2), y_1_Q2[,3], col = colPalette[3], lwd = predLwd[2], lend = 2)
  
  lines(rep(3 - catSpacing, 2), y_2_Q2[,1], col = colPalette[1], lwd = predLwd[2], lend = 2)
  lines(rep(3, 2),              y_2_Q2[,2], col = colPalette[2], lwd = predLwd[2], lend = 2)
  lines(rep(3 + catSpacing, 2), y_2_Q2[,3], col = colPalette[3], lwd = predLwd[2], lend = 2)
  
  # Plot observed data:
  
  
  if(dim == "x"){
    
    points(1 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_y"] == 1,"PYes_x"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
    points(2 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_y"] == 2,"PYes_x"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
    points(3 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_y"] == 3,"PYes_x"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
  } else {
    
    points(1 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_x"] == 1,"PYes_y"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
    points(2 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_x"] == 2,"PYes_y"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
    points(3 + c(-catSpacing, 0, catSpacing), 
           obsProp[obsProp[,"Cat_x"] == 3,"PYes_y"], type = "b", lty = 2, 
           pch = 19, cex = p_cex)
  }
}

# Leftmost  : y = 0
# Center    : y = 1
# Rightmost : y = 2