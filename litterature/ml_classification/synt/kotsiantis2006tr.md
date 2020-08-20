# Abstract 

Supervised classification is one of the tasks most frequently carried out by socalled Intelligent Systems. 
Thus, a large number of techniques have been developed based on Artificial Intelligence (Logic-based techniques, Perceptron-based techniques) and Statistics (Bayesian Networks, Instance-based techniques). 
The goal of supervised learning is to build a concise model of the distribution of class labels in terms of predictor features. 
The resulting classifier is then used to assign class labels to the testing instances where the values of the predictor features are known, but the value of the class label is unknown. 
This paper describes various classification algorithms and the recent attempt for improving classification accuracy — ensembles of classifiers.

# General algorithm families

Every instance in any dataset used by machine learning algorithms is represented using the same set of features. 
The features may be continuous, categorical or binary (Jain et al. 1999).

- *supervised learning* - if instances are given with known labels (the corresponding correct outputs) :
    * Logic-based learning techniques,
        - Decision trees are trees that classify instances by sorting them based on feature values.
    * Statistical techniques forML,
    * Support Vector Machines (SVMs).

- *unsupervised learning* - where instances are unlabeled.

The work is concerned with classification problems in which the output of instances admits only discrete, unordered values.

# Supervised learning

- *Logic-based learning techniques* :
    * *Decision trees* (Murthy 1998) are trees that classify instances by sorting them based on feature values.
    * *Set of rules* - Decision trees can be translated into a set of rules by creating a separate rule for each path from the root to a leaf in the tree (Quinlan 1993). 
    However, rules can also be directly induced from training data using a variety of rule-based algorithms. 
    Furnkranz (1999) provided an excellent overview of existing work in rule-basedmethods.
    * *Inductive logic programming* (ILP) classifiers use framework of first order predicate logic.

- *Statistical techniques for ML* (*Perceptron-based techniques*) :
    * *Neural networks*
    * *Naive Bayesian networks*
    * *Instance-based learning algorithms* are lazy-learning algorithms (Mitchell 1997), as they delay the induction or generalization process until classification is performed (ex: kNN).

- *Support Vector Machines* (SVMs).

# Eventual problems

The choice of which specific learning algorithmwe should use is a critical step.
The classifier’s evaluation is most often based on prediction accuracy (the percentage of correct prediction divided by the total number of predictions). 
There are at least three techniques which are used to calculate a classifier’s accuracy.

*Inconsistent classification - SVMs are separated from the rest of methods*