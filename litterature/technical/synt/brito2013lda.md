# Abstract 

This work proposes an analytical method for cereal bar classification based on the use of near infrared spectroscopy (NIRS) and supervised pattern recognition techniques. 
Linear discriminant analysis (LDA) is employed to build a classification model on the basis of a reduced subset of variables (wavenumbers). 
For the purpose of variable selection, three techniques are considered, namely successive projection algorithm (SPA), Genetic Algorithm (GA), and stepwise (SW) formulation. 
The methodology is validated in a case study involving the classification of 121 cereal bar samples into three different types (conventional, diet and light). 
The results show that the LDA/GA model is superior to the LDA/SPA and LDA/SW models with respect to classification accuracy in an independent prediction set. 
Some advantages of the proposed method are speed, that the analytical measurement is performed quickly (one minute or less per sample), no reagents, low sample consumption and minimum sample preparation demands. 
In view of the results obtained in this study the proposed method may be considered valid for use in cereal bar classification.

# Introduction 

Supervised pattern recognition methods essentially differ in theway they define classification rules. 
Basically, they can be divided into discriminating and class-modelling methods (**Roggo, Duponchel, & Huvenne, 2003**). 
Linear discriminant analysis (LDA) and partial least square-discriminant analysis (PLS-DA) are examples of discriminating techniques, whereas the soft independent modelling of class analogy (SIMCA) is a class-modelling method. 
The modeling strategies among these methods are substantially different. 

*LDA and PLS-DA focus on the dissimilarity between classes* and the samples must be classified in a particular training classe (**Roggo et al., 2003**; **Vaid, Burl, & Lewis, 2001**). 

*The SIMCA method, however, considers each class separately* and performs outlier tests to decide whether a new object belongs to a certain class, to all classes or does not belong to any class. 
The SIMCA method is frequently used in data sets with high dimensionality (**Brereton, 2009**) such as spectroscopic data. 
However, the testing procedure adopted by SIMCA has the disadvantage that one has to set a confidence level, $\alpha$. 
If the data are normally distributed, $\alpha %$ (e.g. $5%$) of objects belonging to the class will be considered as not belonging to it. 
This misclassification problem can be avoided when the LDAmethod is employed. 

The LDA method employs linear decision boundaries, which are defined in order to maximize the ratio of between-class to within-class dispersion (**Fisher, 1936**). 
Its has been successfully applied to a number of classification problems (**Gambarra Neto et al., 2009**; **Gori, Maggio, Cerretani, Nocetti, & Caboni, 2012**; **Riovanto et al., 2011**; **Sinelli et al., 2010**; **Souto et al., 2010**). 

When compared with SIMCA and PLS-DA, the LDA method has the disadvantage that the number of training samples must be larger than the number of variables included in the LDA model. 
Therefore, procedures based on the selection of each variable are required for the classification of spectral data. 
The *successive projections algorithm* (SPA) (**Pontes et al., 2005**; **Pontes, Pereira, Pimentel, Vasconcelos, & Silva**; **Silva, Pontes, Pimentel, & Pontes, 2012**; **Silva, Borba, et al., 2012**), *genetic algorithm* (GA) (**Pontes et al., 2005**) and *stepwise (SW) formulation* (**Caneca et al., 2006**) methods have been adopted for this purpose in different classification problems.