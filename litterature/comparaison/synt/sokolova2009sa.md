# A systematic analysis of performance measures for classification tasks

## Authors

Marina Sokolova, Guy Lapalme

## Abstract 

This paper presents a systematic analysis of twenty four performance measures used in the complete spectrum of Machine Learning classification tasks, i.e., binary, multi-class, multi-labelled, and hierarchical. 
For each classification task, the study relates a set of changes in a confusion matrix to specific characteristics of data. 
Then the analysis concentrates on the type of changes to a confusion matrix that do not change a measure, therefore, preserve a classifier’s evaluation (measure invariance). 
The result is the measure invariance taxonomy with respect to all relevant label distribution changes in a classification problem.
This formal analysis is supported by examples of applications where invariance properties of measures lead to a more reliable evaluation of classifiers. 
Text classification supplements the discussion with several case studies.

## Keywords 

Performance evaluation, Machine Learning, Text classification

## Introduction

We take an alternative route looking how characteristics affect the objectivity of measures. 
Our formal discussion of ML performance measures complements popular statistical and empirical comparisons such as the ones presented in Goutte and Gaussier (2005). 
We show that, in some learning settings, the correct identification of positive examples may be important whereas in others, the correct identification of negative examples or disagreement between data and classifier labels may be more significant. 
Thus, standard performance measures should be re-evaluated with respect to those scenarios. 
Previously, ML studies of performance measures have primarily focused on binary classification. For a complete review, we add multi-class, multi-topic and hierarchical classification measures. 
The current study can be useful for measure design. 
So far, the ML community did not consider measures’ invariance when new ones were introduced (Bengio, Mariéthoz, & Keller, 2005; Huang & Ling, 2007) or suggested for adoption from other disciplines (Sokolova et al., 2006).

*Here we find multitopic classification measures*
*There are some interesting insights into invariance of the possible measures as well*