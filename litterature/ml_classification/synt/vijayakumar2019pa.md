# Abstract

Machine learning methods have become very popular in diverse fields due to their focus on predictive accuracy, but little work has been conducted on how to assess the replicability of their findings. 
We introduce and adapt replication methods advocated in psychology to the aims and procedural needs of machine learning research. 
In Study 1, we illustrate these methods with the use of an empirical data set, assessing the replication success of a predictive accuracy measure, namely, $R^2$ on the cross-validated and test sets of the samples. 

We introduce three replication aims :

First, tests of inconsistency examine whether single replications have successfully rejected the original study. 
Rejection will be supported if the 95% confidence interval (CI) of $R^2$ difference estimates between replication and original does not contain zero. 

Second, tests of consistency help support claims of successful replication. 
We can decide apriori on a region of equivalence, where population values of the difference estimates are considered equivalent for substantive reasons. 
The 90% CI of a different estimate lying fully within this region supports replication. 

Third, we show how to combine replications to construct meta-analytic intervals for better precision of predictive accuracy measures.
In Study 2, $R^2$ is reduced from the original in a subset of replication studies to examine the ability of the replication procedures to distinguish true replications from nonreplications. 

We find that when combining studies sampled from same population to form meta-analytic intervals, random-effects methods perform best for cross-validated measures while fixed-effects methods work best for test measures. 
Among machine learning methods, regression was comparable to many complex methods, while support vector machine performed most reliably across a variety of scenarios.
Social scientists who use machine learning to model empirical data can use these methods to enhance the reliability of their findings.