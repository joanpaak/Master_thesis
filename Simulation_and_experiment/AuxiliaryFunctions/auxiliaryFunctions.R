#
# This acts like  namespace, or central hub, for sourcing all of the crap that's needed for running an experiment or a simulation
#
#

print("Sourcing stimulus functions...")
source("AuxiliaryFunctions/stimulusFunctions.R")
print("Done")

print("Sourcing particle set functions...")
source("AuxiliaryFunctions/particleSetFunctions.R")
print("Done")

print("Sourcing probability functions...")
source("AuxiliaryFunctions/probabilityFunctions.R")
print("Done")

print("Sourcing look-up table...")
source("AuxiliaryFunctions/LUT_as_an_object.R")
print("Done")

print("Sourcing stimulus picking functions...")
source("AuxiliaryFunctions/stimPickFunctions.R")
print("Done")

print("Sourcing file IO functions...")
source("AuxiliaryFunctions/fileIOfunctions.R")
print("Done")
