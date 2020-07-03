#
# A very high-level test for drawing and plotting posterior predictive 
# distributions.
#

# Simulate data from uniform distribution

N_simulations = 5000
unifData_05 = array(rbinom(N_simulations * 400 * 2, 1, 0.5) * 2 - 1, dim = c(N_simulations, 400, 2))
unifData_075 = array(rbinom(N_simulations * 400 * 2, 1, 0.75) * 2 - 1, dim = c(N_simulations, 400, 2))

splitData  = splitRepData(unifData_05, categories_YN)
obsProp_YN[1:9,1:2] - splitData[1,1:9,1:2]

par(mfrow = c(1,2))
plotRepData(splitRepData(unifData_05, categories_YN), obsProp_YN, "x")
plotRepData(splitRepData(unifData_05, categories_YN), obsProp_YN, "y")

par(mfrow = c(1,2))
plotRepData(splitRepData(unifData_075, categories_YN), obsProp_YN, "x")
plotRepData(splitRepData(unifData_075, categories_YN), obsProp_YN, "y")


# Simulate data from a linear slope

sdev = sqrt(0.5*(1-0.5)/6)
0.5 + 1.96 * sdev
0.5 - 1.96 * sdev
