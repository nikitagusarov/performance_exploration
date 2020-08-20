# Inroduction

Many applications of multinomial logit models relate to determining effects of explanatory variables on a subject's choice from a discrete set of options-for instance, transportation system to take to work (driving alone, carpooling, bus, subway, walk, bicycle), housing (buy house, buy condominium, rent), primary shopping location (downtown, mall, catalogs, Internet), or product brand. 
Models for response variables consisting of a discrete set of choices are called discrete-choice models. 

In many discrete-choice applications, an explanatory variable takes different values for different response choices. 
As predictors of choice of transportation system, the cost and the time to reach the destination take different values for each option. 
As a predictor of choice of product brand, the price varies according to the option. 
Explanatory variables of this type are characteristics of the choices. 
They differ from the usual ones, for which values remain constant across the choice set. 
Such variables, characteristics of the chooser, include demographic characteristics such as gender, race, and educational attainment.

# Generalized Linear Models (GLM)

GLMs provide a unified theory of modeling that encompasses the most important models
for continuous and discrete variables.

Generalized linear models (GLMs) extend ordinary regression models to encompass nonnormal response distributions and modeling functions of the mean. 
They have three components: A random component identifies the response variable $Y$ and its probability distribution; a systematic component specifies explanatory variables used in a linear predictor function; and a link function specifies the function of $E(Y)$ that the model equates to the linear predictor. 
**Nelder and Wedderburn (1972)** introduced the class of GLMs, although the most important models in the class were established before then.

The class of OLMs also includes models for continuous responses. 
The normal distribution is in a natural exponential family that includes dispersion parameters. 
Its natural parameter is the mean. 
Therefore, an ordinary regression model is a OLM using the identity link.

A traditional way to model data transforms $Y$ so that it has approximately a normal distribution with constant variance; then, ordinary least-squares regression is applicable. 
With GLMs, by contrast, the choice of link function is separate from the choice of random component. 
If a link is useful in the sense that a linear model for the predictors is plausible for that link, it is not necessary that it also stabilizes variance or produces normality. 
This is because the fitting process maximizes the likelihood for the choice of distribution for $Y$, and that choice is not restricted to normality.

GLMs extend ordinary regression by *allowing non-normal responses* and a *link function of the mean*. 

## GLMs for *binary* data

For a binary response variable, the regression model (*linear probability model*) :

$$\pi (x) = \alpha + \beta_1 x_1 + \dots + \beta_p x_p = \alpha + \beta x$$

This model has a major structural defect: Probabilities fall between 0 and 1, but linear
functions take values over the entire real line.

In practice, nonlinear relationships between $\pi (x)$ and $x$ are often monotonic, with $\pi (x)$ increasing continuously or $\pi (x)$ decreasing continuously as x increases. 
The S-shaped curves are typical.

### *Logistic Regression Model*

$$\pi (x) = \frac{e^{\alpha + \beta x}}{1 + e^{\alpha + \beta x}}$$

$$\frac{\pi (x)}{1 - \pi (x)} = e^{\alpha + \beta x}$$

$$log \frac{\pi (x)}{1 - \pi (x)} = \alpha + \beta x$$

#### *Conditional Logistic Regression*

ML estimators of logistic regression model parameters perform well when the sample size $n$ is large compared with the number of parameters. 
When $n$ is small or when the number of parameters grows as $n$ does, improved inference results using conditional maximum likelihood.

The conditional likelihood approach eliminates nuisance parameters by conditioning on their sufficient statistics. 
The conditional likelihood refers to a distribution defined for potential samples that provide the same information about the nuisance parameters that occurs in the observed sample.

### *Probit Regression Model* and others cdfs

Using a class of location-scale cdf's, such as normal cdf's with their variety of means and variances, permits the curve $\pi (x) = F (x)$ to have flexibility in the rate of increase and in the location where most of that increase occurs.

$$\pi (x) = \Phi (\alpha + \beta x)$$

For this class of cdf shapes, the link function for the GLM is $\Phi^{-1}$ The link function maps
the $(0, 1)$ range of probabilities onto $(- \inf, \inf)$, the range of linear predictors.

$$\Phi^{-1} (\pi (x)) = \alpha + \beta x$$

A danger with improper prior distributions is that posterior distributions can also be improper for some models (**Natarajan and McCulloch 1995**). 
A *Markov chain Monte Carlo* (MCMC) algorithm for approximating the posterior distribution may fail to recognize that the posterior distribution is improper. 
Thus, it is safer to use a proper but relatively diffuse prior if you prefer the prior distribution to be flat relative to the likelihood function.

## GLMs for *counts and rates* 

The best known GLMs for count data assume a Poisson distribution for $Y$.

### Poisson Log-linear Model

The Poisson distribution has a positive mean $\mu$. 
Although a OLM can model a positive mean using the identity link. 
It is more common to model the log of the mean. 
Like the linear predictor, the log mean can take any real value. 
The log mean is the natural parameter for the Poisson distribution, and the log link is the canonical link for a Poisson GLM.

The Poisson loglinear model with explanatory variables $x$ is :

$$log \mu (x) = \alpha + \beta x$$

$$\mu (x) = e^{\alpha + \beta x}$$

A common use is modeling for contingency tables. 
The models specify the joint distribution among the categorical variables that are cross-classified to form the table. 
They are used to analyze association and interaction patterns among those variables. 
The models specify how the expected cell counts depend on levels of the categorical variables for that cell as well as associations and interactions among those variables.

Loglinear models are of use primarily when at least two variables are response variables. 
With a single categorical response. 
It is simpler and more natural to use logistic regression models. 
When one variable is treated as a response and the others as explanatory variables, logistic models for that response variable are equivalent to certain loglinear models.

Many loglinear models can be portrayed with a graph that represents the conditional independence structure among the responses. 
This representation also helps to reveal implications of models, such as when an association is unchanged when we collapse a table over another variable.

### Negative Binomial GLMs

The *negative binomial distribution* ...

### Poisson Regression for Rates Using Offsets

Often a response count $Y_i$ has an index $t$; such that its expected value is proportional to $t_i$.
For instance, this index could be an amount of time or a spatial area over which the count is made.

A loglinear model for the expected rate has form 

$$log (\mu_i / t_i) = log \mu_i - log \t_i = \alpha + \beta x_i$$

$$\mu_i = \t_i e^{\alpha + \beta x_i}$$

## GLMs for *nominal* data

For a *nominal-scale response variable* $Y$ with $J$ categories, multicategory (also called polytomous). 
Models simultaneously describe the log odds for all pairs of categories. 
Given a certain choice of $J - 1$ of these, the rest are redundant.

For a univariate response variable in the natural exponential family, a GLM has form $g(\mu_i) = \beta x_i$ for a link function $g(.)$, expected response $\mu_i = E(Y_i)$, vector of values $x_i$ of $p$ explanatory variables for observation $i$, and parameter vector $\beta$. 
This extends to a *multivariate generalized linear model* for distributions in the multivariate exponential family, such as the multinomial.

The multivariate GLM has the form

$$g(\mu_i) = \beta X_i$$

### *Multinomial Logit Models (Baseline-Category Logits)*

Let $\pi_j (x) = P(Y = j \mid x)$ at a fixed setting $x$ for explanatory variables, with $\sum_j \pi_j (x) = 1$.
For observations at that setting, we treat the counts at the $J$ categories of $Y$ as a multinomial variate with probabilities $\{ \pi_1 (x), \dots , \pi_1 (x) \}. 
Logistic models pair each response category with a baseline category, such as the last one or the most common one.

$$log \frac{ \pi_j (x)}{ \pi_J (x)} = \alpha_j + \beta_j x, \text{    } j = 1, \dots, J-1$$

This model simultaneously describes the effects of $x$ on these $J - 1$ logits. 
The effects vary according to the response paired with the baseline.

$$log \frac{ \pi_a (x)}{ \pi_b (x)} = log \frac{ \pi_a (x)}{ \pi_J (x)} - log \frac{ \pi_b (x)}{ \pi_J (x)}$$

The equation that expresses multinomial logistic models directly in terms of response probabilities $\{\pi_j (x)\}$ is

$$\pi_j (x) = \frac{e^{\alpha_j + \beta_j x}}{1 + \sum_{h = 1}^{J - 1} e^{\alpha_h + \beta_h x}}$$

### *Multinomial Probit Models*

The multinomial logit model with baseline-category logits results from a latent utility representation that generalizes the *Logit* model.
**Aitchison and Bennett (1970)** suggested a similar approach for *Probit* model, for independent standard normal variates.
The corresponding model, called the *multinomial probit model*, gives a similar fit.

Fitting the multinomial probit model is computationally more complex than the corresponding logit model.

## GLMs for *ordinal* data

Models with terms that reflect ordinal characteristics such as monotone trend have improved model parsimony and power.

Let $G^{-1}$ denote a link function that is the inverse of the continuous cdf $G$. 
The cumulative link model

$$G^{-1} [P(Y \leq j \mid x)] = \alpha_j + \beta x$$

**McCullagh (1980)** and **Thompson and Baker (1981)** treated cumulative link models as multivariate GLMs. 
McCullagh presented a Fisher scoring algorithm for ML estimation. 
He showed that sufficiently large n guarantees a unique maximum of the likelihood. 
**Burridge (1981)** and **Pratt (1981)** showed that the log likelihood is concave for many cumulative link models, including the *logit*, *probit*, and *complementary log-log*.

### Cumulative Logit

We utilize the category ordering by forming logits of cumulative probabilities

$$P(Y \leq j \mid x) = \pi_1 (x) + \dots + \pi_j (x), \text{    } j = 1, \dots , J$$

The cumulative logits are defined as

$$logit [P(Y \leq j \mid x)] = log \frac{P(Y \leq j \mid x)}{1 - P(Y \leq j \mid x)}$$ 

$$log \frac{\pi_1 (x) + \dots + \pi_j (x)}{\pi_{j + 1} (x) + \dots + \pi_J (x)}, \text{    } j = 1, \dots , J - 1$$ 

### Cumulative Probit

The *cumulative probit model* is the cumulative link model using the standard normal cdf $\Phi$ for $G$. 
This *generalizes the binary probit model* to ordinal responses.
It is appropriate when the conditional distribution for the latent variable $Y^*$ is normal.
Parameters in probit models refer to effects on $E(Y^*)$.

Cumulative probit models provide fits similar to cumulative logit models. 
They have smaller estimates and standard errors because the standard normal distribution has standard deviation $1.0$ compared with $1.81$ for the standard logistic.

### Complementary Log-log Model

A *Complementary log-log* link function. 
The ordinal model using this link is sometimes called a proportional hazards model since it results from a generalization of the proportional hazards model for survival data to handle grouped survival times (**McCullagh 1980**). 

$$log( - log [1 - P(Y \leq j \mid x)]) = \alpha_j + \beta x$$

### Continuation-Ratio Logit Models (Survival Models ???)

The continuation-ratio logits are defined as

$$log  \frac{\pi_j}{\pi_{j + 1} + \pi_J}$$

or as 

$$log  \frac{\pi_{j + 1}}{\pi_1 + \pi_j}$$

The continuation-ratio logit model form is useful when a sequential mechanism, such as survival through various age periods, determines the response outcome (e.g., **Tutz 1991**).

# Generalized Additive Models

The GLM generalizes the ordinary linear model to permit nonnormal distributions and modeling functions of the mean. 
The quasi-likelihood approach generalizes GLMs, specifying how the variance depends on the mean without assuming a particular distribution. 
Another generalization of the GLM replaces the linear predictor by additive smooth functions of the predictors. 
The GLM structure 

$$g(\mu_i) = \sum_j \beta_j x_{i,j}$$ 

then generalizes to

$$g(\mu_i) = \sum_j s_j(x_{i,j})$$

where $s_j(.)$ is an unspecified smooth function of predictor $x_j$. 

A useful smooth function is the cubic spline. 
It has separate cubic polynomials over sets of disjoint intervals, joined together smoothly at boundaries of those intervals. 
The boundary points, called knots, could be at evenly spaced points for each predictor or selected according to some criterion involving both smoothness and closeness of the spline to the data.

Like GLMs, this model specifies a link function $g(.)$ and a distribution for the random component. 
The resulting model is called a generalized additive model, symbolized by GAM (**Hastie and Tibshirani 1990**). 
The GLM is the special case in which each $s_j(.)$ is a linear function.

The smoothing may suggest that a linear model is adequate with a particular link function or it may suggest ways to improve on linearity. 
Some software packages that do not have GAMs can smooth the data by employing a type of regression that gives greater weight to nearby observations in predicting the value at a given point; such *locally weighted least-squares regression* is often referred to as *lowess*.

Even if you plan to use GLMs, a GAM is helpful for exploratory analysis. 
For instance, for continuous $x$ with continuous responses, scatter diagrams provide visual information about the dependence of yon $x$. 
For binary responses, such diagrams are not very informative.
Plotting the fitted smooth function for a predictor may reveal a general trend without assuming a particular functional relationship.





# Modelling approaches for clustered data

**Clustered data** - observations occur for matched sets, or clusters, of observations. 
In a longitudinal study, a cluster consists of the set of repeated observations over time by a particular subject.
But the clustered responses need not refer to different times.

observations within a cluster tend to be more alike than observations from different clusters. 
Ordinary analyses that ignore the correlation usually have invalid standard errors.

## Marginal models

**Generalized estimating equations**

## Random effects

An alternative approach that adds cluster-level terms to the model that take the same value for each observation in a cluster. 
They are unobserved and, when treated as varying randomly among clusters, are called random effects.
The models have effects that pertain at the cluster level. 
Such effects are refered to as cluster-specific, or subject-specific when each cluster is a subject.
By contrast, in marginal models effects have population-averaged interpretations.

Generalized linear model to include random effects, giving a generalized linear mixed model.

Parameters that describe a factor's effects in an ordinary generalized linear model (GLM) are called fixed effects. 
They apply to all categories of interest, such as genders, treatments, or age groupings. By contrast, random effects usually apply to a sample. 
For a study that makes repeated observations on a sample of subjects, for example, the model treats observations from a given subject as a cluster, and it has a random effect for each subject.

The *generalized linear mixed model* (GLMM) is a further extension that permits *random effects* as well as fixed effects in the linear predictor.

Let $\mu_{it} = E(Y_{it} \mid u_i)$.
The linear predictor for a GLMM has the form

$$g(\mu_{it}) = \beta x_{it} + u_i z_{it}$$

for link function $g(.)$ and fixed effect model parameters $\beta$. 
The random effect vector $u_i$ is assumed to have a multivariate normal distribution $N(0, \sum)$.
This has the form of an ordinary GLM with unobserved values $u_{i}^{*}$ of a particular covariate.

Thus, random effects models relate to methods of dealing with unmeasured predictors and other forms of missing data. 
The random effects part of the linear predictor reflects terms that would be in the fixed effects part if those explanatory variables had been included.
Random effects also sometimes represent random measurement error in the explanatory variables.

*GLMMs with random effects describe cluster-specific effects, whereas marginal models describe population-averaged effects.*
*Some statisticians prefer one of these types, but most feel that both are useful, depending on the application.*