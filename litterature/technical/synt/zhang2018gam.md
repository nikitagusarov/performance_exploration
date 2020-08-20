# Abstract

The *generalised additive models* (GAM) are widely used in data analysis. 
In the application of the GAM, the link function involved is usually assumed to be a commonly used one without justification. 
Motivated by a real data example with binary response where the commonly used link function does not work, we propose a *generalised additive models with unknown link function* (GAMUL) for various types of data, including binary, continuous and ordinal. 
The proposed estimators are proved to be consistent and asymptotically normal. 
Semiparametric efficiency of the estimators is demonstrated in terms of their linear functionals. 
In addition, an iterative algorithm, where all estimators can be expressed explicitly as a linear function of $Y$, is proposed to overcome the computational hurdle for the GAM type model.
Extensive simulation studies conducted in this paper show the proposed estimation procedure works very well. 
The proposed GAMUL are finally used to analyze a real dataset about loan repayment in China, which leads to some interesting findings.

# Introduction

The additive models and the generalised additive models (GAM) are widely used in data analysis to explore the nonlinear effects of the covariates on the response variable. 
Whilst getting away with the ‘‘curse of dimensionality’’, they are also reasonably flexible.
The relevant literature includes **Stone (1985, 1986)**, **Breiman and Friedman (1985)**, **Buja et al. (1989)**, **Hastie and Tibshirani (1990)**, **Linton and Nielsen (1995)**, **Linton and Härdle (1996)**, **Opsomer and Ruppert (1997)**, **Fan et al. (1998)**, **Mammen et al. (1999)**, **Opsomer (2000)**, **Linton (2000)**, **Horowitz and Mammen (2004)**, **Nielsen and Sperlich (2005)**, **Mammen and Park (2006)**, **Yu et al. (2008)** and the reference therein.

When using GAM to fit a dataset, people usually assume the link function is a commonly used one without much justification, e.g., the link function is assumed to be a logit function when the response variable is binary, a logarithmic function when the response variable is a count variable. 
However, in some real data analysis, the commonly used link function may not be appropriate, and the misspecification of the link function results in biased estimators for the component functions.