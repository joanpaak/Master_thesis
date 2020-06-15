# Bayesian Adaptive Estimation and Inference in General Recognition Theory Models With Psychometric Functions

That's the current title of my thesis. It's subject to a lot of change in the coming days. 

## Current stage

The thesis is not done yet; it shall be very soon, though! Currently I am writing the first version:

First versions done for these sections:
- [x] Abstract
- [x] Introduction
- [x] Theoretical Background: SDT
- [x] Theoretical Background: GRT
- [x] Theoretical Background: Bayes
- [ ] Theoretical Background: Adaptive estimation
- [x] Simulations
- [ ] Psychophysical Experiments
- [ ] Discussion
- [] Appendices

Download the latest PDF via this link (right click on it and save it, opening it in GitHub is slow): [the latest pdf](PDF/Main.pdf).

## Abstract

General Recognition Theory (GRT) is a multidimensional generalization of Signal Detection Theory. It is used to model the detection of signals with multiple dimensions, e.g. auditory signals which can vary not only in their pitch but also in their timbre independently. Main focus is in if the detection of these dimensions is coupled.

Bayesian adaptive estimation has been successfully applied to many different tasks and models in psychophysics. The main goal of this thesis is to study the application of it to GRT models. To achieve this, I will introduce a GRT models for a Yes/No and 2I-4AFC procedure that include psychometric functions to model the relationship between physical signal strengths and $d'$ explicitly. Also, methods for Bayesian estimation of these models are introduced.

The performance of the models are evaluated in simulations (N = 772) and in a small scale psychophysical experiment (N = 2).

Simulations indicate that the adaptive algorithm is more efficient on average, but offers little practical improvement over random sampling in this context. 

Data from the psychophysical experiments indicate that non-sensory factors play a big part, indicating that more work should be put into developing models/procedures that can identify between these factors. The data also suggests that the often default choice of coupling means does not necessarily capture all relevant properties of it. 

# PDF

The actual thesis can be found in a PDF format from the aptly named folder *PDF*. What's included are also sources for the pdf-file in .rnw format. If you want to, you can compile your own pdf, but I will also provide a pre-compiled version.

## Notes on compiling the PDF from the sources

I've only compiled the PDF from RStudio, I've no idea how it'll compile if using other methods. Remember to use knitr when compiling. 

Be sure to set working directory to wherever you have stored your files. 

When compiling the PDF for the first time, the thing needs to create a .toc file for displaying the Table of Contents; for this reason, TOC isn't visible after compiling just once. I think there's a way of generating the file without all of this hassle, but I've forgotten how.
