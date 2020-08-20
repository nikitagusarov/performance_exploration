# Machine Learning as an Experimental Science

## Authors 

Chris Drummond

## Abstract 

In 1988, Langley wrote an influential editorial in the journal Machine Learning titled “*Machine Learning as an Experimental Science*”, arguing persuasively for a greater focus on performance testing. 
Since that time the emphasis has become progressively stronger. 
Nowadays, to be accepted to one of our major conferences or journals, a paper must typically contain a large experimental section with many tables of results, concluding with a statistical test. 
In revisiting this paper, I claim that we have ignored most of its advice. 
We have focused largely on only one aspect, hypothesis testing, and a narrow version at that. 
This version provides us with evidence that is much more impoverished than many people realize. 
I argue that such tests are of limited utility either for comparing algorithms or for promoting progress in our field. 
As such they should not play such a prominent role in our work and publications. 

## A bit of history 

A report on
the AAAI 1987 conference noted “the ML community has become increasingly concerned about validating claims and demonstrating solid research results” (Greiner et al. 1988).
In 1988, Langley wrote an editorial for the journal Machine Learning, quickly expanded, in the same year, into a workshop paper with co-author Kibler, arguing persuasively for greater focus on performance testing. 
With this sort of accord in the community, performance testing took on greater prominence. 
With the appearance, soon after, of the UCI collection of data sets (Blake & Merz 1998), performance comparisons between algorithms became commonplace. 

Unfortunately, the testing procedure we use does little in distinguishing good theories from bad. 
There are, I claim, three components of this procedure that undercut its value: the measures used, the reliance of null hypothesis testing and the use of benchmark data sets. 
Our measures do not measure all that we care about. 
Null hypothesis statistical tests are widely misinterpreted and when correctly interpreted say little. 
The data in our data sets is unlikely to have been randomly chosen and the data sets, themselves, are not a sample of any “real” world.

The most common experiment, carried out by machine learning researchers, is to train and test two algorithms on some subset of the UCI datasets (Blake & Merz 1998). 
Their performance is measured with a simple scalar function. 
A one sided statistical test is then applied to the difference in measured values, where the null hypothesis is no difference. 
If there is statistically significant difference in favor of one algorithm, on more UCI data sets than the other, it is declared the winner.

## Performance Measures

The main advantage of a simple scalar measure is that it is objective. 
It gives a clear, and seemingly definitive answer, to which algorithm is the best. 
If the algorithm being tested is well described, and the experimental set up is well specified, then the experimental results could be reproduced by another researcher. 
As scalars are totally ordered, the same conclusions would be drawn.
The property of objectivity is unquestionably desirable but only if “all other things are equal”, an essential caveat.
There is another property of equal, or perhaps greater, importance. 
The measured value must represent something we care about. 
One difficulty is the diversity of the people who must be considered in this judgment: the particular researcher, the research community as a whole, end users of applications and, of course, referees for conferences and journals. 
It is unreasonable to expect to capture all these concerns in a single scalar measure.

Scalar measures also over-simplify complex questions, combining things together which should be kept separate.
Any advantage indicated by a simple scalar measure may be illusory if it hides situation dependent performance differences. 
As this author has discussed elsewhere (Drummond & Holte 2005), that some algorithms fail to do better than trivial classifiers for extreme class skews is a concern that was largely hidden by the standard practice.

## Statistical Tests

The main advantage of null hypothesis statistical tests is the apparent rigor and objectivity they bring to our field. 
The results we publish are not just wishful thinking, they have been empirically evaluated. 
Although only briefly mentioned by Kibler and Langley 1988, statistical tests have become firmly entrenched in our field. 
They are part of the experimental section of any paper that has a reasonable expectation of publication. 
Many feel that careful evaluation is what makes our research an “experimental science”.

Yet, the value of the null hypothesis statistical tests (NHST) that we use has become increasingly controversial in many fields. 
There is an enormous amount of literature on this issue, stretching back more than sixty years (Hagood 1941). 
The controversy is particularly evident in psychology as seen in the response from critics that accompanied a paper (Chow 1998) in the journal Behavioral and Brain Sciences. 
One particularly strong view was voiced by Gigerenzer (Chow 1998, p199) “NHSTP is an inconsistent hybrid of Fisherian and Neyman-Pearsonian ideas. 
In psychology it has been practiced like ritualistic handwashing and sustained by wishful thinking about its utility.”