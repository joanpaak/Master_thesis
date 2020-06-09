# How to replicate analyses

This file will walk you through how to replicate the analyses reported in the thesis.

## What analyses are done

There are two experimental paradigms: Yes/No and 2I-4AFC. In both paradigms three algorithms were run:

  1. Sampling stimuli from a fixed grid
  2. Sampling stimuli from an "adaptive" grid
  3. Choosing stimuli that minimize expected entropy from an adaptive grid
  
These algorithms won't be described further here. The reader is advised to take a look at the main text (PDF) or the source codes.

Analyses conducted here are graphical. No need to calculate or estimate anything. Things are pretty clear.

Data from the Yes/No and 2I-4AFC simulations are analysed separately. The idea is to compare the three aforemementioned algorithms inside each condition. 

## How is data stored? / How to read data?

To read files, this function is used:
    readDataFromFolder(N_DIMENSIONS, N_TRIALS, FOLDER, REGEX_FOR_FINDING_FILES)
