# How to replicate analyses

This file will walk you through how to replicate the analyses reported in the thesis.

## What analyses are done

There are two experimental paradigms: Yes/No and 2I-4AFC. In both paradigms three algorithms were run:

  1. Sampling stimuli from a fixed grid
  2. Sampling stimuli from an "adaptive" grid
  3. Choosing stimuli that minimize expected entropy from an adaptive grid
  
These algorithms won't be described further here. The reader is advised to take a look at the main text (PDF) or the source codes.

Analyses conducted here are graphical. No need to calculate or estimate anything. 

Data from the Yes/No and 2I-4AFC simulations are analysed separately. The idea is to compare the three aforemementioned algorithms inside each condition. HOWEVER, since this takes quite a bit of room, comparison between algorithms 1 and 3 are compared in the paper, since that's the most relevant comparison: between something truly non-adaptive and adaptive. Comparison between algorithms 2 and 3 can be found from the sources here.

## What's the data? Is it  the raw data? How is the data structured?

Well, sadly, since the raw data consists of particle filter approximations of the posterior distributions on a trial-by-trial basis, it takes quite a bit of disk space. On top of that, those approximations aren't *really* used for anything beyond the marginal means  and sds presented here, so for that reason I present the data in a slightly condensed form. That is, the complete particle sets have been thrown away and indeed are replaced by the trial-by-trial means and sds. 

Data for the Yes/No paradigm is stored in the object dataObjects_YN and data from the AFC paradigm in the object dataObjects_AFC.

Each of these contains three more named lists: adaptive (3), random (2) and random_fs (1). The numbers in brackets are not included in the names, they indicate which one of the algorithms was used to generate the data.

You will find all of the relevant data inside these lists:

```
> ls(dataObjects_YN$adaptive)
[1] "genTheta" "muTheta"  "R"        "S"        "sdTheta" 
```

These are most conveniently accessed using the $ operator. 

genTheta houses all of the generating theta in a matrix form. In this case

```
> dim(dataObjects_YN[["adaptive"]]$genTheta)
[1] 184   9
```

there are nine parameters and 184 simulated participants. 

muTheta and sdTheta house the marginal means and standard deviations. Use double boxes and numbers to get either for a given dimension:

```
> dim(dataObjects_YN[["adaptive"]]$muTheta[[1]])
[1] 184 800
```

this gets the trial-by-trial (there are 800 trials) marginal means for all of the 184 simulated participants for the first dimension.

S and R contain stimuli and responses, respectively. Here, double boxes are used to find stimuli or responses for a given simulated participant:

```
> dim(dataObjects_YN[["adaptive"]]$S[[184]])
[1] 800   2
```

This gets all stimuli for the simulated participant number 184.
