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
model_rrmcnn = keras_model_sequential() %>%
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
        # trainable = FALSE,
        # kernel_initializer = "ones",
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
model_rrmcnn_novar = model_rrmcnn

# Evaluation

time_rrmcnn_novar = system.time({
    history_rrmcnn_novar = model_rrmcnn_novar %>% 
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
Y_pred = model_rrmcnn_novar %>% 
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
rrmcnn_novar_estimates = list(
    # model = model_rrmcnn_novar, 
    predictions = Y_pred,
    time = time_rrmcnn_novar, 
    history = history_rrmcnn_novar,
    weights = get_weights(model_rrmcnn_novar)
)

# Save results 
save(rrmcnn_novar_estimates, file = "data/memoire/rrmcnn_novar_estimates.Rdata")

# Cat
cat(
    "\n",
    paste(
        unlist(get_weights(model_rrmcnn_novar)),
        collapse = "\n"
    ),
    "\n"
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
model_rrmcnn_covar = model_rrmcnn

# Evaluation

time_rrmcnn_covar = system.time({
    history_rrmcnn_covar = model_rrmcnn_covar %>% 
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
Y_pred = model_rrmcnn_covar %>% 
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
rrmcnn_covar_estimates = list(
    # model = model_rrmcnn_covar, 
    predictions = Y_pred,
    time = time_rrmcnn_covar, 
    history = history_rrmcnn_covar,
    weights = get_weights(model_rrmcnn_covar)
)

# Save results 
save(rrmcnn_covar_estimates, file = "data/memoire/rrmcnn_covar_estimates.Rdata")

# Cat
cat(
    "\n",
    paste(
        unlist(get_weights(model_rrmcnn_covar)),
        collapse = "\n"
    )
)

# Clean
rm(data_covar); gc()
