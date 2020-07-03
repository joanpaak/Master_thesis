
Rcpp::sourceCpp("cppSampling.cpp")

##### FUNCTIONS FOR DRAWING SAMPLES FROM THE POSTERIOR PREDICTIVE DISTRIBUTIONS ####
#
# FOR ALL OF THE FUNCTIONS:
#
# Theta : matrix of posterior draws. N = nrow(theta) posterior predictive 
#  data sets will be drawn.
# S : matrix of stimulus values to be used when drawing the posterior 
#  predictive data sets.

# GENERAL DESCRIPTION OF WHAT'S GOING ON. 
#
# 1) How are posterior predictive samples drawn
# 
# All of the algorithms for drawing posterior predictive data sets work
# the same way. First, integration bounds (for bivariate CDF) for a single
# stimulus and all posterior samples are found. This can be vectorized
# so it is very fast. 
# 
# Second, these integration limits, and the sampled correlation coefficients, 
# are passed to pbivnorm::pbivnorm, which can evaluate bivarate normal CDF's 
# in a vectorized way, again, making this fast. All of the response regions 
# are found this way. The end product of this step is matrix of probabilities, 
# which has four columns (four response regions) and  as many rows as there
# are posterior samples (to be used for approximating the posterior predictive
# distribution). Each row should sum to unity. 
#
# Next, each row of the aforementioned matrix is used for drawing a random sample,
# the response category. I've written couple custom c++ functions for this, since 
# I don't think this step can be easily vectorized, and this was the most time consuming
# step when using apply and sample to draw the random numbers. 
#
# Lastly, the random numbers are used to get rows of the pre-defined "R-matrix", to 
# essentially transform response categories to bivariate responses (e.g. 3 -> (-1, 1))
#
# 2) The "Main functions"
# 
# What are called main functions are responsible for binning the responses. 
#
# The function createCategories will accept a matrix of stimuli (in which the 
# first index is for trials and second index for dimension) and vectors of 
# limits for the bins. I've only used this with four limits per dimension, 
# with the first always being -Inf and the last maximum value (creating three
# bins per dimension and nine in total). The later function, "createCatMat" is 
# now hardcoded to expect nine cateogories.
#
# This will return a list of categories. In the default case, there are nine entries to
# the list. Each entry tells which one of the categories it is (e.g. x = 1, y = 3) and 
# indicises of stimuli that belong to that category. This makes categorizing replicated
# data faster. 
#
# createCatMat will apply the aforementioned list of indices and bin indices to a matrix
# of responses (first index is trials, second index dimensions; coded with -1 and 1). This
# returns a matrix with columns: 
# 1: Prop. of pos. responses (dim_x)
# 2: Prop. of pos. responses (dim_x)
# 3: index of bin on x dimension
# 4: index of bin on y dimension
#
# splitRepData applies the createCatMat function to multiple replicated data sets, 
# returning a three dimensional array, in which each data set has been transformed
# into a matrix that was just described. 
#


#### Yes/No models ####

drawPostPred_YN_mdl_1 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,9])
  
  for(i in 1:nrow(S)){
    
    u_x = -theta[,3] + (S[i,1] / exp(theta[,1]))^exp(theta[,5]) + theta[,7] * S[i,2]
    u_y = -theta[,4] + (S[i,2] / exp(theta[,2]))^exp(theta[,6]) + theta[,8] * S[i,1]
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = 0.02 * 0.25 + 0.98 * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

drawPostPred_YN_mdl_2 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,9])
  
  for(i in 1:nrow(S)){
    
    u_x = -theta[,3] + (S[i,1] / exp(theta[,1]))^exp(theta[,5]) + theta[,7] * S[i,2]
    u_y = -theta[,4] + (S[i,2] / exp(theta[,2]))^exp(theta[,6]) + theta[,8] * S[i,1]
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,10] * 0.25 + (1 - theta[,10]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    
    # randMultinom = as.vector(apply(p, 1, function(x){sample(1:4, 1, F, x)}))
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}


drawPostPred_YN_mdl_3 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,9])
  
  for(i in 1:nrow(S)){
    
    sigma_x = exp(theta[,1] + theta[,7] * S[i,2])
    sigma_y = exp(theta[,2] + theta[,8] * S[i,1])
    
    u_x = -theta[,3]/sigma_x + (S[i,1] / sigma_x)^exp(theta[,5])
    u_y = -theta[,4]/sigma_y + (S[i,2] / sigma_y)^exp(theta[,6])
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,10] * 0.25 + (1 - theta[,10]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

drawPostPred_YN_both = function(theta, S){
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = theta[,11]
  
  for(i in 1:nrow(S)){
    
    sigma_x = exp(theta[,1] + theta[,9] * S[i,2])
    sigma_y = exp(theta[,2] + theta[,10] * S[i,1])
    
    u_x = -theta[,3]/sigma_x + (S[i,1] / sigma_x)^exp(theta[,5]) + theta[,7] * S[i,2] 
    u_y = -theta[,4]/sigma_y + (S[i,2] / sigma_y)^exp(theta[,6]) + theta[,8] * S[i,1]
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,12] * 0.25 + (1 - theta[,12]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

#### AFC models #####

drawPostPred_AFC_mdl_1 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,7])
  
  for(i in 1:nrow(S)){
    
    u_x = (S[i,1] / exp(theta[,1]))^exp(theta[,3]) / 1.414214 + theta[,5] * S[i,2]
    u_y = (S[i,2] / exp(theta[,2]))^exp(theta[,4]) / 1.414214 + theta[,6] * S[i,1]
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = 0.02 * 0.25 + 0.98 * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

drawPostPred_AFC_mdl_2 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,7])
  
  for(i in 1:nrow(S)){
    
    u_x = (S[i,1] / exp(theta[,1]))^exp(theta[,3]) / 1.414214 + theta[,5] * S[i,2]
    u_y = (S[i,2] / exp(theta[,2]))^exp(theta[,4]) / 1.414214 + theta[,6] * S[i,1]
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,8] * 0.25 + (1 - theta[,8]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    
    # randMultinom = as.vector(apply(p, 1, function(x){sample(1:4, 1, F, x)}))
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

drawPostPred_AFC_mdl_3 = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = tanh(theta[,7])
  
  for(i in 1:nrow(S)){
    
    sigma_x = exp(theta[,1] + theta[,5] * S[i,2])
    sigma_y = exp(theta[,2] + theta[,6] * S[i,1])
    
    u_x = (S[i,1] / sigma_x)^exp(theta[,3]) / 1.414214
    u_y = (S[i,2] / sigma_y)^exp(theta[,4]) / 1.414214
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,8] * 0.25 + (1 - theta[,8]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

drawPostPred_AFC_both = function(theta, S){
  
  # Tolerance for checking that the probability vectors sum to 1:
  tol = 1e-6
  
  # Absolute limit for the integration, that is, any number 
  # x > limit = limit and x > -limit = -limit  
  limit = 10
  
  R = matrix(c(-1, -1,
               1, -1, 
               -1,  1,
               1,  1), 4, 2, byrow = T)
  
  post_pred = array(dim = c(nrow(theta), 400, 2))
  
  p = matrix(NaN, nrow = nrow(theta), 4)
  
  rho = theta[,9]
  
  for(i in 1:nrow(S)){
    
    sigma_x = exp(theta[,1] + theta[,7] * S[i,2])
    sigma_y = exp(theta[,2] + theta[,8] * S[i,1])
    
    u_x = ((S[i,1] / sigma_x)^exp(theta[,3]) + theta[,5] * S[i,2]) / 1.414214
    u_y = ((S[i,2] / sigma_y)^exp(theta[,4]) + theta[,6] * S[i,1]) / 1.414214
    
    u_x[u_x > limit] = limit
    u_y[u_y > limit] = limit
    
    u_x[u_x < -limit] = -limit
    u_y[u_y < -limit] = -limit
    
    integrationLimits = cbind(u_x, u_y)
    
    p[,1] = pbivnorm::pbivnorm(-integrationLimits[,1], -integrationLimits[,2], rho)
    p[,2] = pbivnorm::pbivnorm(integrationLimits[,1], -integrationLimits[,2], -rho)
    p[,3] = pbivnorm::pbivnorm(-integrationLimits[,1], integrationLimits[,2], -rho)
    p[,4] = pbivnorm::pbivnorm(integrationLimits[,1], integrationLimits[,2], rho)
    
    p[p<0] = 0
    p[p>1] = 1
    
    p = theta[,10] * 0.25 + (1 - theta[,10]) * p
    
    if(any(abs(rowSums(p) - 1) > tol)){
      stop("Row sum did not equal 1.0")
    }
    
    randMultinom = getResponseCategories(p)
    
    if(any(randMultinom == -1)){
      stop("-1 from multinomial sampler!")
    }
    
    sim_R = R[randMultinom,]
    post_pred[,i,] = sim_R
  }
  
  return(post_pred)
}

#### Main Functions #####

createCategories = function(S, lim_x, lim_y){
  
  categories = list()  
  r = 1
  
  for(i in 1:(length(lim_x) - 1)){
    for(j in 1:(length(lim_y) - 1 )){
      
      categories[[r]] = list()
      
      inds = 
        which(S[,1] > lim_x[i] & S[,1] <= lim_x[i+1] &
                S[,2] > lim_y[j] & S[,2] <= lim_y[j+1])
      
      categories[[r]]$inds = inds
      categories[[r]]$x = i
      categories[[r]]$y = j
      
      r = r + 1
    }
  }
  return(categories)
}

createCatMat = function(R, cats){
  # R  = matrix of responses
  # cats = categories according to which categorize
  catMat = matrix(NaN, nrow = 9, ncol = 4)
  
  for(i in 1:9){
    catMat[i,1] = sum((R[cats[[i]]$inds,1] + 1) / 2) / length(cats[[i]]$inds)
    catMat[i,2] = sum((R[cats[[i]]$inds,2] + 1) / 2) / length(cats[[i]]$inds)
    catMat[i,3] = cats[[i]]$x
    catMat[i,4] = cats[[i]]$y
  }
  
  colnames(catMat) = c("PYes_x", "PYes_y", "Cat_x", "Cat_y")
  
  return(catMat)
}

splitRepData = function(simR, categories){
  #
  # Don't talk to me about refactoring. 
  # simR = simulated responses.  
  # lim_x, lim_y = bounds for the bins for the stimuli
  # dataForStan = the dataset this all is based on?! I can see what
  #   this does in the code, but really, should you refac---
  
  nDraws  = dim(simR)[1]
  simPmat = array(NaN, dim = c(nDraws, 9, 4))
  
  for(s in 1:nDraws){
    simPmat[s,,] = createCatMat(simR[s,,], categories)
  }
  
  return(simPmat)
}

