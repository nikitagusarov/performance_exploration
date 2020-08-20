################################################
######## Measures and implementations 1 ########
################################################

# Packages loading
library(tidyverse)

# Choose one version to execute for testing !

########################
# Testing set creation 1
########################

# Testing number 
n = 100

# Artificial initial values generation
real = rep_len(
    c("a", "b", "c"),
    n
) %>% as.factor()

# Artificial response dataset generation
fit = data.frame(
    a = runif(n, 0, 1),
    b = runif(n, 0, 1),
    c = runif(n, 0, 1)
)

# Predictions
pred = colnames(fit)[apply(fit, 1, which.max)] %>%
    as.factor()

########################
# Testing set creation 2
########################

# Testing dataset

# Loading functional packages
library(mlogit)
ncores = 6

# Data loading 
data("TravelMode", package = "AER")

# Logistic regression
mnl_reg = mlogit(
    choice ~ travel + wait | income,
    data = TravelMode, 
    choice = "choice",
    shape = "long", 
    alt.var = "mode",
    print.level = 3, 
    iterlim = 50,
    ncores = cores
)

# Summary for verification
summary(mnl_reg)

# Get fitted values 
fitted(mnl_reg)

# Predicted values 
# Probabilities
proba = predict(mnl_reg, 
    newdata = TravelMode, 
    choice = "choice"
)
# Discrete choices
# pred = predict(mnl_reg, 
#     newdata = TravelMode, 
#     choice = "choice",
#     probability = FALSE
# )
# Predictions
pred = colnames(proba)[apply(proba, 1, which.max)] %>%
    as.factor()

# Actual responses for comparison
inter = TravelMode %>% 
    filter(choice == "yes")
real = inter$mode 
real = ordered(real, levels = levels(pred))
rm(inter) # Remove aux object






################################################
######## Measures and implementations 2 ########
################################################

########################
# Confusion matrix based
########################

# Confusion matrix
conf_m = table(real, pred)

#################
# General metrics
#################

# Empirical error rate (or Empirical risk)
ERR = (sum(conf_m) - sum(diag(conf_m)) / sum(conf_m)

# Accuracy
AC = sum(diag(conf_m)) / sum(conf_m)

# True-positives 
TP = diag(conf_m) %>%
    matrix(nrow = 1)
colnames(TP) = colnames(conf_m)

# False-positives
FP = colSums(conf_m) - diag(conf_m)

###########################
# Variable specific metrics
###########################

# Here we find a problem at defining true and false negatives 
# There should be a way around it
# The formulas below are not fully cmplete

# False positives
TN = vapply(
    diag(conf_m), 
    function(x) {sum(diag(conf_m)) - x}, 
    numeric(1)
)
colnames(TN) = colnames(conf_m)

# False-negatives
# FN = rowSums(conf_m) - diag(conf_m)
FN = vapply(
    rowSums(conf_m) - diag(conf_m), 
    function(x) {
        sum(rowSums(conf_m) - diag(conf_m)) - x
    }, 
    numeric(1)
)

# True-positive rate (or Sensitivity)
TPR = TP / (TP + FN)

# False-positive rate
FPR = FP / (FP + TN)

# True-negative rate (or Specificity)
TNR = TN / (TP + FN)

# False-negative rate
FNR = FN / (FN + TP)

# Likelihood ratio +
LRp = TPR / (1 - TNR)

# Likelihood ratio -
LRn = (1 - TPR) / TNR

# Precision
PPV = diag(conf_m) / colSums(conf_m)
Prec = TP / (TP + FP)

# Recall
Rec = TP / (TP + FN)

# Geometric mean 1
GM_1 = sqrt(TPR * TNR)

# Geometric mean 2
GM_2 = sqrt(TPR * PPV)

# F-measure (balanced variant)
a = 1 # Setting ponderation parameter (1 for balanced type)
F_a = (1 + a)*(Prec * Rec) / (a*Prec + Rec)

# Class ratio
r = (TP + FN) / (FP + TN)

############################
# Probability based measures
############################

# Get probabilities
input_p = summary(real) / length(real)
out_p = summary(pred) / length(pred)

# Kullback–Leiblerdivergence (KL divergence or Relative Entropy)
KL = LaplacesDemon::KLD(
    px = out_p,
    py = input_p
)

# Get probabilities in matrix format (taking into account the missclassification)
lev = length(unique(real))
input_pm = matrix(0, nrow = lev, ncol = lev) 
diag(input_pm) = summary(real) / length(real)
out_pm = conf_m / sum(conf_m)

# Relative Entropy (KL Divergence)
RE = LaplacesDemon::KLD(
    px = out_pm,
    py = input_pm
)

# It is impossible to use this metrics over a dataset with unknown distributions