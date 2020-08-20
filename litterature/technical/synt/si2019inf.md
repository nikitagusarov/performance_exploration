# Abstract

*Discrete choice models* are commonly applied in decision making contexts. 
But problems in predictive performance, variable selection and/or model interpretation arise when the number of predictors greatly exceeds the sample size. 
In this study, such problems are mitigated via a heuristic approach combining dimension reduction and multiple comparisons correction. 
As a pre-process for variable selection, dimension reduction on high-dimensional inputs of the discrete choice model is conducted. 
Variables that were selected are then subjected to a *local scoring algorithm with backfitting*. 
To lower the false discovery rate, the Benjamini-Hochberg (BH) procedure is then implemented on the significant predictors resulting from the backfitting. 
Simulation studies show that most of the balanced cases are correctly sized, and consistently, the proposed test procedure is more powerful than the ordinary Bonferroni multiple comparisons testing procedure.

# Introduction

Discrete choice models are presented as development and renovation of the classical choice theory. 
These models have overcome the rigidities and inadequacies of consumer behavior study by mentioning the problems of economic agent choices in random specific environment for each situation involving the choice between mutually exclusive alternatives (**Aloulou, 2018**). 
The model has been used extensively to discrete choice processes in different fields such as econometrics (**McFadden, 1974**; **Manski and McFadden, 1981**) and transportation (**Ben-Akiva and Lerman, 1985**) to name some. 
These resulted with great success because of the model’s analytical and computational tractability (**Abe, 1999**).

**Abe (1999)** developed a methodology for discrete choice data using the generalized additive model (GAM). 
This method incorporates an additive predictor instead of a linear predictor for the Multinomial logit (MNL) model. 
This *relaxes the linear-in parameter constraint of the MNL model* while circumventing the curse of dimensionality which is the drawback of fully nonparametric multivariate MNL models (**Giron, 2010**).

- **Giron (2010)** assessed the feasibility and efficiency of using principal components of the predictors in the *generalized additive mode* (GAM) for discrete choice data and determine its capacity to manage drawbacks of high-dimensional data.
- **Torres (2013)** extended the work of **Giron (2010)** by using *generalized adaptive sparse-PCA* (GAS-PCA) as a data reduction tool and used GAM for high dimensional discrete data.