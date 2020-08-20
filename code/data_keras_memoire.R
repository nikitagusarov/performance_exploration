#######################################
# Keras modelling - NN implementation #
#######################################





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





####################
# Preset variables #
####################

# Create cluster
registerDoParallel(cores = 6)

# Set testing vs training separation
part = 0.8 # 80% for training

# Define optimizer
adam_own = optimizer_adam(
    lr = 1e-1, 
    beta_1 = 0.9, 
    beta_2 = 0.999,
    epsilon = NULL, 
    decay = 0, 
    amsgrad = FALSE, 
    clipnorm = 6,
    clipvalue = NULL
)

# Choice of optimisation metrics
loss_function = "categorical_crossentropy"
metrics_choice = c("accuracy")

# Set hyperparameters 
epoch = 50
batch = 16000





# ##########################
# # Marg dataframe support #
# ##########################

# # Dataset aux
# ## Individuals 
# individuals = list(
#         Sex = 0:1,
#         Age = seq(18, 84, 6), # Age with step 6, assuming continuous
#         Salary = 1:6,
#         Habit = 0:1
#     ) %>%
#     expand.grid()
# individuals_full = cbind(individuals, individuals, individuals)
# colnames(individuals_full) = c(
#     paste0(colnames(individuals), "_A"), 
#     paste0(colnames(individuals), "_B"), 
#     paste0(colnames(individuals), "_C")
# )
# ## Alternatives 
# alternatives = list(
#         Price_A = c(1.5, 2, 2.5, 3, 3.5, 4, 4.5),
#         Buy_A = 1,
#         Label_A = 0:1,
#         Carbon_A = 0:1, 
#         Price_B = c(1.5, 2, 2.5, 3, 3.5, 4, 4.5),
#         Buy_B = 1,
#         Label_B = 0:1,
#         Carbon_B = 0:1,
#         Price_C = 0,
#         Buy_C = 0,
#         Label_C = 0,
#         Carbon_C = 0
#     ) %>%
#     expand.grid()

# # Generate dataset
# data_testing = foreach (i = 1:nrow(individuals_full), .combine = rbind) %dopar% {
#     # Create aux df
#     ## Preparation
#     set = as.data.frame(
#         matrix(0, nrow = nrow(alternatives), ncol = ncol(individuals_full))
#     )
#     ## Rename
#     colnames(set) = colnames(individuals_full)
#     ## Filling
#     for (j in 1:nrow(alternatives)) {
#         set[j, 1:12] = individuals_full[i, 1:12]
#     }
#     ## Merging 
#     X_stat = cbind(set, alternatives)

#     # Output
#     return(X_stat)
# } 

# # Mutate dataset 
# data_testing = data_testing %>%
#     mutate(
#         LC_A = Label_A * Carbon_A,
#         LC_B = Label_B * Carbon_B,
#         LC_C = 0
#     ) %>%  
#     select(
#         Sex_A, Age_A, Salary_A, Habit_A, Price_A, Buy_A, Label_A, Carbon_A, LC_A,
#         Sex_B, Age_B, Salary_B, Habit_B, Price_B, Buy_B, Label_B, Carbon_B, LC_B,
#         Sex_C, Age_C, Salary_C, Habit_C, Price_C, Buy_C, Label_C, Carbon_C, LC_C
#     ) %>% 
#     as.matrix()

# # Save results 
# save(data_testing, file ="data/memoire/data_testing.Rdata")

# # Clean 
# rm(list = c("alternatives", "individuals", "individuals_full")); gc()





#############################
# Modelisation layer by layer
#############################

# Preset softmax weights 
softmax_weights = list(
    matrix(
        c(  1,  0,  0,
            0,  1,  0,
            0,  0,  1), 
        nrow = 3
    )
)

# Setup CNN model
model_cnn = keras_model_sequential() %>%
    layer_reshape(
        target_shape = c(27, 1),
        input_shape = 27,
        trainable = FALSE
    ) %>% 
    # 1D CONVOLUTION LAYER ALLOWS US TO SEPARATE ENTRIES FOR DIFFERENT ALTERNATIVES
    layer_conv_1d(
        filters = 1L, # Dimentions of the output space
        kernel_size = 9L, # Number of parameters
        strides = 9L, # Strides of convolution equal to parameters side
        kernel_initializer = "zeros",
        use_bias = FALSE, 
        activation = "linear", # We want a linear activation function to achieve the same thing as for MNL
        input_shape = c(27, 1),
        trainable = TRUE
    ) %>% 
    layer_flatten(
        data_format = "channels_first"
    ) %>%
    layer_dense(
        units = 3, # Number of units equal to categories (3 utilities)
        use_bias = FALSE,
        weights = softmax_weights,
        # kernel_initializer = "ones",
        trainable = FALSE,
        activation = "softmax" # Softmax layer (to obtain probabilities)
    ) %>% 
    compile(
        loss = loss_function,
        optimizer = adam_own,
        metrics = metrics_choice # Target metrics
    )





#########################
# Fixed effects dataset #
#########################

#######################
# Dataset preparation #
#######################

# Load dataset
load("data/memoire/data_novar.Rdata")

# Load dataset 
dataset_wide = data_novar %>%
    # filter(Alternative != "C") %>%
    pivot_wider(
        names_from = Alternative, 
        values_from = c(
            "Choice", 
            "Sex", "Age", "Salary", "Habit",
            "Price", "Buy", "Label", "Carbon", "LC",
            "SU", "AU", "UU", "TU"
        ),
        names_sep = "_"
    ) %>% 
    arrange(ID, Set) %>%
    select(
        ID, Set,
        Choice_A, Choice_B, Choice_C,
        Sex_A, Age_A, Salary_A, Habit_A, Price_A, Buy_A, Label_A, Carbon_A, LC_A,
        Sex_B, Age_B, Salary_B, Habit_B, Price_B, Buy_B, Label_B, Carbon_B, LC_B,
        Sex_C, Age_C, Salary_C, Habit_C, Price_C, Buy_C, Label_C, Carbon_C, LC_C,
    )

#####################
# Subsetting datasets
#####################

# Observation number
n = nrow(dataset_wide)

# Separate valdation set
train_index = sample(1:n, part * n)
test_index = setdiff(1:n, train_index)

# Separate explicative and modelled variables
## Regressors
X = dataset_wide[, 6:dim(dataset_wide)[2]] %>%
    as.matrix()
## Output
Y = dataset_wide[, 3:5]
Y = colnames(Y)[apply(Y, 1, which.max)] %>%
    as.factor() %>%
    as.numeric() - 1 # Python factors are 0 based contrary to R 
Y = to_categorical(Y, 3) # Python style transformation

# Separate train and validation
## Training
X_train = X[train_index, ]
Y_train = Y[train_index, ]
## Testing
X_test = X[test_index, ]
Y_test = Y[test_index, ]

####################
# Model estimation #
####################

# Reset model
model_cnn_novar = model_cnn

# Evaluation

time_cnn_novar = system.time({
    history_cnn_novar = model_cnn_novar %>% 
        fit(
            X_train, Y_train, 
            epochs = epoch, # The number of epochs is a hyperparameter that defines the number times that the learning algorithm will work through the entire training dataset.
            # steps = 0.1,
            batch_size = batch, # The batch size is a hyperparameter that defines the number of samples to work through before updating the internal model parameters.
            # Batch Gradient Descent. Batch Size = Size of Training Set
            validation_data = list(X_test, Y_test)
        )
})

###############
# Predictions #
###############

# Predict
Y_pred = model_cnn_novar %>% 
    predict(X)

# Names
colnames(Y_pred) = c("A", "B", "C")

# Organise resulting dataframe
## Class prediction
Choice = colnames(Y_pred)[apply(Y_pred, 1, which.max)] 
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
## Bind all
Y_pred = cbind(
        Y_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
Y_pred = cbind(
        Y_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Real = ordered(
            Real, 
            levels = c("C", "A", "B")
        )
    )

###################
# Organise output #
###################

# Results
cnn_novar_estimates = list(
    # model = model_cnn_novar, 
    predictions = Y_pred,
    time = time_cnn_novar, 
    history = history_cnn_novar,
    weights = get_weights(model_cnn_novar)
)

# Save results 
save(cnn_novar_estimates, file = "data/memoire/cnn_novar_estimates.Rdata")

# Cat
cat(
    "\n",
    paste(
        unlist(get_weights(model_cnn_novar)),
        collapse = "\n"
    ),
    "\n\n"
)

# Clean
rm(data_novar); gc()





##########################
# Random effects dataset #
##########################

#######################
# Dataset preparation #
#######################

# Load dataset
load("data/memoire/data_covar.Rdata")

# Load dataset 
dataset_wide = data_covar %>%
    # filter(Alternative != "C") %>%
    pivot_wider(
        names_from = Alternative, 
        values_from = c(
            "Choice", 
            "Sex", "Age", "Salary", "Habit",
            "Price", "Buy", "Label", "Carbon", "LC",
            "SU", "AU", "UU", "TU"
        ),
        names_sep = "_"
    ) %>% 
    arrange(ID, Set) %>%
    select(
        ID, Set,
        Choice_A, Choice_B, Choice_C,
        Sex_A, Age_A, Salary_A, Habit_A, Price_A, Buy_A, Label_A, Carbon_A, LC_A,
        Sex_B, Age_B, Salary_B, Habit_B, Price_B, Buy_B, Label_B, Carbon_B, LC_B,
        Sex_C, Age_C, Salary_C, Habit_C, Price_C, Buy_C, Label_C, Carbon_C, LC_C,
    )

#####################
# Subsetting datasets
#####################

# Observation number
n = nrow(dataset_wide)

# Separate valdation set
train_index = sample(1:n, part * n)
test_index = setdiff(1:n, train_index)

# Separate explicative and modelled variables
## Regressors
X = dataset_wide[, 6:dim(dataset_wide)[2]] %>%
    as.matrix()
## Output
Y = dataset_wide[, 3:5]
Y = colnames(Y)[apply(Y, 1, which.max)] %>%
    as.factor() %>%
    as.numeric() - 1 # Python factors are 0 based contrary to R 
Y = to_categorical(Y, 3) # Python style transformation

# Separate train and validation
## Training
X_train = X[train_index, ]
Y_train = Y[train_index, ]
## Testing
X_test = X[test_index, ]
Y_test = Y[test_index, ]

####################
# Model estimation #
####################

# Reset model
model_cnn_covar = model_cnn

# Evaluation

time_cnn_covar = system.time({
    history_cnn_covar = model_cnn_covar %>% 
        fit(
            X_train, Y_train, 
            epochs = epoch, # The number of epochs is a hyperparameter that defines the number times that the learning algorithm will work through the entire training dataset.
            # steps = 0.1,
            batch_size = batch, # The batch size is a hyperparameter that defines the number of samples to work through before updating the internal model parameters.
            # Batch Gradient Descent. Batch Size = Size of Training Set
            validation_data = list(X_test, Y_test)
        )
})

###############
# Predictions #
###############

# Predict
Y_pred = model_cnn_covar %>% 
    predict(X)

# Names
colnames(Y_pred) = c("A", "B", "C")

# Organise resulting dataframe
## Class prediction
Choice = colnames(Y_pred)[apply(Y_pred, 1, which.max)] 
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
## Bind all
Y_pred = cbind(
        Y_pred, 
        Choice
    ) %>% 
    as.data.frame() %>%
    mutate(
        Choice = ordered(
            Choice, 
            levels = c("C", "A", "B")
        )
    )
Y_pred = cbind(
        Y_pred, 
        Real = Real$Alternative
    ) %>% 
    as.data.frame() %>%
    mutate(
        Real = ordered(
            Real, 
            levels = c("C", "A", "B")
        )
    )

###################
# Organise output #
###################

# Results
cnn_covar_estimates = list(
    # model = model_cnn_covar, 
    predictions = Y_pred,
    time = time_cnn_covar, 
    history = history_cnn_covar,
    weights = get_weights(model_cnn_covar)
)

# Save results 
save(cnn_covar_estimates, file = "data/memoire/cnn_covar_estimates.Rdata")

# Cat
cat(
    "\n",
    paste(
        unlist(get_weights(model_cnn_covar)),
        collapse = "\n"
    ),
    "\n\n"
)

# Clean
rm(data_covar); gc()

# # Plots 
# dataset %>%
#     as.data.frame() %>%
#     ggplot(aes(y = Choice_B, x = Label_A)) + 
#     stat_summary(
#         geom = "ribbon", 
#         fun.data = mean_cl_normal, 
#         # width = 0.1, 
#         # conf.int = 0.95, 
#         fill = "lightblue"
#     ) +
#     stat_summary(
#         geom = "line", 
#         fun = mean, 
#         linetype = "dashed"
#     ) +
#     stat_summary(
#         geom = "point", 
#         fun = mean, 
#         color = "red"
#     )