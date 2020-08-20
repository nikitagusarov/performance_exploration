# Abstract 

This paper provides an assessment of the early contributions of machine learning to economics, as well as predictions about its future contributions. 
It begins by briefly overviewing some themes from the literature on machine learning, and then draws some contrasts with traditional approaches to estimating the impact of counterfactual policies in economics. 
Next, we review some of the initial "off-the-shelf" applications of machine learning to economics, including applications in analyzing text and images. 
We then describe new types of questions that have been posed surrounding the application of machine learning to policy problems, including "prediction policy problems" as well as considerations of fairness and manipulability. 
We present some highlights from the emerging econometric literature combining machine learning and causal inference. 
Finally, we overview a set of broader predictions about the future impact of machine learning on economics, including its impacts on the nature of collaboration, funding, research tools, and research questions.

# ML presentation

Starting from a relatively narrow denition of machine learning, machine learning is a field that develops algorithms designed to be applied to datasets, with the main areas of focus being :

1. *Supervised ML* typically entails using a set of features or covariates $X$ to predict an outcome $Y$ (such as regularized regression (LASSO, ridge and elastic net), random forest, regression trees, support vector machines, neural nets, matrix factorization, and many others, such as model averaging) [^1] :
    - prediction (regression), 
    - classication.

[^1]: See Varian (2014) for an overview of some of the most popular methods, and Mullainathan and Spiess (2017) for more details.

2. *Unsupervised ML* (k-means clustering, topic modeling, community detection
methods for networks, and many more), these tools are very useful as an intermediate step in empirical work in economics :
    - clustering or grouping tasks

# Econometrics presentation

In contrast, in much of cross-sectional econometrics and empirical work in economics, the tradition has been that the researcher species one model, estimates the model on the full dataset, and relies on statistical theory to estimate condence intervals for estimated parameters. 
The focus is on the estimated effects rather than the goodness of t of the model (the primary interest is in the estimate of a causal effect).

Economists also build more complex models that incorporate both behavioral and statistical assumptions in order to estimate the impact of counterfactual policies that have never been used before. 
A classic example is McFadden's methodological work in the early 1970s (e.g. McFadden et al. (1973)) analyzing transportation choices. By imposing the behavioral assumption that consumers maximize utility when making choices, it is possible to estimate parameters of the consumer's utility function, and estimate the welfare effects and market share changes that would occur when a choice is added or removed (e.g. extending the BART transportation system), or when the characteristics of the good (e.g. price) are changed.

*Basic article for understanding eventual differences between econometrics and ML aproaches*