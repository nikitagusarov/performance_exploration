# An evaluation study on text categorization using automatically generate d lab ele d dataset

## Authors

Dengya Zhu, Kok Wai Wong

## Abstract

Naïve Bayes, k-nearest neighbors, Adaboost, support vector machines and neural networks are five among others commonly used text classifiers. 
Evaluation of these classifiers involves a variety of factors to be considered including benchmark used, feature selections, parameter settings of algorithms, and the measurement criteria employed. 
Researchers have demonstrated that some algorithms outperform others on some corpus, however, inconsistency of human labeling and high dimensionality of feature spaces are two issues to be addressed in text categorization. 
This paper focuses on evaluating the five commonly used text classifiers by using an automatically generated text document collection which is labeled by a group of experts to alleviate subjectivity of human category assignments, and at the same time to examine the influence of the number of features on the performance of the algorithms.

## Keywords:

Text mining, Text categorization, Machine learning, Evaluation, Feature selection, Benchmark collection

## Introduction

Text cate-
gorization is a kind of supervized learning and has been widely applied in the areas such as language identification, information retrieval, opinion mining, spam filtering, and email routing [2]. 
With the recent explosion of information on the Web, text categorization is becoming increasingly important as an approach to managing and organizing the huge volume of information on the Web.
Many algorithms such as Boostexter [3] and support vector machines (SVMs) [4] have been developed and introduced for this purpose. 
Consequently, the evaluation of the effectiveness of the algorithms is playing an important role for both researchers and practitioners.

To evaluate a text categorization algorithm, the first element to be considered is the training document collection to be used.
Many such document collections have been developed for evaluation purposes. 
The widely used benchmark collections for text categorization include Reuters-21,578 [5], Reuters Corpus Volume I (RCV1) [1], UC Irvine (UCI) [machine learning repository](http://archive.ics.uci.edu/ml), and OHSUMED [6].