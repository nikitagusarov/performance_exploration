# Abstract 

The topic of preferences has attracted considerable attention in Artificial Intelligence (AI) research in previous years. Recent special issues of the AI Magazine (December 2008) and the Artificial Intelligence Journal (announced for 2010), both devoted to preferences, highlight the increasing importance of this area for AI. 
Representing and processing knowledge in terms of preferences is appealing as it allows one to specify desires in a declarative way, to combine qualitative and quantitative modes of reasoning, and to deal with inconsistencies and exceptions in a quite flexible manner.

Roughly, preference learning refers to the problem of learning from observations which reveal, either explicitly or implicitly, information about the preferences of an individual (e.g., a user of a computer system) or a class of individuals; the acquisition of this kind of information can be supported by methods for preference mining. 
Generalizing beyond the training data given, the models learnt are typically used for *preference prediction*, i.e., to predict the preferences of a new individual or the same individual in a new situation.

Some chapters of the book are based on contributions selected from two successful workshops on preference learning that we organized as part of the ECML/PKDD conferences in 2008 and 2009.

The origination of this book is largely due to our close collaboration in recent years, which in turn has greatly benefited from a joint research project funded by the German Science Foundation (DFG).

# Introduction

A preference can be considered as a relaxed constraint which, if necessary, can be violated to some degree. 
In fact, an important advantage of a preference-based problem solving paradigm is an increased flexibility.

Roughly speaking, preference learning is about inducing predictive preference models from empirical data. 
In the literature on choice and decision theory, two main approaches to modeling preferences can be found, namely in terms of utility functions and in terms of preference relations. 
From a **machine learning point of view**, these two approaches give rise to two kinds of learning problems: *learning utility functions* and *learning preference relations*. 
The latter deviates more strongly than the former from conventional problems such as classification and regression, as it involves the prediction of complex structures, such as rankings or partial order relations, rather than single values. 
Moreover, training input in preference learning will not, as it is usually the case in supervised learning, be offered in the form of complete examples but may comprise more general types of information, such as relative preferences or different kinds of indirect feedback and implicit preference information.

In general, a preference learning task consists of some set of items for which preferences are known, and the task is to learn a function that predicts preferences for a new set of items, or for the same set of items in a different context. 
Frequently, the predicted preference relation is required to form a total order, in which case we also speak of a ranking problem.

## Multivariate Ordinal Regression (MOR)

There are many settings where it is natural to rate instances according to an ordinal scale, including collaborative filtering, where there is the need to predict people ratings on unseen items. 
Borrowing the movie-related application introduced above, suitable rates for movies could be given as “bad”, “fair”, “good”, and “recommended”.

## Multilabel Classification (MLC)

In this task, it is required to classify instances with a subset (the cardinality of which is not specified) of the available classes. 
For us, it is convenient to consider this task as an MOR problem, where only two ranks are available, relevant and irrelevant.