getFNames = function(typeOfExperiment, dataFolder){
  #
  # Id I'd just learn how to write rexexps, this
  # function would be obsolete
  #
  
  fNames = dir(dataFolder)[grepl(typeOfExperiment, dir(dataFolder))]
  fNames = fNames[grepl(".dat", fNames)]
  return(fNames)
}

readDataFromFolder = function(dataFolder){
    
  fNames = list()
  
  fNames$YesNo = getFNames("YesNo", dataFolder)
  fNames$AFC   = getFNames("AFC",   dataFolder)
  
  
  NPerSession = 100
  NSessions   = 4
  
  datMatYN  = matrix(NaN, ncol = 4, nrow = NPerSession * NSessions)
  datMatAFC = matrix(NaN, ncol = 4, nrow = NPerSession * NSessions)
  
  for(i in 1:length(fNames$YesNo)){
    currDataYN  = new.env()
    currDataAFC = new.env()
    
    load(paste(dataFolder, fNames$YesNo[i], sep = ""), envir = currDataYN)
    load(paste(dataFolder, fNames$AFC[i], sep = ""), envir = currDataAFC)
    
    ind_1 = (i - 1) * NPerSession  + 1
    ind_2 = i * NPerSession
    
    datMatYN[ind_1:ind_2,1:2] = currDataYN$S
    datMatYN[ind_1:ind_2,3:4] = currDataYN$R
    
    datMatAFC[ind_1:ind_2,1:2] = currDataAFC$S
    datMatAFC[ind_1:ind_2,3:4] = currDataAFC$R
  }
  
  return(list(datMatYN = datMatYN, datMatAFC = datMatAFC))
}