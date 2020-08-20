# ########################################
# # Testing of the models' specification #
# ########################################



# ########################
# # Logistic regressions #
# ########################

# # Packages loading
# library(tidyverse)
# library(mlogit)
# library(nnet)

# # Data loading 
# data("TravelMode", package = "AER")

# ###################
# # First testing set (not interesting)
# ###################

# # Conditional MNL model
# cond = mlogit(
#     choice ~ travel + wait,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Pure MNL
# pure = mlogit(
#     choice ~ | income,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Mixed MNL
# mixed = mlogit(
#     choice ~ travel + wait | income,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# ####################
# # Second testing set (interesting: pure2 vs all)
# #################### 

# # Conditional MNL model
# cond2 = mlogit(
#     choice ~ travel + wait,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Conditional MNL model - Variance & Covariance
# cond2_vc = mlogit(
#     choice ~ travel + wait,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     rpar = c(
#         travel = "n", 
#         wait = "n"
#     ),
#     correlation = TRUE,
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Pure MNL
# pure2 = mlogit(
#     choice ~ 0 | travel + wait,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Mixed MNL
# mixed2 = mlogit(
#     choice ~ travel | wait,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 3, 
#     iterlim = 50
# )

# # Summaries
# summary(cond2)
# summary(pure2)
# summary(mixed2)







# ###################
# # Neural Networks #
# ###################

# # Packages loading
# library(tidyverse) # Here it appears second time !
# library(nnet) # One version
# library(neuralnet) # Another version

# # Data loading
# data("TravelMode", package = "AER")

# ###############
# # First testing
# ###############

# # Data preparation
# dataset = pivot_wider(
#     TravelMode,
#     names_from = mode, 
#     values_from = c("wait", "vcost", "travel", "gcost", "choice"), 
#     names_sep = "_"
# )
# dataset = dataset %>%
#     mutate(dummy = rep(1, 210))

# # Function definition
# funct = choice_air ~
#     travel_air + travel_train + travel_bus + dummy

# # Model evaluation
# ## Logistic (true mnl model)
# mnl = mlogit(
#     choice ~ 0 | travel,
#     TravelMode, 
#     reflevel = "car", 
#     choice = "choice",
#     shape = "long", 
#     alt.var = "mode",
#     print.level = 0, 
#     iterlim = 50
# )
# ## Neural networks
# nn = neuralnet(
#     funct, 
#     data = dataset, # or scale(dataset) to normalize data
#     hidden = 0, # Number of neurons per hidden layer
#     stepmax = 50,
#     rep = 1,
#     act.fct = "logistic",
#     linear.output = FALSE,
#     algorithm = "backprop",
#     learningrate = 5
# ) 

# # Plot results
# plot(nn)







####################
# Model pentesting # FIRST
####################

# Loading packages
library(tidyverse)
library(stargazer)
library(mlogit)
library(mclogit)
library(nnet)

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv")
# dataset = load("../../../../data/simulation/dataset.Rdata") 

# Data adaptation

# Renaming
names(dataset)[2] = "Set"

# Clearing and modifying 
dataset = dataset %>%
    select(
        ID, Set, Sex, Habit, Salary, 
        Age, Price, Label, Carbon, Choice
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        # Sex = as.logical(Sex),
        # Habit = as.logical(Habit),
        # Salary = as.factor(Salary),
        # Price = Price,
        # LC = as.logical(Label * Carbon),
        # Label = as.logical(Label),
        # Carbon = as.logical(Carbon),
        # Choice = as.logical(Choice)
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), length = nrow(dataset))
    )

# Verify choices
dverif = dataset %>%
    group_by(ID, Set) %>%
    summarize(
        Choice = sum(as.integer(Choice))
    ) %>%
    arrange(ID, Set)

# Subset creation for "no choice"
dsubset = dataset %>%
    distinct(
        ID, Set, Sex, Habit, Salary, Age
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 0,
        Sex = Buy * Sex,
        Habit = Buy * Habit,
        Salary = Buy * Salary,
        Age = Buy * Age,
        # Sex = Sex,
        # Habit = Habit,
        # Salary = Salary,
        # Age = Age,
        Price = 0,
        Alternative = "C",
        # Label = FALSE,
        # Carbon = FALSE, 
        # LC = FALSE,
        # Choice = logical(dverif$Choice == FALSE)
        Label = 0,
        Carbon = 0, 
        LC = 0,
        Choice = as.integer(dverif$Choice == FALSE)
    ) 

# Merge with original dataset and arrange
dataset = full_join(dataset, dsubset) %>%
    arrange(ID, Set) %>%
    mutate(
        Alternative = as.factor(Alternative)
    )
dataset$CS = rep(1:(nrow(dataset)/3), each = 3)
# Clear space
rm(dverif, dsubset)

# Function
funct = Choice ~ Sex + Age + Salary + Habit + 
    Price + 
    Buy + Label + Carbon + I(Label * Carbon) | 0

# Model Evaluation
mnl_reg = mlogit(
    funct,
    data = dataset, 
    choice = "Choice", # Column of choice binary
    # reflevel = "C",
    shape = "long", 
    alt.var = "Alternative", # Column of alternatives
    print.level = 3, 
    iterlim = 50
)

# Function
funct_2 = cbind(Choice, CS) ~ Sex + Age + Salary + Habit + 
    Price +
    Buy + Label + Carbon + I(Label * Carbon) + 0

# Model Evaluation
mnl_reg_2 = mclogit(
    funct_2,
    data = dataset, 
    # choice = "Choice", # Column of choice binary
    # reflevel = "C",
    # shape = "long", 
    # alt.var = "Alternative", # Column of alternatives
    # print.level = 3, 
    # iterlim = 50
) 
# Insufficient within-choice set variance

# Function
dataset$Alternative = relevel(
    dataset$Alternative, 
    ref = "C"
)
funct_3 = Alternative ~ Sex + Age + Salary + Habit + 
    Price + 
    Buy + Label + Carbon + I(Label * Carbon) + 0

# Multinom version
mnl_reg_3 = multinom(
    funct_3, 
    data = dataset
)

# Summary 
summary(mnl_reg)
summary(mnl_reg_2) # Two first examples give identical values
summary(mnl_reg_3) # Calculates separe coefficients for different alternatives, even though they are specified as identical 

# Original coefficients
orig_coef = data.frame(
    Sex = c(1.420, 0.399),
    Age = c(0.009, 0.010),
    Salary = c(0.057, 0.159),
    Habit = c(1.027, 0.323),
    Price = c(-1.631, 0.130),
    Buy = c(2.285, 0.743),
    Label = c(2.824, 0.318),
    Carbon = c(6.665, 1.328),
    LC = c(-2.785, 1.290)
) %>% t()

# Compare
compare = data.frame(
    Coef = orig_coef[,1] / as.vector(mnl_reg$coef)
)









####################
# Model pentesting # SECOND
####################

# Loading packages
library(tidyverse)
library(stargazer)
library(mlogit) # v1
library(mclogit) # v2
library(nnet) # v3
library(survival) # v4

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv")
# dataset = load("../../../../data/simulation/dataset.Rdata") 

# Data adaptation

# Renaming
names(dataset)[2] = "Set"

# Clearing and modifying 
dataset = dataset %>%
    select(
        ID, Set, Sex, Habit, Salary, 
        Age, Price, Label, Carbon, Choice
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        # Sex = as.logical(Sex),
        # Habit = as.logical(Habit),
        # Salary = as.factor(Salary),
        # Price = Price,
        # LC = as.logical(Label * Carbon),
        # Label = as.logical(Label),
        # Carbon = as.logical(Carbon),
        # Choice = as.logical(Choice)
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), length = nrow(dataset))
    )

# Verify choices
dverif = dataset %>%
    group_by(ID, Set) %>%
    summarize(
        Choice = sum(as.integer(Choice))
    ) %>%
    arrange(ID, Set)

# Subset creation for "no choice"
dsubset = dataset %>%
    distinct(
        ID, Set, Sex, Habit, Salary, Age
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 0,
        # Sex = Buy * Sex,
        # Habit = Buy * Habit,
        # Salary = Buy * Salary,
        # Age = Buy * Age,
        Sex = Sex,
        Habit = Habit,
        Salary = Salary,
        Age = Age,
        Price = 0,
        Alternative = "C",
        # Label = FALSE,
        # Carbon = FALSE, 
        # LC = FALSE,
        # Choice = logical(dverif$Choice == FALSE)
        Label = 0,
        Carbon = 0, 
        LC = 0,
        Choice = as.integer(dverif$Choice == FALSE)
    ) 

# Merge with original dataset and arrange
dataset = full_join(dataset, dsubset) %>%
    arrange(ID, Set) %>%
    mutate(
        Alternative = as.factor(Alternative)
    )
dataset$CS = rep(1:(nrow(dataset)/3), each = 3)
# Clear space
rm(dverif, dsubset)

# Function
funct = Choice ~ Sex + Age + Salary + Habit + 
    Price + 
    Buy + Label + Carbon + I(Label * Carbon) | 0

# funct = Choice ~ Price + 
#     Buy + Label + Carbon + I(Label * Carbon) | 0 + Sex + Age + Salary + Habit

# Model Evaluation
mnl_reg = mlogit(
    funct,
    data = dataset, 
    choice = "Choice", # Column of choice binary
    reflevel = "C",
    shape = "long", 
    alt.var = "Alternative", # Column of alternatives
    print.level = 3, 
    iterlim = 50, 
    seed = 2020
)
# SINGULARITY ERROR : Lapack dgesv : le système est exactement singulier : U[1,1] = 0

# Function
funct_2 = cbind(Choice, CS) ~ Sex + Age + Salary + Habit + 
    Price +
    Buy + Label + Carbon + I(Label * Carbon) + 0

# Model Evaluation
mnl_reg_2 = mclogit(
    funct_2,
    data = dataset, 
    # choice = "Choice", # Column of choice binary
    # reflevel = "C",
    # shape = "long", 
    # alt.var = "Alternative", # Column of alternatives
    # print.level = 3, 
    # iterlim = 50
) 
# Insufficient within-choice set variance
# ESTIMATION ERROR : removing Sex,Age,Salary,Habit from model due to insufficient within-choice set variance

# Function
dataset$Alternative = relevel(
    dataset$Alternative, 
    ref = "C"
)
funct_3 = Alternative ~ Sex + Age + Salary + Habit + 
    Price + 
    Buy + Label + Carbon + I(Label * Carbon) + 0

# Multinom version
mnl_reg_3 = multinom(
    funct_3, 
    data = dataset
)

# Function
funct_4 = Choice ~ Price + 
    Buy + Label + Carbon + LC + 0 | Sex + Age + Salary + Habit + 0 

# Adjust dataset
ml_dataset = dataset %>%
    mlogit.data(
        choice = "Choice",
        shape = "long",
        alt.levels = c("A", "B", "C"), 
        chid.var = "CS"
    )

# Clogit regression
mnl_reg_4 = mlogit(
    funct_4, 
    data = ml_dataset,
    reflevel = "C",
    corr = TRUE,
    rpar = c(
        Buy = "n",
        Label = "n",
        Carbon = "n",
        LC = "n"
    )
)

# SETTING INDIVIDUAL CHARACTERISTICS TO 0 FOR C DOES NOT AFFECT ESTIMATION RESSULTS UNDER CORRECT SPECIFICATION ? 

# Summary 
summary(mnl_reg)
summary(mnl_reg_2)
summary(mnl_reg_3)
summary(mnl_reg_4)







####################
# Model pentesting # THIRD
####################

# Loading packages
library(tidyverse)
library(stargazer)
library(mlogit)
library(mclogit)
library(nnet)

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv")
# dataset = load("../../../../data/simulation/dataset.Rdata") 

# Data adaptation

# Renaming
names(dataset)[2] = "Set"

# Clearing and modifying 
dataset = dataset %>%
    select(
        ID, Set, Sex, Habit, Salary, 
        Age, Price, Label, Carbon, Choice
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        # Sex = as.logical(Sex),
        # Habit = as.logical(Habit),
        # Salary = as.factor(Salary),
        # Price = Price,
        # LC = as.logical(Label * Carbon),
        # Label = as.logical(Label),
        # Carbon = as.logical(Carbon),
        # Choice = as.logical(Choice)
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), length = nrow(dataset))
    )

# Verify choices
dverif = dataset %>%
    group_by(ID, Set) %>%
    summarize(
        Choice = sum(as.integer(Choice))
    ) %>%
    arrange(ID, Set)

# Subset creation for "no choice"
dsubset = dataset %>%
    distinct(
        ID, Set, Sex, Habit, Salary, Age
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 0,
        Sex = Buy * Sex,
        Habit = Buy * Habit,
        Salary = Buy * Salary,
        Age = Buy * Age,
        # Sex = Sex,
        # Habit = Habit,
        # Salary = Salary,
        # Age = Age,
        Price = 0,
        Alternative = "C",
        # Label = FALSE,
        # Carbon = FALSE, 
        # LC = FALSE,
        # Choice = logical(dverif$Choice == FALSE)
        Label = 0,
        Carbon = 0, 
        LC = 0,
        Choice = as.integer(dverif$Choice == FALSE)
    ) 

# Merge with original dataset and arrange
dataset = full_join(dataset, dsubset) %>%
    arrange(ID, Set) %>%
    mutate(
        Alternative = as.factor(Alternative)
    )
dataset$CS = rep(1:(nrow(dataset)/3), each = 3)
# Clear space
rm(dverif, dsubset)

# Function
funct = Choice ~ Sex + Age + Salary + Habit + 
    Price + 
    Buy + Label + Carbon + I(Label * Carbon) | 0

# Model Evaluation
mnl_reg_mix = mlogit(
    funct,
    data = dataset, 
    choice = "Choice", # Column of choice binary
    # reflevel = "C",
    shape = "long", 
    alt.var = "Alternative", # Column of alternatives
    correlation = TRUE,
    rpar =  c(
        "Buy" = "n", 
        "Label" = "n", 
        "Carbon" = "n", 
        "I(Label * Carbon)" = "n"),
    print.level = 3, 
    iterlim = 50
)

# Summary 
summary(mnl_reg_mix)