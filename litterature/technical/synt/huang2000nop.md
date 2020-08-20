# Abstract 

Many researchers use categorical data analysis to recover individual consumption preferences, but the standard discrete choice models require restrictive assumptions. 
To improve the #exibility of discrete choice data analysis, we propose a nonparametric multiple choice model that applies the penalized likelihood method within the random utility framework. 
We show that the deterministic component of the random utility function in the model is a cubic smoothing spline function. 
The method subsumes the conventional conditional logit model (**McFadden, 1973**) as a special case. 
In this paper, we present the model, describe the estimator, provide the computational algorithm of the model, and demonstrate the model by applying it to nonmarket valuation of recreation sites.

# Introduction 

A number of more #exible discrete choice methods within the random utility framework has been developed by applying nonparametric estimation techniques.
These variations can be divided into two groups. 

- The first group adopts distribution free estimation methods while keeping a parametric specifcation for the deterministic component of the random utility function. This method has been applied to :
    * binary choice, 
    * multiple choice, 
    * sequential choice, 
    * contingent ranking models
- The second group of estimation methods generalizes the discrete choice models by relaxing the parametric speci"cation assumptions of the deterministic component of RUM.

In general, the theory of nonparametric binary choice methods is studied more extensively. 
Although there are a few existing applications, little theory on nonparametric multiple choice methods has been explicitly addressed. 
In this paper, we examine a nonparametric multiple choice model that assumes a smooth nonparametric deterministic component of the utility function to allow more #exibility in describing the impact of a particular variable on utility.