# Abstract

The current paper proposes the use of the multivariate skew-normal distribution function to accommodate non-normal mixing in cross-sectional and panel multinomial probit (MNP) models. 
The combination of skew-normal mixing and the MNP kernel lends itself nicely to estimation using Bhat’s (2011) maximum approximate composite marginal likelihood (MACML) approach. 
Simulation results for the cross-sectional case show that our proposed approach does well in recovering the underlying parameters, and also highlights the pitfalls of ignoring non-normality of the continuous mixing distribution when such non-normality is present. 
At the same time, the proposed model obviates the need to assume a pre-specified parametric distribution for the mixing, and allows the estimation of a very flexible, but still parsimonious, mixing distribution form.

# Introduction 

Econometric discrete choice analysis is an essential component of studying individual choice behavior and is used in many diverse fields to model consumer demand for commodities and services.

The decision principle used in almost all discrete choice models corresponds to utility maximization, which is based on the **Lancaster (1971)** notion of the assignment of a composite utility to each alternative in the choice set (based on alternative and individual attributes) followed by the choice of the alternative with the highest utility. 
Further, since the analyst does not observe all individual and context-related factors that contribute to choice decisions, one or more stochastic elements (or random error terms) are introduced in the utility of alternatives. 

Different ways of introducing the stochastic elements lead to different discrete choice model structures. 
Thus, consider a cross-sectional choice situation with a single choice occasion per individual, and assume independence among the choice behaviors of individuals. 
Then, the simplest model form, corresponding to the multinomial logit (MNL) model introduced by **Luce and Suppes (1965)** and **McFadden (1974)**, assumes a single composite *independently and identically distributed or IID* (across alternatives) random utility error term with a Gumbel (or Type I extreme-value) distribution.
This leads to the simple and elegant MNL model form, but also leaves the model form saddled with the familiar *independence from irrelevant alternatives* (IIAs) property. 

Maintaining a single composite Gumbel error term in utilities, while relaxing the independence assumption (across alternatives), moves the model form from the multinomial logit to the *generalized extreme value* (GEV) class of models proposed by **McFadden (1978)**.

On the other hand, relaxing the identically distributed assumption (across alternatives) with the Gumbel distribution assumption leads to the *Heteroscedastic Extreme Value* (HEV) model form proposed by **Bhat (1995)**. 

Finally, still maintaining a single composite error term but now with a *normal distribution*, when combined with relaxation of the independence and/or identical distribution assumptions, generates the *multinomial probit* (MNP) model form originally proposed by **Hausman and Wise (1978)** and **Daganzo (1979)**. 

Of these model forms, the MNP form allows *the most flexible error covariance structures* (up to certain limits of identifiability **Train, 2009**, Chapter 5), though it also entails more estimation effort since it requires the evaluation of a multidimensional normal orthant probability function with an ($I - 1$) dimensional integral in the general case (where $I$ is the number of alternatives).