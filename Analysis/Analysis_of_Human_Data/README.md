# Analysis of Human Data

As part of the thesis, two psychophysical experiments were conducted. For details, see the main text.

This file will in detail aid the reader through the analysis of the human data.

Uncompiled models live in the folder "models" and compiled models live in the folder "compiled_models". It is advisable to save the compiled  models in that folder, since that will significantly reduce the time needed to redo the analyses if something goes wrong.

## How to replicate the analyses:

Note that some of these steps WILL take quite a bit of time, especially fitting the models. Significant reductions in fitting time can be achieved, first, by not fitting the non-truncated models with both kinds of interactions for the participant JP. The point in fitting them is, after all, to just demonstrate the non-identifiability related problems in those models. Another thing to consider is the prior for the correlation coefficient; I'll get back to this in an important note.

- Run compileAndSaveModels.R 
    - This will compile all of the Stan models and save them into the ../../compiled_models folder
- Run fitAllModels_JP.R and fitAllModels_OK.R
    - Nomen est omen: the models will be fit and saved in the analysis_files folder. 
    
You should now have the files

- modelFits_JP.rData
- modelFits_OK.rData
- truncated_models_JP.rData

in the analysis_files/ folder. 
    
- Run drawPosteriorPredictive_JP.R and drawPosteriorPredictive_OK.R
    - These files will generate posterior predictive distributions for all of the models.  
    
This will generate the files

- postPredJP.rData
- postPredOK.rData

in the analysis_files/ folder.

### !!! IMPORTANT NOTE !!!

One thing to notice about the models with normal prior on the atanh transformed correlation: these models can produce chains that are stuck at an extreme values of correlation! Stan will become *extremely* slow! If/when this happens, you should exclude these chains by hand; this is how it's done now, e.g.: 

```
as.matrix(JP_dat$dataToSave$fitYesNo[[1]])[1:3000,]
```

(1000 draws per chain, the last chain is not included)

## Draw figures:

The last part of the analysis is to produce the figures for eyeballing the estimated coefficients. Figures are produced by the scripts

- plotBothParticipants.R
- plotPosteriorPredictive_JP.R
- plotPosteriorPredictive_OK.R

The following figures will be produced.
- Model fits
  - JP_YN_Basic_models.png
    - YN, Models 1-3
  - JP_AFC_Basic_models.png
    - AFC, Models 1-3
  - JP_YN_AFC_Both.png
    - The Model "Both"; coefficients from AFC/YN in same plot4  
  - JP_YN_AFC_Both_T.png
    - The Model "Both (Truncated)"; coefficients from AFC/YN in same plot
- Posterior predictive plots
  - JP_YN_post_pred.png
    - YN, Models 1-3
  - JP_AFC_post_pred.png
    - AFC, Models 1-3
  - JP_post_pred_both_truncated.png
    - YN and AFC, Both (Truncated)
  - OK_YN_post_pred.png
    - YN, Models 1-3
  - OK_AFC_post_pred.png
    - AFC, models 1-3
  - OK_post_pred_both_truncated.png
    - YN and AFC, Both
