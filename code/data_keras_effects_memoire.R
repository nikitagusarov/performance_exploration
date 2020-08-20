################################
# Keras modelling - NN effects #
################################





############
# Packages #
############

# Load packages
library(tidyverse)
library(keras)
library(tensorflow)
library(foreach)
library(doParallel)
library(Hmisc)
library(pdp)
library(vip) # for visualizing feature importance





# ########
# # Data #
# ########

# # Load dataset
# load("data/memoire/data_novar.Rdata")

# # Load dataset 
# dataset_wide = data_novar %>%
#     # filter(Alternative != "C") %>%
#     pivot_wider(
#         names_from = Alternative, 
#         values_from = c(
#             "Choice", 
#             "Sex", "Age", "Salary", "Habit",
#             "Price", "Buy", "Label", "Carbon", "LC",
#             "SU", "AU", "UU", "TU"
#         ),
#         names_sep = "_"
#     ) %>% 
#     arrange(ID, Set) %>%
#     select(
#         ID, Set,
#         Choice_A, Choice_B, Choice_C,
#         Sex_A, Age_A, Salary_A, Habit_A, Price_A, Buy_A, Label_A, Carbon_A, LC_A,
#         Sex_B, Age_B, Salary_B, Habit_B, Price_B, Buy_B, Label_B, Carbon_B, LC_B,
#         Sex_C, Age_C, Salary_C, Habit_C, Price_C, Buy_C, Label_C, Carbon_C, LC_C,
#     )





##################
# Fixed effects #
##################

# Load models
load("data/memoire/cnn_novar_estimates.Rdata")

# Get weights 
weights = cnn_novar_estimates$weights[[1]] %>%
    as.vector()

# Get params
wtp_mnl_novar = data.frame(
    Rose = - weights[6] / 
        weights[5],
    Label = - weights[7] /
        weights[5],
    Carbon = - weights[8] /
        weights[5],
    LC = - sum(weights[7:9]) /
        weights[5]
)

# Assign 
cnn_novar_estimates$wtp = wtp_mnl_novar

# Save
save(cnn_novar_estimates, file = "data/memoire/cnn_novar_estimates.Rdata")





##################
# Random effects #
##################

# Load models
load("data/memoire/cnn_covar_estimates.Rdata")

# Get weights 
weights = cnn_covar_estimates$weights[[1]] %>%
    as.vector()

# Get params
wtp_mnl_covar = data.frame(
    Rose = - weights[6] / 
        weights[5],
    Label = - weights[7] /
        weights[5],
    Carbon = - weights[8] /
        weights[5],
    LC = - sum(weights[7:9]) /
        weights[5]
)

# Assign 
cnn_covar_estimates$wtp = wtp_mnl_covar

# Save
save(cnn_covar_estimates, file = "data/memoire/cnn_covar_estimates.Rdata")







#########################
# RMM CNN Fixed effects #
#########################

# Load
load("data/memoire/rrmcnn_novar_estimates.Rdata")

# Layers
layer1 = rrmcnn_novar_estimates$weights[[1]] %>%
    as.matrix()
layer2 = rrmcnn_novar_estimates$weights[[2]]

# Alternatives
## A
alt_a = matrix(
        c(
            layer1 * layer2[1,1],
            layer1 * layer2[2,1],
            layer1 * layer2[3,1]
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_a = data.frame(
    Sex = alt_a[1,4],
    Age = alt_a[2,4],
    Salary = alt_a[3,4],
    Habit = alt_a[4,4],
    Buy = alt_a[6,4],
    Price_A = alt_a[5,1],
    Label_A = alt_a[7,1], 
    Carbon_A = alt_a[8,1], 
    LC_A = alt_a[9,1],
    Price_B = alt_a[5,2], 
    Label_B = alt_a[7,2], 
    Carbon_B = alt_a[8,2], 
    LC_B = alt_a[9,2]
)
## B
alt_b = matrix(
        c(
            layer1 * layer2[1,2],
            layer1 * layer2[2,2],
            layer1 * layer2[3,2]
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_b = data.frame(
    Sex = alt_b[1,4],
    Age = alt_b[2,4],
    Salary = alt_b[3,4],
    Habit = alt_b[4,4],
    Buy = alt_b[6,4],
    Price_A = alt_b[5,1],
    Label_A = alt_b[7,1], 
    Carbon_A = alt_b[8,1], 
    LC_A = alt_b[9,1],
    Price_B = alt_b[5,2], 
    Label_B = alt_b[7,2], 
    Carbon_B = alt_b[8,2], 
    LC_B = alt_b[9,2]
)
## C
alt_c = matrix(
        c(
            layer1 * layer2[1,3],
            layer1 * layer2[2,3],
            layer1 * layer2[3,3] * 0
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_c = data.frame(
    Sex = alt_c[1,4],
    Age = alt_c[2,4],
    Salary = alt_c[3,4],
    Habit = alt_c[4,4],
    Buy = alt_c[6,4],
    Price_A = alt_c[5,1],
    Label_A = alt_c[7,1], 
    Carbon_A = alt_c[8,1], 
    LC_A = alt_c[9,1],
    Price_B = alt_c[5,2], 
    Label_B = alt_c[7,2], 
    Carbon_B = alt_c[8,2], 
    LC_B = alt_c[9,2]
)

# Save results 
effects = list(
    a = effects_a,
    b = effects_b,
    c = effects_c
)
rrmcnn_novar_estimates$effects = effects
save(rrmcnn_novar_estimates, file = "data/memoire/rrmcnn_novar_estimates.Rdata")





##########################
# RMM CNN Random effects #
##########################

# Load
load("data/memoire/rrmcnn_covar_estimates.Rdata")

# Layers
layer1 = rrmcnn_covar_estimates$weights[[1]] %>%
    as.matrix()
layer2 = rrmcnn_covar_estimates$weights[[2]]

# Alternatives
## A
alt_a = matrix(
        c(
            layer1 * layer2[1,1],
            layer1 * layer2[2,1],
            layer1 * layer2[3,1]
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_a = data.frame(
    Sex = alt_a[1,4],
    Age = alt_a[2,4],
    Salary = alt_a[3,4],
    Habit = alt_a[4,4],
    Buy = alt_a[6,4],
    Price_A = alt_a[5,1],
    Label_A = alt_a[7,1], 
    Carbon_A = alt_a[8,1], 
    LC_A = alt_a[9,1],
    Price_B = alt_a[5,2], 
    Label_B = alt_a[7,2], 
    Carbon_B = alt_a[8,2], 
    LC_B = alt_a[9,2]
)
## B
alt_b = matrix(
        c(
            layer1 * layer2[1,2],
            layer1 * layer2[2,2],
            layer1 * layer2[3,2]
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_b = data.frame(
    Sex = alt_b[1,4],
    Age = alt_b[2,4],
    Salary = alt_b[3,4],
    Habit = alt_b[4,4],
    Buy = alt_b[6,4],
    Price_A = alt_b[5,1],
    Label_A = alt_b[7,1], 
    Carbon_A = alt_b[8,1], 
    LC_A = alt_b[9,1],
    Price_B = alt_b[5,2], 
    Label_B = alt_b[7,2], 
    Carbon_B = alt_b[8,2], 
    LC_B = alt_b[9,2]
)
## C
alt_c = matrix(
        c(
            layer1 * layer2[1,3],
            layer1 * layer2[2,3],
            layer1 * layer2[3,3] * 0
        ),
        ncol = 3,
        byrow = FALSE
    ) %>% 
    as.data.frame() %>%
    mutate(
        sum = V1 + V2 + V3
    )
effects_c = data.frame(
    Sex = alt_c[1,4],
    Age = alt_c[2,4],
    Salary = alt_c[3,4],
    Habit = alt_c[4,4],
    Buy = alt_c[6,4],
    Price_A = alt_c[5,1],
    Label_A = alt_c[7,1], 
    Carbon_A = alt_c[8,1], 
    LC_A = alt_c[9,1],
    Price_B = alt_c[5,2], 
    Label_B = alt_c[7,2], 
    Carbon_B = alt_c[8,2], 
    LC_B = alt_c[9,2]
)

# Save results 
effects = list(
    a = effects_a,
    b = effects_b,
    c = effects_c
)
rrmcnn_covar_estimates$effects = effects
save(rrmcnn_covar_estimates, file = "data/memoire/rrmcnn_covar_estimates.Rdata")