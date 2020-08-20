# Abstract

This paper considers the recently introduced family of reference models dedicated to non- ordered alternatives. 
The link function of reference models is that of the multinomial logit model (MNL) replacing the logistic cumulative distribution function (cdf) by other cdfs (e.g., Gumbel, Student). 
We determine all usual economic outputs (willingness-to-pay, elasticities,...). 
We also show that the IIA property generally does not hold for this family of models, because of their noninvariance to the alternative chosen as a reference. 
We estimate and compare five reference models to the MNL on a travel mode-choice survey: according to the chosen cdf, reference models lead to a better fit and retrieve consistent economic outputs estimations even when there is a high unobserved heterogeneity.

# Classification

Discrete choice models (DCMs) are a valuable tool for both understanding how choices are made and deriving behavioral outputs for economic analysis and valuation. 

Some DCMs are derived from the **random utility maximization (RUM)** principle such as the family of **generalized extreme value (GEV)** models introduced by McFadden (1978), which includes the MNL. 
However, the **family of DCMs** is principally composed of **generalized linear models (GLMs)** for discrete response variable, also including the MNL. 
Discrete response variables can be differentiated into **count and qualitative responses**.

On the one hand, Poisson regression models are classically used for **count data** ( Cameron and Trivedi, 1986 ). 

Different models are used for **qualitative choices** according to the ordering assumption among the alternatives. 

Regression models appropriate for **ordered alternatives** include the **cumulative** ( McCullagh, 1980 ), **sequential** ( Tutz, 1991 ) and **adjacent** ( Goodman, 1983 ) logit model. 
For these *three kinds of ordered logit models* some extensions have been introduced using a **cumulative distribution function (cdf) other than the logistic one** ( Amemiya, 1981; Fullerton, 2009 ). 

The best known of them is the **ordered probit model**, which is an extension of the cumulative logit model, defined with the normal cdf ( McKelvey and Zavoina, 1975 ). 

In the case of non-ordered alternatives, such extensions have only recently been proposed for the MNL leading to the **family of reference models** ( Peyhardi et al. ). 
It should be noted that the **multinomial probit model** is not such an extension, despite its name. 
It is defined as a **RUM model with multivariate Gaussian residual distribution** whereas *the cumulative, sequential and adjacent models do not strictly satisfy the RUM principle* ( Small, 1987 ) and **are viewed as GLMs**. 
Otherwise, *reference models take advantage of the GLM framework*. 
In the **GLM framework**, the link function relates the probabilities of alternatives to the linear predictors (depending on individual and alternative-specific variables). 
*The link function of reference models is the multinomial logit link function, except that the logistic cdf is replaced by other cdfs* $F$, such as the normal, the Gompertz or the Student cdfs. 