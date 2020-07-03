#
# YesNo_std_block_1.dat
# YesNo_std_block_2.dat
# YesNo_sdt.particles

# 4AFC_block_1.dat
# 4AFC_block_2.dat

loadParticles = function(experimentAttributes){
  dataFolder = paste("Data//", experimentAttributes$participantName, "//", sep = "")
  
  # This regex tries to find filenames that have the typeOfExperiment string AND 
  # .particles string in them. This SHOULD return the correct particle file... if
  # this is correct!
  regexToFindParticleFiles = paste("(.*", typeOfExperiment, ")(.*particles)", sep = "")
  particleFiles = dir(dataFolder, pattern = regexToFindParticleFiles)
}

# saveExperimentOnFile = function(experimentAttributes){
  # fileNameRoot = 
# }

findNextIndex = function(dataFolder, typeOfExperiment){
  block = 1
  fNames = dir(dataFolder, pattern = ".dat")
  if(length(fNames) == 0){
    return(block)
  }
  candidateName = paste(typeOfExperiment, "_block_", block, ".dat", sep = "")
  while(any(candidateName == fNames)){
    block = block + 1
    candidateName = paste(typeOfExperiment, "_block_", block, ".dat", sep = "")
  }
  return(block)
}
