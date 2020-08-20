####################
# Model pentesting # SECOND
####################

# Loading packages
library(tidyverse)
library(foreign)
library(stargazer)
library(mlogit) # v1
library(mclogit) # v2
library(nnet) # v3
library(survival) # v4







##################
# Original dataset
##################

# Read Stata file
data_orig = read.dta("data/roses/r.dta") 

# Modify dataset
data_orig = data_orig %>%
    mutate(
        LC = label * carbon,
        buy_organic_nofood = buy_organic_nofood - 1,
        buy_organic = (buy_organic - min(buy_organic)) / 
            (max(buy_organic) - min(buy_organic)),
        Data = "Original",
        Alternative = ifelse(a == 1, "A",
            ifelse(b == 1, "B",
                "C"
            )
        )
    ) %>%
    select(
        ID = id,
        Set = set,
        Sex = sex,
        Habit = buy_organic_nofood,
        Salary = income,
        Age = age,
        Price = price,
        Label = label,
        Carbon = carbon,
        Choice = choice,
        Buy = buy,
        LC,
        Data,
        Alternative
    )

# # Testing
# data_orig_2 = data_orig %>%
#     filter(
#         Alternative != "C"
#     ) %>%
#     mutate(
#         PriceX = as.factor(Price)
#     )
# test = tableby(
#     Alternative ~ ., 
#     data = data_orig_2
# )
# summary(test)



###################
# Resulting dataset
###################

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv") 

# Clearing and modifying 
dataset = dataset %>%
    select(
        ID, Set = Choice_set, Sex, Habit, Salary, 
        Age, Price, Label, Carbon, Choice
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), 
        length = nrow(dataset))
    )

# Auxilaty
## Verify choices
dverif = dataset %>%
    group_by(ID, Set) %>%
    summarize(
        Choice = sum(as.integer(Choice))
    ) %>%
    arrange(ID, Set)
## Subset creation for "no choice"
dsubset = dataset %>%
    distinct(
        ID, Set, Sex, Habit, Salary, Age
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 0,
        Sex = Sex,
        Habit = Habit,
        Salary = Salary,
        Age = Age,
        # Sex = Buy * Sex,
        # Habit = Buy * Habit,
        # Salary = Buy * Salary,
        # Age = Buy * Age,
        Price = 0,
        Alternative = "C",
        Label = 0,
        Carbon = 0, 
        LC = 0,
        Choice = as.integer(dverif$Choice == FALSE)
    ) 
## Merge with original dataset and arrange
dataset = full_join(dataset, dsubset) %>%
    arrange(ID, Set) %>%
    mutate(
        Alternative = as.factor(Alternative),
        Data = "Generated"
    ) %>% 
    select(
        ID,
        Set,
        Sex,
        Habit,
        Salary,
        Age,
        Price,
        Label,
        Carbon,
        Choice,
        Buy,
        LC,
        Data,
        Alternative
    )
## Clear environment
rm(dverif, dsubset)



##################
# Combined dataset
##################

# COMPLETE DATASET

# Combine dataframez full
combined_data_full = full_join(
        dataset,
        data_orig
    ) %>% 
    na.omit %>%
    mutate(
        Data = as.factor(Data),
        Alternative = as.factor(Alternative),
        NoBuy = ifelse(Buy == 1, 0, 1),
        Buy = ifelse(Buy == 1, 1, 0)
    ) %>%
    arrange(
        Data, ID, Set
    )
combined_data_full$CS = rep(1:(nrow(combined_data_full)/3), each = 3)

# Verification (that there were always some choices made)
# ver = combined_data_full %>%
#     group_by(Data, ID, Set) %>%
#     summarize(Choice = max(Choice)) 
# unique(ver$Choice)

# Combine dataframez empty 
combined_data_empty = combined_data_full
## Emptying
combined_data_empty[combined_data_empty$Alternative == "C", ] = 
    combined_data_empty[combined_data_empty$Alternative == "C", ] %>%
    mutate(
        Sex = 0,
        Age = 0,
        Salary = 0,
        Habit = 0
    )

# SUBSETTING AND ADJUSTEMENT

# Adjust dataset and subset full
## Original
ml_dataset_original_full = combined_data_full %>%
    filter(Data == "Original") %>%
    mlogit.data(
        choice = "Choice",
        shape = "long",
        alt.levels = c("A", "B", "C"), 
        chid.var = "CS"
    )
## Generated
ml_dataset_generated_full = combined_data_full %>%
    filter(Data == "Generated") %>%
    mlogit.data(
        choice = "Choice",
        shape = "long",
        alt.levels = c("A", "B", "C"), 
        chid.var = "CS"
    )

# Adjust dataset and subset empty
## Original
ml_dataset_original_empty = combined_data_empty %>%
    filter(Data == "Original") %>%
    mlogit.data(
        choice = "Choice",
        shape = "long",
        alt.levels = c("A", "B", "C"), 
        chid.var = "CS"
    )
## Generated
ml_dataset_generated_empty = combined_data_empty %>%
    filter(Data == "Generated") %>%
    mlogit.data(
        choice = "Choice",
        shape = "long",
        alt.levels = c("A", "B", "C"), 
        chid.var = "CS"
    )







##################
# Model estimation
##################

# FORMULA SPECIFICATION GUIDELINES (for mlogit)
# - first one contains the alternative specific variables with generic coefficient, i.e. a unique coefficient for all the alternatives (one common coefficient for all cases - what we seek) ; 
# - the second one contains the individual specific variables for which one coefficient is estimated for all the alternatives except one of them (one coefficient for each separate alternative except for the baseline) ; 
# - the third one contains the alternative specific variables with alternative specific coefficients (one coefficient for each alternative including baseline - we don't use this part). 
# The different parts are separeted by a | sign.

# ################################
# # FIRST TEST (ORIGINAL + C FULL)
# ################################

# # Function
# # funct = Choice ~ Sex + Age + Salary + Habit + 
# #     Price + Buy + Label + Carbon + I(Label * Carbon) | 0

# funct = Choice ~ Price + # NoBuy + 
#     Buy + Label + Carbon + I(Label * Carbon) | 0 + Sex + Age + Salary + Habit

# # funct = Choice ~ 0 | Price + # NoBuy + 
# #     Buy + Label + Carbon + I(Label * Carbon) + 0 + Sex + Age + Salary + Habit

# # Model Evaluation
# mnl_reg_1 = mlogit(
#     funct,
#     data = ml_dataset_original_full, 
#     # choice = "Choice", # Column of choice binary
#     reflevel = "C",
#     # shape = "long", 
#     # alt.var = "Alternative", # Column of alternatives
#     # correlation = TRUE,
#     # rpar =  c(
#     #     "Buy" = "n", 
#     #     "Label" = "n", 
#     #     "Carbon" = "n", 
#     #     "I(Label * Carbon)" = "n"),
#     print.level = 3, 
#     iterlim = 50, 
#     seed = 2020
# )

# # Summary
# summary(mnl_reg_1)

#################################
# FIRST TEST (ORIGINAL + C EMPTY)
#################################

# REMINDER ON RANDOM PARAMETERS

# The normal distribution is used to specify the distribution of the random parameters associated with the roses’ attributes.

# four random parameters are to be estimated: 
# - the ‘buy dummy’ variable which captures heterogeneity in consumers’ preferences for a rose, 
# - and the three parameters associated with 
#   - the eco-label, 
#   - the carbon footprint 
#   - their cross-product.

# Function (unique values - no alternative specific coefficients)
funct = Choice ~ Sex + Age + Salary + Habit + # Individual
    Price + Buy + Label + Carbon + LC | 0 | 0 # Alternative (no exact alternative specific effects to estimate)

# The values for individual characteristics for "no buy" alternative are set to 0 
#   - Not setting them to 0 results in "insufficient within set variance" and their omission (in mclogit)
#   - Not setting them results in "singularity error" (for mlogit)
#   - Not setting them to 0 and inputing on second place in formula produces separate estimates for different alternatives (A and B) instead of single estimate for both
# The values for alternatives' attributes for "no buy" alternative are set to 0 
#   - The mlogit package produces error on NA introduction

# Model Evaluation
mnl_reg_2 = mlogit(
    funct,
    data = ml_dataset_original_empty, 
    reflevel = "C", # The No-buy option is the baseline
    correlation = TRUE, # Include covariance (and not variance only)
    rpar =  c( # Normality assumption and four parameters
        "Buy" = "n", 
        "Label" = "n", 
        "Carbon" = "n", 
        "LC" = "n"
    ),
    print.level = 3, # Print estimation details
    iterlim = 50, # iteration limit
    seed = 2020 # Random seed
)

# Summary
## General summary
summary(mnl_reg_2)
## Transform chol decomp to var-cov
summary(vcov(mnl_reg_2, what = "rpar", type = "cov"))

###################################
# SECOND TEST (GENERATED + C EMPTY)
###################################

# Function
funct = Choice ~ Sex + Age + Salary + Habit + 
    Price + Buy + Label + Carbon + LC | 0 | 0

# funct = Choice ~ Price + 
#     Buy + Label + Carbon + I(Label * Carbon) | 0 + Sex + Age + Salary + Habit

# Model Evaluation
mnl_reg_4 = mlogit(
    funct,
    data = ml_dataset_generated_empty, 
    # choice = "Choice", # Column of choice binary
    reflevel = "C",
    # shape = "long", 
    # alt.var = "Alternative", # Column of alternatives
    correlation = TRUE,
    rpar =  c(
        "Buy" = "n", 
        "Label" = "n", 
        "Carbon" = "n", 
        "LC" = "n"
    ),
    unscaled = TRUE,
    print.level = 3, 
    iterlim = 50, 
    seed = 2020
)

# Summary
## General summary
summary(mnl_reg_4)
## Transform chol decomp to var-cov
summary(vcov(mnl_reg_4, what = "rpar", type = "cov"))