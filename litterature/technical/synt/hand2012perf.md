# Abstract 

A large number of measures have been developed for evaluating the performance of classification rules. 
Some of these have been developed to meet the practical requirements of specific applications, but many others—which here we call “classification accuracy” criteria—represent different ways of balancing the different kinds of misclassification which may be made. 
This paper reviews classification accuracy criteria. 

However, the literature is now so large and diverse that a comprehensive list, covering all the measures and their variants, would probably be impossible.
Instead, this paper embeds such measures in general framework, spanning the possibilities, and draws attention to relationships between them. 
Important points to note are : 

- firstly, that different performance measures, by definition, measure different aspects of performance; 
- secondly, that one should therefore carefully choose a measure to match the objectives of one’s study;
- thirdly, that empirical comparisons between instruments measuring different aspects are of limited value.

# Introduction 

Instead of attempting to produce an inevitably incomplete list of measures, in this paper we have sought to provide a sound theoretical framework on which measures of classifier performance can be hung, and then to place the more important existing measures in that framework. 
Moreover, we restrict ourselves to *single scalar measures of performance*: we will not here examine in detail tools which enable one to explore wider aspects of classifier performance, such as 

- ROC curves 
- cost curves (**Drummond & Holte, 2006**), 
- precision–recall curves (**Davis & Goadrich, 2006**), 
- skill plots (**Briggs & Zaretski, 2008**), 
- relative utility curves (**Baker et al., 2009**), 

except insofar as they can be summarised to yield simple numerical measures. 
We will also restrict ourselves to the *two class case*.