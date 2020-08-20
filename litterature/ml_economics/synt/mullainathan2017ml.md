# Abstract 

Machines are increasingly doing "intelligent" things: Facebook recognizes faces in photos, Siri understands voices, and Google translates websites.
The fundamental insight behind these breakthroughs is as much statistical as computational. 
Machine intelligence became possible once researchers stopped approaching intelligence tasks procedurally and began tackling them empirically. 
Face recognition algorithms, for example, do not consist of hard-wired rules to scan for certain pixel combinations, based on human understanding of what constitutes a face. 
Instead, these algorithms use a large dataset of photos labeled as having a face or not to estimate a function $f(x)$ that predicts the presence $y$ of a face from pixels $x$. 
This similarity to econometrics raises questions: 

- Are these algorithms merely applying standard techniques to novel and large datasets?
- If there are fundamentally new empirical tools, how do they fit with what we know?
- As empirical economists, how can we use them?

We present a way of thinking about machine learning that gives it its own place in the econometric toolbox. 
Central to our understanding is that machine learning

# General presentation

Machine learning (or rather “supervised” machine learning, the focus of this article) revolves around the problem of prediction: produce predictions of y from x. 
The appeal of machine learning is that it manages to uncover generalizable patterns. 
In fact, the success of machine learning at intelligence tasks is largely due to its ability to discover complex structure that was not specified in advance. 
It manages to fit complex and very flexible functional forms to the data without simply overfitting; it finds functions that work well out-of-sample.

Many economic applications, instead, revolve around parameter estimation: produce good estimates of parameters $\beta$ that underlie the relationship between $y$ and $x$. 
It is important to recognize that machine learning algorithms are not built for this purpose. 
For example, even when these algorithms produce regression coefficients, the estimates are rarely consistent.

*The algorithm's performance may differ based on application field*

# Function classes in ML [^1]

[^1]: See the original article for context. 
Most of the ML algorithms assume the structure that comprises class function $F$ and regularizer $R$. 

Function classes : 

1. Global/parametric predictors
    - Linear $\beta x$ (and generalizations)

2. Local/nonparametric predictors
    - Decision/regression trees 
    - Random forest (linear combination of trees)
    - Nearest neighbors 
    - Kernel regression

3. Mixed predictors
    - Deep learning, neural nets, convolutional neural networks
    - Splines

4. Combined predictors
    - Bagging: unweighted average of predictors from bootstrap draws
    - Boosting: linear combination of predictions of residual
    - Ensemble: weighted combination of different predictors

*The regularization functions are explicitly described in the article*

*To study more thoroughtly to follow the procedure*