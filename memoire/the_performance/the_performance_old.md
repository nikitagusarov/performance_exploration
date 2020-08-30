---
output: 
    pdf_document:
        toc: FALSE
        df_print: "kable"
        fig_width: 5
        fig_height: 4
        fig_caption: true
header-includes:
    - \usepackage{placeins}
    - \AtBeginDocument{\let\maketitle\relax}
fontsize: 11pt
bibliography: ../../litterature/bibliographie.bib
---







```{r Knitr, echo = FALSE}
#################
# Knitr options #
#################

knitr::opts_chunk$set(
    fig.align = "center",
    # eval = FALSE,
    echo = FALSE
)
```

```{r Packages, echo= FALSE, include = FALSE}
####################
# PAckages and AUX #  
####################

# General document wide packages
library(tidyverse)
library(stargazer)
```







<!-- ################################################################## -->
<!-- ################################################################## -->
<!-- ################################################################## -->

<!-- This is a major part of work and we will separate it into a single working file -->

## Performance measures 

*This part is the most untouched because :*

*(1) the keras framework is still in testing and requires new equilibred dataset; (2) it is still unclear how to discuss and present the different measures (there is clear need for derivation of the WTP, but with other measures it is less clear)*

```{r PackagesPerf, echo= FALSE, include = FALSE}
####################
# PAckages and AUX #
####################

# Performance measures
library(performance)

# Mlogit
library(mlogit)
library(neuralnet)
```

<!-- Resulting dataframe with different performance measures -->

*Here we should discuss the general metrics, questions that may be adressed and treated during the "performance evaluation"*

*This part needs validation and reorganisation, as well as answer for some questions*
*Should we implement complex estimation and validation (cross-validation) techniques ?* 
*Should we test performance of the models over a testing dataset ? (as it's usually done for general performance measures studies, but not for the coefficient esstimates)*

The econometric models focused on inference and understanding of the underlying effects are usually estimated over the full dataset as there is no question about the precision of the obteined results, but rather the statistical power achieved in derivations of the coefficiets. 
In this part we will follow the same approach in order not to face the different question related to external validity and verification of the estimated model, as well as the questions related to verification and testing of the models' performances over some external dataset.
It means, that we focus all our efforts on the ...

Nevertheless, this work aims at demontrating the full potential of the proposed experimental framework and we are bound to demonstrate at least a fraction of its full potential, which inevitably adresses the different performance metrics used to compare the models' performance in terms of precision and predictive accuracy.

To demonstrate the full potential over implementing all the different performance metrics we will divide our dataset into three parts. First of all we will separate 20% of our observations as a testing and verification dataset, to observe the goodness of fit for out of sample predictions.
The remaining 80% will be divided into 10 parts for cross-validation procedure.

```{r Load}
# Loading performance function from separate file 
# source("../../code/functions_measures.R")
source("../../code/functions_measures.R")

# Load data
load("../../data/simulation/dataset_mod.Rdata")
load("../../data/simulation/dataset_w_2_mod.Rdata")
load("../../data/simulation/dataset_w_3_mod.Rdata")

# Load Models
load("../../data/simulation/mnl_reg.Rdata")
load("../../data/simulation/nn_reg_3.Rdata")
```

```{r DetachData}
# Detach observed responses 
interdat = dataset %>% 
    dplyr::filter(Choice == 1) # Selec produces a df => we use aux variable
real = interdat$Alternative %>%
    as.factor()
    rm(interdat) # Clear aux vars
```

```{r PrepMNL}
# Data preparation MNL
## Probability prediction
mnl_prob = predict(
    mnl_reg, 
    newdata = dataset
)
## Class prediction
mnl_pred = colnames(mnl_prob)[apply(mnl_prob, 1, which.max)] %>%
    as.factor()

# Order as in real
mnl_pred = ordered(mnl_pred, levels = levels(real))
```

```{r PrepNN}
# Data preparation NN
nn_prob = predict(
    nn_reg_3, 
    newdata = dataset_w_3
)
colnames(nn_prob) = levels(real)
## Class prediction
nn_pred = colnames(nn_prob)[apply(nn_prob, 1, which.max)] %>%
    as.factor()
```

```{r PerformanceEval}
# Evaluating performances for different models
mes = list() # Aux object
## Attention !!! Entry factors should be identically ordered !!!
mes$mnl_perf = eval_performance(mnl_pred, real)
mes$nn_perf = eval_performance(nn_pred, real)
```

```{r DataComposition, include = FALSE}
# Data frame composition
## Aux vars
model_names = c("MNL", "NN")

# Create two frames
## With single metrics
df_single_m = matrix(
    ncol = length(mes), 
    nrow = 4,
)
## Names
colnames(df_single_m) = model_names
rownames(df_single_m) = c("ERR", "AC", "KLDvec", "KLDmat")
## Fillings
for (i in 1:length(mes)) {
    df_single_m[1, i] = mes[[i]]$ERR
    df_single_m[2, i] = mes[[i]]$AC 
    df_single_m[3, i] = mes[[i]]$KLDvec$intrinsic.discrepancy
    df_single_m[4, i] = mes[[i]]$KLDmat$intrinsic.discrepancy
}

## With metrics by alternative
df_mult = list()
for (i in 1:length(mes)) {
    # Dataframe creation
    df_mult_aux = matrix(
        ncol = length(levels(real)), 
        nrow = 16
    )

    # Names
    colnames(df_mult_aux) = paste0(
        model_names[i], "_",
        levels(real)
    )
    rownames(df_mult_aux) = c(
        "TP", "TN", "FP", "FN",
        "TPR", "TNR", "FPR", "FNR",
        "LRp", "LRn",
        "Precision", "Recall",
        "GeomMean1", "GeomMean2",
        "Fmeasure",
        "ClassRatio"
    )

    # Dataframe composition
    df_mult_aux[1, ] = mes[[i]]$TP
    df_mult_aux[2, ] = mes[[i]]$TN 
    df_mult_aux[3, ] = mes[[i]]$FP
    df_mult_aux[4, ] = mes[[i]]$FN
    df_mult_aux[5, ] = mes[[i]]$TPR 
    df_mult_aux[6, ] = mes[[i]]$TNR 
    df_mult_aux[7, ] = mes[[i]]$FPR 
    df_mult_aux[8, ] = mes[[i]]$FNR 
    df_mult_aux[9, ] = mes[[i]]$LRp 
    df_mult_aux[10, ] = mes[[i]]$LRn 
    df_mult_aux[11, ] = mes[[i]]$Precision 
    df_mult_aux[12, ] = mes[[i]]$Recall 
    df_mult_aux[13, ] = mes[[i]]$GeomMean1 
    df_mult_aux[14, ] = mes[[i]]$GeomMean2 
    df_mult_aux[15, ] = mes[[i]]$Fmeasure 
    df_mult_aux[16, ] = mes[[i]]$ClassRatio

    # Write to list 
    df_mult[[i]] = df_mult_aux
    rm(df_mult_aux) # Remove aux
    # Assign names
    names(df_mult)[i] = model_names[i]
}
# Combine dataframes
df_mult_m = do.call(cbind, df_mult)
rm(df_mult) # Remove aux

# Incompatible measures

## MNL PART
s_mnl_reg = summary(mnl_reg)
### Dataframe creation
# s_mnl_reg$logLik0, - NOT WORKING ! value extracted from estimation logs
s_mnl_reg$logLik0 = - 15380.5720413535
mnl_m = data.frame(
    MNL = c(
        AIC(mnl_reg),
        " ", # BIC(mnl_reg),
        s_mnl_reg$logLik,
        s_mnl_reg$logLik0, 
        (1 - (s_mnl_reg$logLik / s_mnl_reg$logLik0)) # r2_mcfadden(mnl_reg) - NOT WORKING !
    )
)
### Names
rownames(mnl_m) = c(
    "AIC", 
    "BIC",
    "LogLik", 
    "LogLik0",
    "McFaddenR2"
)

## NN PART
nn_m = data.frame(
    NN = c(
        NA
    )
)
### Names
rownames(nn_m) = "AIC"

## Merge parts 
df_spec_m = merge(mnl_m, nn_m)
```

### Multiclass measures

*Here it should be decided on what measures to retain, as many are the products of some basic ones*
*What measures to describe ?* 
*What measures to retain ?*

We can observe general performance measures, describing overall performance of a given cmassifier :

\FloatBarrier

```{r PerformanceResults_gen, results = "asis"}
# Print results
stargazer(
    df_single_m,
    title = "General performance measures",
    summary = FALSE,
    header = FALSE
)
```

\FloatBarrier

### Single-class measures

*Identical questions may be adressed to this part*
*What measures should we retain ?*

The next table regroups response specific metrics, that describe the precision of model in predicting only one target class of the dataset.
These metrics are mostly used when we are interested in some indepth insight into the model performance and allow to identify the models which perform the best over a single class of interest. 
For example, in the case of "roses" study we may be interested in identifying the algorithm which predicts the best "buy" versus "not buy" alternatives, providing at the same time some information about the alternative chosen.

\FloatBarrier

```{r PerformanceResults_mult, results = "asis"}
# Reorder df_mult_m
df_mult_m = df_mult_m[ , c(1,4,2,5,3,6)]

# Print results
stargazer(
    df_mult_m,
    title = "Variable specific performance measures",
    summary = FALSE,
    header = FALSE
)
```

\FloatBarrier

Finally, we contrast the metrics which are different between our target models (MNL and NN) :

\FloatBarrier

```{r PerformanceResults_spec, results = "asis"}
# Print results
stargazer(
    df_spec_m,
    title = "Model specific performance measures",
    summary = FALSE,
    header = FALSE
)
```

\FloatBarrier

It's worth mentionning that due to some unknown bug the *mlogit* function was unable to provide information on *LogLik0*. 
A value extracted from estimation logs was used instead ...

*To answer to this problem it may be interesting to use some alternaitve package for the estimation (as in the "testing" files)*

### Target metrics comparison 

*Here we should present the most interesting results comparing the estimates for the WTP estimates for different models*
*It may be quite logical to leave only this part for this work, as the main interest and focus of original paper is in the WTP expmloration*

The WTP as it was described previously can be represented as :

$$WTP = \frac{
    \frac{\delta V}{\alpha_{BUY}}
}{
    \frac{\delta V}{\delta Price}
}$$

*The premiums for the particular attributes:*

$$WTP = \frac{
    \frac{\delta V}{\delta X_k}
}{
     \frac{\delta V}{\delta Price}
}$$
