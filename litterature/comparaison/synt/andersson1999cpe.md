# Measure-based classifier performance evaluation

## Authors

Arne Anderssona, Paul Davidsson, Johan Lindén

## Introduction 

In this work, we suggest a new approach to theevaluation of classiÆer performance. 
Today, most methods  for  evaluating  the  quality  of  a  learned classiffier  are  based  on  some  kind  of  cross-valida-tion (Kohavi, 1995). 
However, we argue that it ispossible  to  make  evaluations  that  take  into  ac-count other important aspects of the classiÆer thanjust classiffication accuracy on a few instances.

We get an explicit distinction   between   problem   formulation,   i.e., specifying   the   measure   function   and   problem solving,  i.e.,  finding  a  classifier  maximizing  themeasure  function. 
By  making  this  distinction,  wecan   isolate   the   meta-knowledge   necessary   forclassifier selection from the details of the learning algorithms.

## Discussion on different measures

- Subset-fit - known instances should be clasisified correctly
- Similarity - similar instances should be classified similarly
- Simplicity - the partitioning of the universe should be as simple as possible

