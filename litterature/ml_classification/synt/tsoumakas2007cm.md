# Abstract

Nowadays, multi-label classification methods are increasingly required by modern applications, such as protein function classification, music categorization and semantic scene classification. 
This paper introduces the task of multi-label classification, organizes the sparse related literature into a structured presentation and performs comparative experimental results of certain multi-label classification methods. 
It also contributes the definition of concepts for the quantification of the multi-label nature of a data set.

# Tasks that are related to multi-label classification

1. *ranking* - In ranking the task is to order a set of labels L, so that the topmost labels are more related with the new instance.
2. *multiple-label problems* - The semi-supervised classification problems where each example is associated with more than one classes, but only one of those classes is the true class of the example.
3. *multiple-instance learning* - It is a variation of supervised learning, where the task is to learn a concept given positive and negative bags of instances.

# Existing methods for multi-label classification

1. *problem transformation methods* - methods that transform the multi-label classification problem either into one or more single-label classification or regression problems, for both of which there exists a huge bibliography of learning algorithms (Boutell et al., 2004) :
    - subjectively or randomly selects one of the multiple labels of each multi-label instance and discards the rest
    - discards every multi-label instance from the multi-label data set
    - considers each different set of labels that exist in the multi-label data set as a single label (PT4)
    - the same solution used in order to deal with a single-label multi-class problem using a binary classifier
    - learns one single-label coverage-based classifier from the transformed data set (distribution classifiers are those classifiers that can output a distribution of certainty degrees/probabilities for all labels)

2. *algorithm adaptation methods* - methods that extend specific learning algorithms in order to handle multi-label data directly.
    - Clare and King (2001) adapted the C4.5 algorithm for multi-label data.
    - Adaboost.MH and Adaboost.MR (Schapire & Singer, 2000) are two extensions of AdaBoost (Freund & Schapire, 1997) for multi-label classification.
    - ML-kNN (Zhang & Zhou, 2005) is an adaptation of the kNN lazy learning algorithm for multi-label data.
    - Luo and Zincir-Heywood (2005) present two systems for multi-label document classification, which are also based on the kNN classifier.
    - McCallum (1999) defines a probabilistic generative model according to which, each label generates different words.
    - Elisseeff and Weston (2002) present a ranking algorithm for multi-label classification, their algorithm follows the philosophy of SVMs.
    - Godbole and Sarawagi (2004) present two improvements for the Support Vector Machine (SVM) classifier in conjunction with the PT4 method for multi-label classification.
    - MMAC (Thabtah, Cowling & Peng, 2004) is an algorithm that follows the paradigm of associative classification, which deals with the construction of classification rule sets using association rule mining.

# Issues

1. Not all data sets are equally multi-label.
2. Multi-label classification requires different metrics than those used in traditional single-label classification.

*Study the article for different metrics used, accuracy and model comparison*