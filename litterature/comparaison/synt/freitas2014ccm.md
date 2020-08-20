# Comprehensible Classification Models – a position paper

## Authors

Alex A. Freitas

## Abstract

The vast majority of the literature evaluates the performance of classification models using only the criterion of predictive
accuracy. 
This paper reviews the case for considering also the comprehensibility (interpretability) of classification models, and discusses the interpretability of five types of classification models, namely decision trees, classification rules, decision tables, nearest neighbors and Bayesian network classifiers. 
We discuss both interpretability issues which are specific to each of those model types and more generic interpretability issues, namely the drawbacks of using model size as the only criterion to evaluate the comprehensibility of a model, and the use of monotonicity constraints to improve the comprehensibility and acceptance of classification models by users.

## Keywords

Decision tree, rule induction, decision table, nearest neighbors, Bayesian network classifiers, monotonicity constraint.

## Introduction

The vast majority of works on classification model evaluation use predictive accuracy as the only evaluation criterion. 
However, in real-world applications where the goal is to produce a classification model that is useful to the user, the
comprehensibility (interpretability) of the model to the user is also important. 
Model interpretability was stressed in early machine learning research; but in the last two decades, popular classification methods like ensembles [60], support vector machines (SVM) and kernel-based learning methods [13] have been designed to maximize predictive accuracy only. 
Indeed, the models produced by SVMs are in general black box models that can be hardly interpreted by users; whilst an ensemble of models tends to be harder to be interpreted by users, by comparison with a single classification model [23], [26], [69].

Despite the dominance of predictive accuracy as the evaluation criterion, there has been significant progress in methods proposed for improving the comprehensibility of classification models [6], [21], [47], [49], [53], [55], [70]. 
In addition, the importance of comprehensible classification models continues to be emphasized in many application domains, like medicine [5], [46], [55], [59], [76]; credit scoring [4], [35]; churn prediction [47], [70]; and bioinformatics [26], [67]. 
However, most of these works focus on improving the comprehensibility of just one type of classification model representation (e.g. decision trees or classification rules).

## Comprehensive modelling

The importance of comprehensible classification models stems from several issues. 
First, understanding a computer-induced model is often a prerequisite for users to trust the model’s predictions and follow the recommendations associated with those predictions. 
The need for trusting computational predictions tends to be particularly strong in medical applications [19], [39], [46], [59], [69], where lives are at stake. 
Model comprehensibility is also important for the model’s acceptance by users in financial applications [15] and in customer churn prediction applications [70]. 
In bioinformatics, understanding a model’s predictions often helps biologists to trust the predictions [16], [26], [67], increasing the chances that users will invest a lot of time and money in the execution of sophisticated biological experiments to try to confirm the model’s predictions. 
Arguably, the ultimate value of a model’s predictions for bioinformatics is determined by the cumulative success of the experiments inspired by those predictions [37].

*There are some interesting points on interpretability of different models, among which :* 

- *Decision trees*
- *Classification rules*
- *Decision tables*
- *Nearest Neighbors*
- *Bayesian Network Classifiers*

## Generic Issues

In the vast majority of papers where the comprehensibility of a classification model is evaluated, that evaluation is done in an over-simplistic way, by measuring only the size of the model – e.g. the number of nodes in a decision tree, or the number of edges in a Bayesian network classifier. 
The assumption is that the smaller the model is, the more comprehensible it would be to the user. 
However, there are several problems with that assumption.

*To complete*