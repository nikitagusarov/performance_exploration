# Abstract

We provide a unified overview of methods that currently are widely used to assess the accuracy of prediction algorithms, from raw percentages, quadratic error measures and other distances, and correlation coefficients, and to information theoretic measures such as relative entropy and mutual information. 
We briefly discuss the advantages and disadvantages of each approach. 
For classification tasks, we derive new learning algorithms for the design of prediction systems by directly optimising the correlation coefficient. 
We observe and prove several results relating sensitivity and specificity of optimal systems. 
While the principles are general, we illustrate the applicability on specific problems such as protein secondary structure and signal peptide prediction.

# Performance measures overview

Researchers are more and more frequently faced with the problem of evaluating the accuracy
of a particular prediction algorithm. 
As several methods aiming at solving the same problem are often available it is also important to be able to select a particular method based on the performance features that can be inferred from the principles that went into its construction. 
Some methods are optimized such that they produce very few false positives, while others produce very few false negatives, and so on.

# Basic notation

* $D$ : The structural data $D$ available for the comparison is the secondary structure assignments
* $M$ : Prediction algorithm or model, outputs a prediction of the form $M$

The objective is to compare M to D.

- $TP$ = true positive
- $TN$ = true negative
- $FP$ = false positive
- $FN$ = false negative

# Performance measures

## Binary case

1. *Percentages* - The first obvious approach is to use percentages derived from $TP$, $TN$, $FP$, and $FN$.

Chou and Fasman (1978a,b) used the percentage of correctly predicted instances: 

$$PCP(D,M) = 100 \frac{TP}{TP + FN}$$

It can be complemented by the percentage of correctly predicted non-instances:

$$PCN(D,M) = 100 \frac{TN}{TN + FP}$$

2. *Hamming distance* - In the binary case, the Hamming distance between $D$ and $M$ is defined by

$$HD(D,M) = \sum_i \mid d_i − m_i \mid = FP + FN$$

3. *Quadratic distance* - The quadratic or Euclidean or least means square (LMS) distance is defined by 

$$Q(D,M) = (D − M)^2 = \sum_i (d_i − m_i)^2$$

A logarithmic variation on the LMS distance discussed is given by

$$LQ(D,M) = − \sum_i log [1 − (d_i − m_i)^2]$$

4. $L^p$ *distances* - More generally, the $L^p$ distance is defined by

$$LP(D,M) = [ \sum_i \mid d_i − m_i \mid ^p ] ^{\frac{1}{p}}

5. *Correlation* - One of the standard measures used by statisticians is the correlation coefficient also called the Pearson correlation coefficient (the correlation coefficient uses all four numbers ($TP$, $TN$, $FP$, $FN$) and may often provide a much more)

$$C(D,M) = \sum_i \frac{(d_i − \overline{d})(m_i − \overline{m})}{\sigma_D \sigma_M}$$

$$C(D,M) = \frac{TP \cdot TN − FP \cdot FN}{\sqrt{(TP + FN)(TP + FP)(TN + FP)(TN + FN)}}$$

6. *Approximate correlation* - Burset and Guigo (1996) defined an "approximate correlation" measure to compensate for an alleged problem with the Matthews correlation coefficient.

They use the average conditional probability ($AC$ $P$) which is defined as following if all the sums are non-zero

$$AC P = \frac{1}{4} [ \frac{TP}{TP + FN} + \frac{TP}{TP + FP} + 
    \frac{TN}{TN + FP} + \frac{TN}{TN + FN} ]$$

Otherwise, it is the average over only those conditional probabilities that are defined.

Approximate correlation ($AC$) is a simple transformation
of the $AC$ $P$

$$AC = 2 \cdot (AC P − 0.5)$$

7. *Relative entropy* - The relative entropy, or cross entropy, or Kullback–Leibler (KL) contrast between two probability vectors

$$H(X,Y) = \sum_{M}^{i = 1} x_i log \frac{x_i}{y_i} 
    = − H(X) − \sum_i x_i log y_i$$

Where $\sum_i x_i = \sum_i y_i = 1$

8. *Mutual information* - Consider two random variables $\mathcal{X}$ and $\mathcal{Y}$ with probability vectors **X** and **Y**. 
Let $\mathcal{Z}$ be the joint random variable $\mathcal{Z} = (\mathcal{X}, \mathcal{Y})$ over the Cartesian product with probability vector **Z**.

$$I(\mathcal{X}, \mathcal{Y}) = H(\mathcal{Z}, \mathcal{X} \mathcal{Y})$$

9. *Receiver operating characteristics curves, sensitivity and specificity* - In a two-class prediction case where the output of the prediction algorithm is continuous, the numbers $TP$, $TN$, $FP$ and $FN$ depend on how the threshold is selected.

## Multiple discrete case

In the case of a multi-class prediction problem with $K$ classes, one obtains a $K \cdot K$ contingency or confusion matrix **Z**.

*To sudy*