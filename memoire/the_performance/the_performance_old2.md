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

```{r PackagesPerf, echo= FALSE, include = FALSE}
####################
# PAckages and AUX #
####################

# Performance measures
library(performance)

# Mlogit
library(mlogit)
library(neuralnet)

# Aux custom fuctions 
source("../../code/functions_measures.R")
```

Resulting dataframe with different performance measures

```{r DataLoad, include = FALSE}
# list of models to load
models_load = list(
  "../../data/memoire/mnl_novar_estimates.Rdata",
  "../../data/memoire/mmnl_novar_estimates.Rdata",
  "../../data/memoire/cnn_novar_estimates.Rdata",
  # "../../data/memoire/rrmcnn_novar_estimates.Rdata",
  "../../data/memoire/mnl_covar_estimates.Rdata",
  "../../data/memoire/mmnl_covar_estimates.Rdata",
  "../../data/memoire/cnn_covar_estimates.Rdata" # ,
  # "../../data/memoire/rrmcnn_covar_estimates.Rdata"
)

# Load models from list
for (i in 1:length(models_load)) {
  load(models_load[[i]])
}
```

```{r PerformanceEval, include = FALSE}
# Evaluating performances for different models
mes = list() # Aux object
## Attention !!! Entry factors should be identically ordered !!!
mes$mnl_novar_perf = eval_performance(
  mnl_novar_estimates$predictions$Choice, 
  ordered(mnl_novar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
mes$mmnl_novar_perf = eval_performance(
  mmnl_novar_estimates$predictions$Choice, 
  ordered(mmnl_novar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
mes$mnl_covar_perf = eval_performance(
  mnl_covar_estimates$predictions$Choice, 
  ordered(mnl_covar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
mes$mmnl_covar_perf = eval_performance(
  mmnl_covar_estimates$predictions$Choice, 
  ordered(mmnl_covar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
mes$cnn_novar_perf = eval_performance(
  cnn_novar_estimates$predictions$Choice, 
  ordered(cnn_novar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
mes$cnn_covar_perf = eval_performance(
  cnn_covar_estimates$predictions$Choice, 
  ordered(cnn_covar_estimates$predictions$Real, levels = c("C", "A", "B"))
)
# mes$rrmcnn_novar_perf = eval_performance(
#   rrmcnn_novar_estimates$predictions$Choice, 
#   ordered(rrmcnn_novar_estimates$predictions$Real, levels = c("C", "A", "B"))
# )
# mes$rrmcnn_covar_perf = eval_performance(
#   rrmcnn_covar_estimates$predictions$Choice, 
#   ordered(rrmcnn_covar_estimates$predictions$Real, levels = c("C", "A", "B"))
# )
```

```{r CreatingPerfMDFs}
# Data frame composition
## Aux vars
model_names = c(
  "MNL",
  "MMNL",
  "CNN",
  # "ECNN",
  "MNL",
  "MMNL",
  "CNN"#,
  # "ECNN"
)

# Create two frames
## With single metrics
df_single_m = matrix(
  ncol = length(mes), 
  nrow = 4,
)
## Names
colnames(df_single_m) = c(
  "MNL FE",
  "MMNL FE",
  "CNN FE",
  # "ECNN FE",
  "MNL RE",
  "MMNL RE",
  "CNN RE"#,
  # "ECNN RE"
)
rownames(df_single_m) = c("ERR", "AC", "KLDvec", "KLD")
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
    ncol = 3, 
    nrow = 16
  )

  # Names
  colnames(df_mult_aux) = paste0(
    model_names[i], " ",
    c("C", "A", "B")
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
# df_mult_m = do.call(cbind, df_mult)
df_mult_m1 = cbind(df_mult[[1]], df_mult[[2]])
df_mult_m2 = cbind(df_mult[[3]], df_mult[[4]])
df_mult_m3 = cbind(df_mult[[5]], df_mult[[6]])
# df_mult_m3 = cbind(df_mult[[5]], df_mult[[6]])
# df_mult_m4 = cbind(df_mult[[7]], df_mult[[8]])
rm(df_mult) # Remove aux

# Starting LogLik0 values for : 
## mnl_novar = 175777.966186897 
### iteration 1, step = 1, lnL = 74981.44135026, chi2 = 180637.29557357
### iteration 7, step = 1, lnL = 53660.60190033, chi2 = 3.44e-06
## mmnl_novar = 53714.7337717171
### iteration 1, step = 1, lnL = 53663.09772253, chi2 = 149.08409178
### iteration 18, step = 1, lnL = 53656.73123084, chi2 = 7.3e-07
## mnl_covar = 175777.966186897
### iteration 1, step = 1, lnL = 115445.53784483, chi2 = 112388.6367642
### iteration 5, step = 1, lnL = 112071.03292338, chi2 = 3.32e-06
## mmnl_covar = 94446.3524352269
### iteration 1, step = 1, lnL = 75297.84113602, chi2 = 43800.27833966
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
  df_single_m[c(2,4),], # Accuracy + KLD
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

```{r PerformanceResults_mult1, results = "asis"}
df_mult_m1 = df_mult_m1[c(13,15),]
rownames(df_mult_m1) = c("Geometric mean", "F-measure")
# Print results
stargazer(
  df_mult_m1[c(),],
  title = "Variable specific performance measures, fixed effects data",
  summary = FALSE,
  header = FALSE
)
```

\FloatBarrier

\FloatBarrier

```{r PerformanceResults_mult2, results = "asis"}
df_mult_m2 = df_mult_m1[c(13,15),]
rownames(df_mult_m2) = c("Geometric mean", "F-measure")
# Print results
stargazer(
  df_mult_m2,
  title = "Variable specific performance measures, fixed effects data",
  summary = FALSE,
  header = FALSE
)
```

\FloatBarrier

\FloatBarrier

```{r PerformanceResults_mult3, results = "asis"}
# Print results
stargazer(
  df_mult_m3,
  title = "Variable specific performance measures, random effects data",
  summary = FALSE,
  header = FALSE
)
```

\FloatBarrier

\FloatBarrier

```{r PerformanceResults_mult4, results = "asis"}
# Print results
stargazer(
  df_mult_m4,
  title = "Variable specific performance measures, random effects data",
  summary = FALSE,
  header = FALSE
)
```

\FloatBarrier

Finally, we contrast the metrics which are different between our target models (MNL and NN) :

It's worth mentionning that due to some unknown bug the *mlogit* function was unable to provide information on *LogLik0*. 
A value extracted from estimation logs was used instead ...

*To answer to this problem it may be interesting to use some alternaitve package for the estimation (as in the "testing" files)*

### Target metrics comparison 

<!-- *The effect is a ratio of two marginal variations of the probability and of the covariate ; these variations can be absolute "a" or relative "r".*
*This argument is a string that contains two letters, the first refers to the probability, the second to the covariate*

*Find some way to present keras estimates: https://rstudio-pubs-static.s3.amazonaws.com/452498_2bb5b64288b94710a86982c3f70bb483.html (here is a version easy to implement with R (one of many possible ways to calculate marginal effects)*
*quite good presentation - insert above for nn algo explanation*

***Partial Dependence Plot (PDP)**: This plot shows the marginal effect of a feature on the outcome of a fitted model.* 
*Mathematically that is,the marginal distribution of all features, but the assumed one, is used when PDP is plotted;* 
***Accumulated Local Effects (ALE) Plot**: This plot again shows the effect of a feature on the outcome of a fitted model.* 
*However, one of the main differences between ALE plot and PDP is that it uses considitional distribution rather than marginal distribution when calculating the average effect of the feature;* 
***Permutation feature importance (PFI)**: PFI provides scores for each feature after we permute each feature’s values.* 
*The idea behind this concept is that a feature is important for the underlying model if permuting its values increases the model error.*  -->

Here we should present the most important results comparing the estimates for the WTP, as well as the premiums for particular attributes derived for different models.
The Premium to pay for a rose's particular attribute as it was described previously can be represented as:

$$WTP = \frac{
  \frac{\delta V}{\delta X_k}
}{
   \frac{\delta V}{\delta Price}
}$$

\FloatBarrier

```{r WTP, results = "asis"}
# Get
#   "../../data/memoire/mnl_novar_estimates.Rdata",
#   "../../data/memoire/mmnl_novar_estimates.Rdata",
#   "../../data/memoire/cnn_novar_estimates.Rdata",
#   "../../data/memoire/rrmcnn_novar_estimates.Rdata",
#   "../../data/memoire/mnl_covar_estimates.Rdata",
#   "../../data/memoire/mmnl_covar_estimates.Rdata",
#   "../../data/memoire/cnn_covar_estimates.Rdata"
#   "../../data/memoire/rrmcnn_covar_estimates.Rdata"

# Get WTPs for simple models
wtp_simple = data.frame(
    "MNL FE" = as.numeric(mnl_novar_estimates$wtp),
    "CNN FE" = as.numeric(cnn_novar_estimates$wtp),
    "MNL RE" = as.numeric(mnl_covar_estimates$wtp),
    "CNN RE" = as.numeric(cnn_covar_estimates$wtp)
)
rownames(wtp_simple) = c(
    "Buy", "Label", "Carbon", "LC"
)

# Print prep
to_print = capture.output({
    stargazer(
        wtp_simple,
        header = FALSE,
        title = "WTP obtained with MNL and CNN",
        rownames = TRUE,
        colnames = TRUE,
        summary = FALSE
    )
})[1:17]

# Print
cat(
    paste(
        to_print,
        paste = "\n"
    )
)
```

\FloatBarrier


For the estimation of the WTP and the premiums for more complex models we use the same procedure, as was implemented by @llerena2013rose.
Because the random parameters are assumed to be correlated in the MMNL model's specification, the estimated standard deviations and confidence intervals are obtained using the Krinsky and Robb parametric bootstrapping method (*Krinsky and Robb, 1986*). 
This procedure consits of generating of random draws from a multivariate normal distribution and using the obtained results to obtain the confidence interval estimates. 
Exactly as in the original study we generate 1000 draws from a multivariate normal distribution ($MNV(\mu, \Sigma)$), with the coefficient estimates as means $\mu$ and the estimated variance-covariance matrix of the random parameters as $\Sigma$.

The obtained results are then summarised as follows:

\FloatBarrier

```{r WTP_MMNL_FE, results = "asis"}
# Print
stargazer(
    mmnl_novar_estimates$wtp_dist,
    header = FALSE,
    title = "WTP obtained with MMNL, fixed effects data"
)
```

\FloatBarrier

\FloatBarrier

```{r WTP_MMNL_RE, results = "asis"}
# Print
stargazer(
    mmnl_covar_estimates$wtp_dist,
    header = FALSE,
    title = "WTP obtained with MMNL, random effects data"
)
```

\FloatBarrier

Comparing the estimates to the input values we observe that ...