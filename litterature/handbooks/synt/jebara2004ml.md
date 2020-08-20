# Abstract

The objective of this monograph is to unite two powerful yet different paradigms in machine learning: generative and discriminative. 
Generative learning approaches such as Bayesian networks are at the heart of many pattern recognition, artificial intelligence and perception systems.
These provide a rich framework for imposing structure and prior knowledge to learn a useful and detailed model of a phenomenon. 
Yet recent progress in discriminative learning, which includes the currently popular support vector machine approaches, has demonstrated that superior performance can be obtained by avoiding generative modeling and focusing only on the partieular task the machine has to solve. 
The dividing gap between these two prevailing methods begs the question: is there a powerful eonnection between generative and discriminative learning that combines the complementary strengths of the two approaehes? 
In this text, we undertake the challenge of building sueh a bridge and explieate a common formalism that spans both schools of thought.

# Distinctions

1. Generative models

Machine learning and statistics provide a formal approach for manipulating nondeterministic models by describing or estimating a probability density over the variables in question. 
Within this generative density, one can specify partial knowledge a priori and refine this coarse model using empirical observations and data.

2. Discriminative models 

Ironically, though, these flexible models have been recently outperformed in many cases by relatively simpler models est imated with discriminative algorithms .

As we outlined, probabilistic modeling tools are available for combining structure, priors, invariants, latent variables an d data to form a good joint density of the domain as a whole. 
However, discriminative algorithms directly optimize a relatively less domain specific model only for the classification or regression mapping that is required of the machine.
For example, support vect or machines [187, 28] directly maximize the margin of a linear separator between two sets of points in a Euclidean space to build a binary classifier. 
While the model is simple (linear), the maximum margin criterion is more appropriate than maximum likelihood or other generative criteria for the classification problem .