# Abstract

Generalized additive models (GAMs) are a generalization of generalized linear models (GLMs) and constitute a powerful technique which has successfully proven its ability to capture nonlinear relationships between explanatory variables and a response variable in many domains. 
In this paper, GAMs are proposed as base classifiers for ensemble learning. 
Three alternative ensemble strategies for binary classification using GAMs as base classifiers are proposed: 

1. GAMbag based on *Bagging*, 
2. GAMrsm based on the *Random Subspace Method* (RSM), 
3. GAMens as *a combination of both*. 

In an experimental validation performed on 12 data sets from the UCI repository, the proposed algorithms are benchmarked to a single GAM and to decision tree based ensemble classifiers (i.e. RSM, Bagging, Random Forest, and the recently proposed Rotation Forest). 
From the results a number of conclusions can be drawn. 

- Firstly, the use of an ensemble of GAMs instead of a single GAM always leads to improved prediction performance. 
- Secondly, GAMrsm and GAMens perform comparably, while both versions outperform GAMbag. 
- Finally, the value of using GAMs as base classifiers in an ensemble instead of standard decision trees is demonstrated. 

GAMbag demonstrates performance comparable to ordinary Bagging.
Moreover, GAMrsm and GAMens outperform RSM and Bagging, while these two GAM ensemble variations perform comparably to Random Forest and Rotation Forest. 
Sensitivity analyses are included for the number of member classifiers in the ensemble, the number of variables included in a random feature subspace and the number of degrees of freedom for GAM spline estimation.