# Predict choice: A comparison of 21 mathematical models 

## Authors

Eric Schulz, Maarten Speekenbrink, David R. Shanks

## Abstract

How should we choose a model that predicts human choices? 
Two important factors in this choice are a model’s predictive power and a model’s flexibility. 
In this paper, we compare these aspects of models in a large set of models applied to an experiment in which participants chose between brands of fictitious chocolate bars and a quasi-experiment predicting movies’ gross revenue. 
We show that there is a trade-off between flexibility and predictive power, but that this trade-off appears to lie more towards the “flexible” side than what was previously thought.

## Keywords 

Choices; Forecasting; Overfitting.

## Introduction 

Choosing a good model to predict choices is an important task for both researchers of decision making and statis-
ticians. 
One crucial debate within this area concerns the flexibility of the model used to predict human choices.
On the one hand, there is the belief that more flexible models should be preferred as they potentially capture
the underlying psychological phenomenon well. 
Proponents of this approach try to show how more flexible models can outperform simpler models in many different predictive tasks (Chater et al., 2003). 
On the other hand, there are researchers who argue that models which are too flexible tend to overfit the data, capturing unimportant noise in the training set which results in suboptimal generalization to the test set.

## Flexibility

To shed more light on the debate about various degrees of flexibility and performance, one needs to introduce a reliable measurement of flexibility. 
Different measurements have been suggested, such as Kolmogorov complexity (Chater & Vitányi, 2003) and a model’s degrees
of freedom. 
The flexibility measure proposed here is defined in terms of the average ability of a model to capture and predict observations that have been generated from a different model. 
Importantly, the generating model has itself been fitted to a random set of data, and the best fitting parameters are then used to generate the learning and test sets. 
We used randomly generated data sets for the initial model fits in order to not bias the final recovery result in any systematic direction. 
While we could have used real world data sets for this initial simulation stage, our main concern was to assess a model’s ability to recover data generated by different models, and not their ability to recover systematic characteristics of particular data sets.

*It may be interesting to use the methodology described in this paper for model comparison*
*Even though it might be not the best choice*