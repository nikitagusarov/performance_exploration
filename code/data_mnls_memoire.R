########################################
# Preparation and analysis of datasets #
########################################

# What tables we may need ?

# For original dataset
## A against B
## Individuals

# For generated datasets
## A against B
## Individuals

# Choose estimation method
estimation_method = "bfgs"
# Set number of iterations
n_iterations = 100
# Set random seed
set_seed = 1208





#################
# Load packages #
#################

# Data management
library(tidyverse)

# Latex output generation
library(stargazer)

# MNL + MMNL Logit
library(mlogit)

# Effects
library(margins)





#######################
# No variance dataset #
#######################

#######
# MNL #
#######

# Load dataset
load("data/memoire/data_novar.Rdata")

# Transform to mlogit format
ml_dataset_novar = data_novar %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
## Real choices 
Real = data_novar %>%
    select(
        Alternative,
        Choice
    ) %>% 
    dplyr::filter(
        Choice == 1
    ) %>%
    select(
        Alternative
    )
# Clean space
rm(data_novar); gc()

# Function
funct = Choice ~ Sex + Age + Salary + Habit + # Individual
    Price + Buy + Label + Carbon + LC + 0 | 0 # Alternatives

# MNL model
## Estimation
time_mnl_novar = system.time({
    mnl_novar = mlogit(
        funct,
        data = ml_dataset_novar, 
        reflevel = "C", # The No-buy option is the baseline
        print.level = 3, # Print estimation details
        iterlim = 1000,
        seed = set_seed # Random seed
    )
})

# Predictions
## Probability predictions
mnl_novar_pred = predict(
    mnl_novar, 
    newdata = ml_dataset_novar
)
## Class prediction
Choice = colnames(mnl_novar_pred)[apply(mnl_novar_pred, 1, which.max)] 
mnl_novar_pred = cbind(
        mnl_novar_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
mnl_novar_pred = cbind(
        mnl_novar_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
## Compute effects 
### Covariates
covariates = c(
    "Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon"
)
### Compute effects
mnl_novar_effects = list()
for (i in 1:length(covariates)) {
    mnl_novar_effects[[i]] = effects(
        mnl_novar,
        covariate = covariates[[i]],
        # type = "rr", 
        # data = ml_dataset_novar,
        print.level = 3
    )
}
names(mnl_novar_effects) = covariates 

# Clear
mnl_novar_estimates = list(
    model = mnl_novar, 
    predictions = mnl_novar_pred, 
    time = time_mnl_novar,
    effects = mnl_novar_effects
)
rm(list = c("mnl_novar", "mnl_novar_pred", "time_mnl_novar", "mnl_novar_effects")); gc()
## Save
save(
    mnl_novar_estimates,
    file = "data/memoire/mnl_novar_estimates.Rdata"
)
## Clear
rm(mnl_novar_estimates); gc()
rm(ml_dataset_novar); gc()

########
# MMNL #
########

# Load dataset
load("data/memoire/data_novar.Rdata")

# Modify data
data_novar$CHID = rep(
    1:(nrow(data_novar)/3), 
    each = 3
)

# Transform to mlogit format
ml_dataset_novar = data_novar %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        id = "ID",
        chid = "CHID",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
## Real choices 
Real = data_novar %>%
    select(
        Alternative,
        Choice
    ) %>% 
    dplyr::filter(
        Choice == 1
    ) %>%
    select(
        Alternative
    )
# Clean space
rm(data_novar); gc()

## Estimation
time_mmnl_novar = system.time({
    mmnl_novar = mlogit(
        funct,
        data = ml_dataset_novar, 
        reflevel = "C", # The No-buy option is the baseline
        correlation = TRUE, # Include covariance (and not variance only)
        rpar =  c( # Normality assumption and four parameters
            "Buy" = "n", 
            "Label" = "n", 
            "Carbon" = "n", 
            "LC" = "n"
        ),
        panel = TRUE,
        # method = estimation_method, 
        print.level = 3, # Print estimation details
        iterlim = 1000,
        seed = set_seed # Random seed
    )
})

# Predictions
## Probability predictions
mmnl_novar_pred = predict(
    mmnl_novar, 
    newdata = ml_dataset_novar
)
## Class prediction
Choice = colnames(mmnl_novar_pred)[apply(mmnl_novar_pred, 1, which.max)] 
mmnl_novar_pred = cbind(
        mmnl_novar_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
mmnl_novar_pred = cbind(
        mmnl_novar_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
## Compute effects 
### Covariates
covariates = c(
    "Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon"
)
### Compute effects
mmnl_novar_effects = list()
# for (i in 1:length(covariates)) {
#     mmnl_novar_effects[[i]] = effects(
#         mmnl_novar,
#         covariate = covariates[[i]],
#         # type = "rr", 
#         data = ml_dataset_novar,
#         print.level = 3
#     )
# }
# names(mmnl_novar_effects) = covariates 

# Clear
mmnl_novar_estimates = list(
    model = mmnl_novar, 
    predictions = mmnl_novar_pred, 
    time = time_mmnl_novar,
    effects = mmnl_novar_effects
)
rm(list = c("mmnl_novar", "mmnl_novar_pred", "time_mmnl_novar", "mmnl_novar_effects")); gc()
## Save
save(
    mmnl_novar_estimates,
    file = "data/memoire/mmnl_novar_estimates.Rdata"
)
## Clear
rm(mmnl_novar_estimates); gc()

# Clean space
rm(ml_dataset_novar); gc()





#############################
# Random correlated effects #
#############################

#######
# MNL #
#######

# Load dataset
load("data/memoire/data_covar.Rdata")

# Transform to mlogit format
ml_dataset_covar = data_covar %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
## Real choices 
Real = data_covar %>%
    select(
        Alternative,
        Choice
    ) %>% 
    dplyr::filter(
        Choice == 1
    ) %>%
    select(
        Alternative
    )
# Clean space
rm(data_covar); gc()

# Function
funct = Choice ~ Sex + Age + Salary + Habit + # Individual
    Price + Buy + Label + Carbon + LC | 0 | 0 # Alternatives

# MNL model
## Estimation
time_mnl_covar = system.time({
    mnl_covar = mlogit(
        funct,
        data = ml_dataset_covar, 
        reflevel = "C", # The No-buy option is the baseline
        print.level = 3, # Print estimation details
        iterlim = 1000,
        seed = set_seed # Random seed
    )
})

# Predictions
## Probability predictions
mnl_covar_pred = predict(
    mnl_covar, 
    newdata = ml_dataset_covar
)
## Class prediction
Choice = colnames(mnl_covar_pred)[apply(mnl_covar_pred, 1, which.max)] 
mnl_covar_pred = cbind(
        mnl_covar_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
mnl_covar_pred = cbind(
        mnl_covar_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
## Compute effects 
### Covariates
covariates = c(
    "Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon"
)
### Compute effects
mnl_covar_effects = list()
for (i in 1:length(covariates)) {
    mnl_covar_effects[[i]] = effects(
        mnl_covar,
        covariate = covariates[[i]],
        # type = "rr", 
        # data = ml_dataset_novar,
        print.level = 3
    )
}
names(mnl_covar_effects) = covariates 

# Clear
mnl_covar_estimates = list(
    model = mnl_covar, 
    predictions = mnl_covar_pred, 
    time = time_mnl_covar,
    effects = mnl_covar_effects
)
rm(list = c("mnl_covar", "mnl_covar_pred", "time_mnl_covar", "mnl_covar_effects")); gc()
## Save
save(
    mnl_covar_estimates,
    file = "data/memoire/mnl_covar_estimates.Rdata"
)
## Clear
rm(mnl_covar_estimates); gc()
rm(ml_dataset_covar); gc()

########
# MMNL #
########

# Load dataset
load("data/memoire/data_covar.Rdata")

# Modify data
data_covar$CHID = rep(
    1:(nrow(data_covar)/3), 
    each = 3
)

# Transform to mlogit format
ml_dataset_covar = data_covar %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        id = "ID",
        chid = "CHID",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
## Real choices 
Real = data_covar %>%
    select(
        Alternative,
        Choice
    ) %>% 
    dplyr::filter(
        Choice == 1
    ) %>%
    select(
        Alternative
    )
# Clean space
rm(data_covar); gc()

# MMNL model## Estimation
time_mmnl_covar = system.time({
    mmnl_covar = mlogit(
        funct,
        data = ml_dataset_covar, 
        reflevel = "C", # The No-buy option is the baseline
        correlation = TRUE, # Include covariance (and not variance only)
        rpar =  c( # Normality assumption and four parameters
            "Buy" = "n", 
            "Label" = "n", 
            "Carbon" = "n", 
            "LC" = "n"
        ),
        R = 100, halton = NA,
        # id.var = "ID",
        panel = TRUE,
        # method = "bhhh", # "bfgs", "nr" (produces error), "bhhh" (does not converge)
        ftol = 1e-20,
        print.level = 3, # Print estimation details
        iterlim = 1000,
        seed = set_seed # Random seed
    )
})

# Predictions
## Probability predictions
mmnl_covar_pred = predict(
    mmnl_covar, 
    newdata = ml_dataset_covar
)
## Class prediction
Choice = colnames(mmnl_covar_pred)[apply(mmnl_covar_pred, 1, which.max)] 
mmnl_covar_pred = cbind(
        mmnl_covar_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
mmnl_covar_pred = cbind(
        mmnl_covar_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
## Compute effects 
### Covariates
covariates = c(
    "Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon"
)
### Compute effects
mmnl_covar_effects = list()
# for (i in 1:length(covariates)) {
#     mmnl_covar_effects[[i]] = effects(
#         mmnl_covar,
#         covariate = covariates[[i]],
#         # type = "rr", 
#         # data = ml_dataset_novar,
#         print.level = 3
#     )
# }
# names(mmnl_covar_effects) = covariates 

# Clear
mmnl_covar_estimates = list(
    model = mmnl_covar, 
    predictions = mmnl_covar_pred, 
    time = time_mmnl_covar,
    effects = mmnl_covar_effects
)
rm(list = c("mmnl_covar", "mmnl_covar_pred", "time_mmnl_covar", "mmnl_covar_effects")); gc()
## Save
save(
    mmnl_covar_estimates,
    file = "data/memoire/mmnl_covar_estimates.Rdata"
)
## Clear
rm(mmnl_covar_estimates); gc()

# Clean space
rm(ml_dataset_covar); gc()





# ####################
# # Original dataset #
# ####################

# Load dataset
load("data/memoire/data_orig.Rdata")

# Modify data
data_orig$CHID = rep(
    1:(nrow(data_orig)/3), 
    each = 3
)

# Transform to mlogit format
ml_dataset_orig = data_orig %>%
    mutate(
        LC = Label * Carbon
    ) %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
# Clean space
rm(data_orig); gc()

# Function
funct = Choice ~ Sex + Age + Salary + Habit + # Individual
    Price + Buy + Label + Carbon + LC | 0 | 0 # Alternatives

# MNL model
mnl_orig = mlogit(
    funct,
    data = ml_dataset_orig, 
    reflevel = "C", # The No-buy option is the baseline
    print.level = 3, # Print estimation details
    iterlim = 1000,
    seed = set_seed # Random seed
)

# Load dataset
load("data/memoire/data_orig.Rdata")

# Modify data
data_orig$CHID = rep(
    1:(nrow(data_orig)/3), 
    each = 3
)

# Transform to mlogit format
ml_dataset_orig = data_orig %>%
    mutate(
        LC = Label * Carbon
    ) %>%
    mlogit.data(
        choice = "Choice",
        alt.var = "Alternative",
        id = "ID",
        chid = "CHID",
        shape = "long",
        alt.levels = c("C", "A", "B")
        # chid.var = "CS"
    )
# Clean space
rm(data_orig); gc()

# MMNL model
mmnl_orig = mlogit(
    funct,
    data = ml_dataset_orig, 
    reflevel = "C", # The No-buy option is the baseline
    correlation = TRUE, # Include covariance (and not variance only)
    rpar =  c( # Normality assumption and four parameters
        "Buy" = "n", 
        "Label" = "n", 
        "Carbon" = "n", 
        "LC" = "n"
    ),
    R = 100, halton = NA,
    # id.var = "ID",
    panel = TRUE,
    # method = "nr", # "bfgs", "nr" (produces error), "bhhh" (does not converge)
    ftol = 1e-20,
    print.level = 3, # Print estimation details
    iterlim = 1000,
    seed = set_seed # Random seed
)

# The results are different from the original => Different procedure was implemented !
mnls_orig = list(
    mnl = mnl_orig,
    mmnl = mmnl_orig
)
# Save results
save(mnls_orig, file = "data/memoire/mnls_orig.Rdata")


##########################
# Prepare Summary tables #
##########################



#############
# Clear all #
#############

rm(list = ls()); gc()