# Evaluation Criteria Based on Mutual Information for Classifications Including Rejected Class

## Authors

HU Bao-Gang, WANG Yong

## Abstract

Different from the conventional evaluation criteria using performance measures, information theory based criteria present a unique beneficial feature in applications of machine learning. 
However, we are still far from possessing an in-depth understanding of the “entropy” type criteria, say, in relation to the conventional performance-based criteria. 
This paper studies generic classification problems, which include a rejected, or unknown, class. 
We present the basic formulas and schematic diagram of classification learning based on information theory. 
A closed-form equation is derived between the normalized mutual information and the augmented confusion matrix for the generic classification problems. 
Three theorems and one set of sensitivity equations are given for studying the relations between mutual information and conventional performance indices. 
We also present numerical examples and several discussions related to advantages and limitations of mutual information criteria in comparison with the conventional criteria.

## Key words 

Entropy, *mutual information*, evaluation criteria, classification, confusion matrix, machine learning.

## Introduction

It is understandable that evaluation criteria (sometimes equivalent to learning targets) comprise the first task in studies on machine learning. 
This task will be simplified if some criteria are specified with the application requirements. 
However, from the theoretical point of view, selections of evaluation criteria are nevertheless an open problem in machine learning. 
For better understanding of the problem, we roughly categorize evaluation criteria into several groups. 
Within a type of performance-based criteria, taking classification problems for examples, one can further divide them as partial performance criterion like “true positive accuracy”, or overall performance one like ROC (Receiver operating characteristic) curves. 
This type of performance-based criteria can still be grouped as direct measure criteria or indirect measure ones. 
The direct measure criteria include classification error, ROC curve, or computational cost. 
The indirect measure criteria can be found as mutual information, class separation margins, or error bounds. 
Up to now, most selections of learning criteria are made based on users 0 experiences or preferences.
Therefore, a systematic study seems to be necessary in order to explore the subject, including the following two basic
issues:

1. One of the principal tasks in machine learning is to process data. 
Can we apply “entropy” or information-based criteria as a generic measure for dealing with uncertainty of data in machine learning?

2. What are the relations between information-based criteria (say, mutual information) and the conventional performance criteria say, classification accuracy)? 
What are the advantages and limitations in using information-based criteria?

*An interesting article with numeric examples for confusion matrix concept uderstanding*