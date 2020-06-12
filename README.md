# Bayesian Adaptive Estimation and Inference in General Recognition Theory Models With Pschometric Functions

That's the current title of my thesis. It's subject to a lot of change in the coming days. 

## Abstract

General Recognition Theory (GRT) is a multidimensional generalization of Signal Detection Theory. It is used to model the detection of signals with multiple dimensions, e.g. auditory signals which can vary not only in their pitch but also in their timbre independently. Main focus is in if the detection of these dimensions is coupled.

Bayesian adaptive estimation has been succesfully applied to many different tasks and models in psychophysics. The main goal of this thesis is to study the application of it to GRT models. To achieve this, I will introduce a GRT models for a Yes/No and 2I-4AFC procedure that include psychometric functions to model the relationship between physical signal strengths and $d'$ explicitly. Also, methods for Bayesian estimation of these models are introduced.

The performance of the models are evaluated in simulations (N = 772) and in a small scale psychophysical experiment (N = 2).

Simulations indicate that the adaptive algorithm is more efficent on average, but offers little practical improvement over random sampling in this context. 

Data from the psychophysical experiments indicate that non-sensory factors play a big part, indicating that more work should be put into developing models/procedures that can identify between these factors. The data also suggests that the often default choice of coupling means does not necessarily capture all relevant properties of it. 

# PDF

The actual thesis can be found in a PDF format from the aptly named folder *PDF*. What's included are also sources for the pdf-file in .rnw format. If you want to, you can compile your own pdf, but I will also provide a pre-compiled version.

## Notes on compiling the PDF from the sources

I've only compiled the PDF from RStudio, I've no idea how it'll compile if using other methods. Remember to use knitr when compiling. 

Be sure to set working directory to whereever you have stored your files. 

When compiling the PDF for the first time, the thing needs to create a .toc file for displaying the Table of Contents; for this reason, TOC isn't visible after compiling just once. I think there's a way of generating the file without all of this hassle, but I've forgotten how.
