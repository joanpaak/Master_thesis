#
# A look-up table for approximating bivariate normal cdf
# Uses pbivnorm::pbivnorm to calculate the look-up table, 
# so make sure that is installed. Otherwise everything will fail.
#
# How-to: 
# > LUT = pbivnormLUT()
# > LUT$p(c(0, 0, 0))
#          [,1]     [,2]     [,3]     [,4]
# [1,] 0.251542 0.251542 0.251542 0.251542
#
#

pbivnormLUT = setRefClass("pbivnormLUT", 
                          
                          fields = list(minZ    = "numeric",
                                        maxZ    = "numeric",
                                        nZ      = "numeric",
                                        zVals   = "vector",
                                        stepZ   = "numeric",
                                        minRho  = "numeric",
                                        maxRho  = "numeric",
                                        nRho    = "numeric",
                                        rhoVals = "vector",
                                        stepRho = "numeric",
                                        LUT     = "vector"),
                          
                          methods = list(
                            
                            initialize = function(){
                              
                              print("Initializing look-up table, this usually takes a few seconds... ")
                              print("(Depending on the size of the LUT, obviously)")
                              flush.console()
                              
                              minZ  <<- -2
                              maxZ  <<-  2
                              nZ    <<-  200
                              zVals <<- seq(minZ, maxZ, length.out = nZ)
                              stepZ <<- (maxZ - minZ) / (nZ - 1)
                              
                              minRho  <<- -1
                              maxRho  <<-  1
                              nRho    <<-  100
                              rhoVals <<-  seq(minRho, maxRho, length.out = nRho)
                              stepRho <<- (maxRho - minRho) / (nRho -1) 
                              
                              LUTRef = matrix(NaN, nrow = nZ*nZ*nRho, ncol = 3)
                              
                              LUTRef[,1] = rep(zVals, nZ*nRho)
                              LUTRef[,2] = rep(zVals, each = nZ)
                              LUTRef[,3] = rep(rhoVals, each = nZ*nZ)
                              
                              LUT <<- pbivnorm::pbivnorm(LUTRef[,1], LUTRef[,2], LUTRef[,3])
                              
                              print("Done!")
                            },
                            
                            p = function(zX, zY, rho){
                              
                              #
                              # This is a sort of a hack...
                              #
                              
                              # zX[which(zX > maxZ)] = maxZ
                              # zX[which(zX < minZ)] = minZ
                              # 
                              # zY[which(zY > maxZ)] = maxZ
                              # zY[which(zY < minZ)] = minZ
                              # 
                              rhoInd = findIndex(rho, minRho, stepRho, nRho)
                              xInd   = findIndex(zX, minZ, stepZ, nZ)
                              yInd   = findIndex(zY, minZ, stepZ, nZ)
                              
                              #
                              # Inverted indices are needed for calculating 
                              # areas from the bound to infinity
                              #
                              
                              rhoInd_inv = ((nRho - rhoInd) %% nRho) + 1
                              xInd_inv   = ((nZ - xInd) %% nZ) + 1 
                              yInd_inv   = ((nZ - yInd) %% nZ) + 1 
                              
                              # rhoInd_inv = findIndex(-rho, minRho, stepRho, nRho)
                              # xInd_inv   = findIndex(-zX, minZ, stepZ, nZ)
                              # yInd_inv   = findIndex(-zY, minZ, stepZ, nZ)
                              # 
                              #
                              # How indices are calculated: first find the sector for
                              # correlation  coefficient, then inside that sector the
                              # sector for the z-value on y-axis, and inside that sector
                              # the index for the z-value on the x-axis.
                              #
                              
                              p     = matrix(NaN, nrow = nrow(as.matrix(zX, drop = F)), ncol = 4)
                              
                              ind_1 = (rhoInd   - 1) * nZ * nZ + 1 +
                                      (yInd_inv - 1) * nZ +
                                      (xInd_inv - 1)
                              
                              ind_2 = (rhoInd_inv - 1) * nZ * nZ + 1 +
                                      (yInd_inv   - 1) * nZ +
                                      (xInd       - 1)
                              
                              ind_3 = (rhoInd_inv - 1) * nZ * nZ + 1 +
                                      (yInd       - 1) * nZ +
                                      (xInd_inv   - 1)
                              
                              ind_4 = (rhoInd - 1) * nZ * nZ + 1 +
                                      (yInd   - 1) * nZ +
                                      (xInd   - 1)
                              
                              
                              p[,1] = LUT[ind_1]
                              p[,2] = LUT[ind_2]
                              p[,3] = LUT[ind_3]
                              p[,4] = LUT[ind_4]
                            
                                            
                              return(p)
                            },
                            
                            findIndex = function(x, min_x, step_x, n_x){
                              ind = ceiling((x - min_x) / step_x)
                              ind[which(ind <= 0)] = 1
                              ind[which(ind > n_x)] = n_x
                              return(ind)
                            }
                            
                          )
                        )
# 
# LUT = pbivnormLUT()
# 
# #### TEST ####
# rho = runif(2000, -0.9, 0.9)
# zX  = runif(2000, -3, 3)
# zY  = runif(2000, -3, 3)
# 
# zY = rep(3, 2000)
# zY = rep(-3, 2000)
# 
# zX = -3; zY = -1; rho = 0
# 
# p = LUT$p(zX, zY, rho)
# 
# p_2     = matrix(NaN, nrow = nrow(as.matrix(zX, drop = F)), ncol = 4)
# p_2[,1] = pbivnorm::pbivnorm(-zX, -zY, rho)
# p_2[,2] = pbivnorm::pbivnorm(zX, -zY, -rho)
# p_2[,3] = pbivnorm::pbivnorm(-zX, zY, -rho)
# p_2[,4] = pbivnorm::pbivnorm(zX, zY, rho)
# 
# p
# p_2
# 
# par(mfrow = c(2 ,2))
# plot(p[,1], p_2[,1], xlab = "LUT", ylab = "True value"); abline(0, 1, col = "red")
# plot(p[,2], p_2[,2], xlab = "LUT", ylab = "True value"); abline(0, 1, col = "red")
# plot(p[,3], p_2[,3], xlab = "LUT", ylab = "True value"); abline(0, 1, col = "red")
# plot(p[,4], p_2[,4], xlab = "LUT", ylab = "True value"); abline(0, 1, col = "red")
# 
# 
# 
# zX[which(abs(p[,2] - p_2[,2]) > 0.2)]
# zY[which(abs(p[,2] - p_2[,2]) > 0.2)]
# 
# which(abs(rowSums(p) - 1) > 0.000000000001)
#
# 0001 - 1000 
# 1001 - 2000
# 2001 - 3000
#
#
