# A comparative study of machine learning classifiers for modeling travel mode choice

## Authors

Julian Hagenauer, Marco Helbich

## Abstract

The analysis of travel mode choice is an important task in transportation planning and policy making in order to understand and predict travel demands. 
While advances in machine learning have led to numerous powerful classifiers, their usefulness for modeling travel mode choice remains largely unexplored. 
Using extensive Dutch travel diary data from the years 2010 to 2012, enriched with variables on the built and natural environment as well as on weather conditions, this study compares the predictive performance of seven selected machine learning classifiers for travel mode choice analysis and makes recommendations for model selection. 
In addition, it addresses the importance of different variables and how they relate to different travel modes. 
The results show that random forest performs significantly better than any other of the investigated classifiers, including the commonly used multinomial logit model.
While trip distance is found to be the most important variable, the importance of the other variables varies with classifiers and travel modes. 
The importance of the meteorological variables is highest for support vector machine, while temperature is particularly important for predicting bicycle and public transport trips. 
The results suggest that the analysis of variable importance with respect to the different classifiers and travel modes is essential for a better understanding and effective modeling of people’s travel behavior.

## Keywords

Travel mode choice, Classification, Machine learning, The Netherlands

## Introduction

Methods from the field of machine learning are a promising alternative to statistical approaches for modeling travel mode choice. 
Instead of making strict assumptions about the data, machine learning models learn to represent complex relationships in a data-driven manner (e.g. Bishop, 2006 ). 
The usefulness of machine learning models has already been demonstrated for different areas in transportation research. 
For example, machine learning models are particularly useful for classifying travel modes and inferring trip purposes from global position system and acceleration data (e.g. Shen & Stopher, 2014; Gong, Morikawa, Yamamoto, & Sato, 2014; Shafique & Hato, 2015 ). 
Other examples include the prediction of railway passenger demand (e.g. Tsai, Lee, & Wei, 2009 ) and bimodal modeling of freight transportation (e.g. Tortum, Yayla, & Gökda ğ, 2009 ). 
However, machine learning is still under represented in research of travel mode choice modeling. 
Existing studies are limited to a small number of machine learning methods and do not provide comprehensive model comparisons.

*This one should be moved to applications*