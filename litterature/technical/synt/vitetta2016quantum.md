# Abstract

One of the main components of the transport system is users’ choice behaviour. 
Choices result from users’ behaviour and are simulated by means of demand models. 
These models simulate how users’ behaviour is influenced by system activities and supply performance. 
The most common demand approaches are based on the *Random Utility Model* (RUM).

According to the RUM, a user knows of and considers mutually exclusive alternatives and associates each alternative with a perceived utility. 
The choice probability for each alternative is estimated using the RUM. 
An analyst evaluates the same value of pre-trip choice probability in the case of a unique sequence of decisions for his final choice of an alternative as in the case of a not-unique sequence of decisions for his final choice of an alternative.

A new class of models simulates the case in which the user has an unclear sequence of decision for his final choice of an alternative. 
This model, the *Quantum Utility Model* (QUM), derives from quantum mechanics models. 
In QUM, it is possible to simulate the sequence of decisions in the cases of unique or not-unique pre-trip decision in the intermediate levels.
In this paper, a comparison between the RUM and the QUM for the transport demand simulation is reported. 
A specification of the model is reported for the route choice level. 
The models are specified and compared in terms of numerical results in two test networks.

# Introduction

In transport systems theory, to simulate users’ behaviour, the decision process is often based on *Random Utility Models* (RUMs), on the concept of rational users, and on the following assumptions (**Von Neumann and Morgenstern, 1944**; **Ben-Akiva and Lerman, 1985**; **Cascetta 2009**). 
The user considers mutually exclusive alternatives and adopts for each alternative a perceived utility function of a set of measurable characteristics.

In RUMs, the user knows the available alternatives and associates to each alternative measurable characteristic.
An alternative chosen by the user derives from a sequence of choices.

*Quantum Utility Models* (QUMs) start from RUMs. 
In an analogy with RUMs, the QUMs are based on the assumptions reported for RUMs with differences related to alternatives that cannot be exclusive and to the evaluation of choice probability. 
In QUMs, the choice probability for each alternative is the sum of the probability that the perceived utility of the alternative is greater than the perceived utility of the other alternatives and the interference term connected to the level of interference of the specific alternative with respect to the others alternatives.

In relation to QUMs, one of the first specifications of transport for car driver behaviour was proposed by **Baker (1999)**. 
Recently, **Busemeyer and Bruza (2012)** proposed quantum theory for cognitive and decision processes. 
In Wallace (2002), an analysis of quantum mechanics for decision theory is reported. 
A comparison between Markov processes and quantum theory is reported in **Busemeyer et al. (2006)**. 
In **Agrawal and Sharda (2013)**, quantum mechanics connected with a quantum decision is reported; quantum mechanics is described also considering some practical examples, with two appendices related to elements of quantum mechanics for application in QUMs.