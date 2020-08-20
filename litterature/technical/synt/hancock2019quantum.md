# Abstract

There has been an increasing effort to increase the behavioural realism of the mathematical models of choice, resulting in efforts to move away from *random utility maximisation* (RUM) models.
Some new insights have been generated with, for example, models based *random regret minimisation* (RRM). 
However, many of the alternatives to RUM tested on real-world data, have looked at only modest departures from RUM, and differences in results have consequently been small.
In this paper, we address this research gap by investigating the applicability of *models based on quantum theory* - which are substantially different from the state-of-the-art choice modelling techniques. 
These models emphasise the importance of contextual effects, state dependence and the impact of choice or question order. 
As a result, *quantum probability models* have had some success in better explaining several phenomena in cognitive psychology. 
In this paper, we consider how to best operationalise *quantum probability into a choice model*. 
Two of our specifications find good model fit across three route choice datasets. 
Additionally, we test the quantum model frameworks on a best/worst route choice dataset and demonstrate that they find useful transformations to capture differences between the attributes important in a favourite alternative compared to that of the least favourite alternative. 
Similar transformations can also be used to efficiently capture contextual effects in a dataset where the order of the attributes and alternatives are manipulated. 
Overall, it appears that models incorporating quantum concepts hold significant promise in improving the state-of-the-art travel choice modelling paradigm through their adaptability and efficient modelling of contextual changes.

# Introduction

*Random utility maximisation* (RUM) framework has dominated the travel choice modelling field for many decades. 
More recently, RUM has been criticised as being inadequate in explaining the full range of behavioural complexity [**Chorus et al., 2008**, **Guevara and Fukushi, 2016**]. 
This has resulted in many attempts to better incorporate behavioural concepts into travel behaviour models, including regret [**Chorus et al., 2008**, **Chorus, 2010**], contextual relative advantages [**Leong and Hensher, 2014**] and prospect theory [**Avineri and Bovy, 2008**]. 
However, none of these developments have yet rivalled RUM as the preferred model in real-world applications. 
This is due to difficulties that quickly arise once a modeller departs from the firm economic foundations of RUM [**Hess et al., 2018**]. 
Consequently, caution is required if we are to step away from random utility models. 

Departures to models with similar underlying structure, such as *random regret minimisation* [**Chorus et al., 2008**, **Chorus, 2010**], which have the same error structure, result in only small differences whilst facing the same key fault of all departures from RUM, the loss of the ability to calculate welfare measures. 

Departures to more different models, such as *decision field theory* [**Busemeyer and Townsend, 1992**], whilst sometimes finding improvements in model fit, additionally result in models that become computationally infeasible for large-scale datasets [**Hancock et al., 2018**]. 
Thus, if we are to move away from RUM, we need to investigate alternative approaches that are computationally simpler - yet, better reflect behavioural realism.

Creation of a *new theory of probability, known as quantum logic* [**Birkhoff and Von Neumann, 1936**]. 
Under quantum logic (which is also known as quantum probability), a new set of probability rules were defined, which crucially *did not include the axiom of distributivity*. 
This new theory of probability has subsequently made the transition into *cognitive psychology* [**Bruza et al., 2015**] and has also been introduced into transport behaviour modelling. 
For example, **Vitetta (2016)** introduced a *quantum model based on random utility models* with the addition of an interference term for route choice problems. 
Additionally, **Yu and Jayakrishnan (2018)** demonstrated that quantum cognition models can efficiently be used to *capture the difference in state of mind between choices made under stated preference and revealed preference settings*.