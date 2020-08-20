# Classifier variability: Accounting for training and testing

## Authors

Weijie Chen, Brandon D. Gallas, Waleed A. Yousef

## Abstract

We categorize the statistical assessment of classifiers into three levels: assessing the classification performance and its testing variability conditional on a fixed training set, assessing the performance and its variability that accounts for both training and testing, and assessing the performance averaging over training sets and its variability that accounts for both training and testing. 
We derived analytical expressions for the variance of the estimated AUC and provide freely available software implemented
with an efficient computation algorithm. 
Our approach can be applied to assess any classifier that has ordinal (continuous or discrete) outputs. 
Applications to simulated and real datasets are presented to illustrate our methods.

## Keywords

Classifier evaluation, Training variability, Classifier stability, U-statistics, AUC

## Introduction

This paper concerns the statistical assessment of supervised learning classifiers in binary classification tasks. 
The assessment uses a training dataset and a test dataset to estimate the classification performance (in terms of some metric, e.g., area under the receiver operating characteristic (ROC) curve, or AUC) and its variability. 
A point estimate of the classifier performance with a finite sample is meaningless unless it is accompanied with its uncertainty. 
Variability estimation is important to make statistical inference of the classification performance on the population from which the finite datasets are drawn. 
The traditional approaches to assess the uncertainty of the estimated AUC only account for the variability in sampling a test set.
However, a finite training set is also a random sample from the population of training sets, and the AUC varies with the training set. 
Training variability is a characterization of classifier stability with respect to varying training sets. 
The main theme of this paper is to investigate a nonparametric approach to quantify the classifier performance variability that accounts for both the randomness of the finite training set and that of the test set.

The traditional approach to the assessment of pattern classifiers is to use a test set to estimate the standard deviation of the classifier performance and ignore the variability caused by the random choice of the finite training set. 
This might be acceptable for some particular classifiers and particular feature distributions, for example, theoretical analyses of Bayes classifiers on Gaussian distributions by Fukunaga et al. show that the variance comes predominantly from the finite test set. However, Beiden et al. showed that training variability should be taken into account in general and particularly when comparing competing classifiers.
Ignoring training variability assumes that the training set is ‘‘frozen’’ and therefore training is treated as a fixed, rather than random, effect.

Training variability is a characterization of the stability of the estimated classifier performance with respect to varying training sets. 
Such classifier stability has been a major concern in applications that involve a large number of features and a relatively small number of training samples. 
In multiple biomarker applications such as gene-expression microarray studies, classifiers are typically developed with a few of hundreds of patient samples on tens of thousands of gene-expression measurements. 
Stability/fragility questions often arise in data-oriented pattern classifier findings.
