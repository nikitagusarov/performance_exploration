# Abstract 

Given any generative classier based on an inexact density model, we can dene a discriminative counterpart that reduces its asymptotic error rate. 
We introduce a family of classiers that interpolate the two approaches, thus providing a new way to compare them and giving an estimation procedure whose classication performance is well balanced between the bias of generative classiers and the variance of discriminative ones. 
We show that an intermediate trade-off between the two strategies is often preferable, both theoretically and in experiments on real data.

# Introduction 

In supervised classication, inputs x and their labels y arise from an unknown joint probability $p(x, y)$. 
If we can approximate $p(x, y)$ using a parametric family of models $G = \{ p_{\theta} (x, y), \theta \in \Theta \}$, then a natural classier is obtained by first estimating the class-conditional densities, then classifying each new data point to the class with highest posterior probability. 
This approach is called *generative classication*.

However, if the overall goal is to nd the classication rule with the smallest error rate, this depends only on the conditional density $p(y \mid x)$. 
*Discriminative classification$ methods directly model the conditional distribution, without assuming anything about the input distribution $p(x)$.

Well known generativediscriminative pairs include Linear Discriminant Analysis (LDA) vs. Linear logistic regression and naive Bayes vs. Generalized Additive Models (GAM).