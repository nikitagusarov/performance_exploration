# Abstract

Computers are now involved in many economic transactions and can capture data associated with these transactions, which can then be manipulated and analyzed. 
Conventional statistical and econometric techniques such as regression often work well, but there are issues unique to big datasets that may require different tools.

First, the sheer size of the data involved may require more powerful data manipulation tools. 
Second, we may have more potential predictors than appropriate for estimation, so we need to do some kind of variable selection. 
Third, large datasets may allow for more flfl exible relationships than simple linear models.
Machine learning techniques such as decision trees, support vector machines, neural nets, deep learning, and so on may allow for more effective ways to model complex relationships.

In this essay, I will describe a few of these tools for manipulating and analyzing big data. 
I believe that these methods have a lot to offer and should be more widely known and used by economists. 
In fact, my standard advice to graduate students these days is go to the computer science department and take a class in machine learning. 
There have been very fruitful collaborations between computer scientists and statisticians in the last decade or so, and I expect collaborations between computer scientists and econometricians will also be productive in the future.

# Introduction

Much of applied econometrics is concerned with detecting and summarizing relationships in the data. 
The most common tool used for summarization is (linear) regression analysis. 
As we shall see, machine learning offers a set of tools that can usefully summarize various sorts of nonlinear relationships in the data.
The article focuses on the regression-like tools because they are the most natural for economic applications.

The focus of machine learning is to find some function that provides a good prediction of y as a function of $x$. 
Historically, most work in machine learning has involved cross-section data where it is natural to think of the data being independent and identically distributed (IID) or at least independently distributed.

The review these include nonlinear methods such as [^1] :

[^1]: More detail about these methods can be found in machine learning texts; an excellent treatment is available in Hastie, Tibshirani, and Friedman (2009)

1. *classification and regression trees* (CART); 
2. *random forests* ;
3. *penalized regression*, such as :
    - LASSO, 
    - LARS, 
    - elastic nets.

    *The metohds are further explained and studied in the paper*