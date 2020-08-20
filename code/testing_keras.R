#########################
# Testing NN with Keras #
#########################

# Loading and installation of Keras library
# install.packages("keras")
# keras::install_keras()

# Alternatively
# devtools::install_github("rstudio/tensorflow")
# devtools::install_github("rstudio/keras")

# # Or even as follows
# keras::use_python("~/Documents/PythonVE/bin/python3.7") # This command specifes the path to Python VE

# # Load linrary
# library(keras)
# Sys.setenv(RETICULATE_PYTHON = "~/Documents/PythonVE/bin/python3.7")





# ###########################
# # Minimal Working Example #
# ###########################

# # Load data
# mnist <- dataset_mnist()
# x_train <- mnist$train$x
# y_train <- mnist$train$y
# x_test <- mnist$test$x
# y_test <- mnist$test$y

# # reshape
# x_train <- array_reshape(x_train, c(nrow(x_train), 784))
# x_test <- array_reshape(x_test, c(nrow(x_test), 784))

# # rescale
# x_train <- x_train / 255
# x_test <- x_test / 255

# # transform
# y_train <- to_categorical(y_train, 10)
# y_test <- to_categorical(y_test, 10)

# # Define model
# model <- keras_model_sequential() 
# model %>% 
#     layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
#     layer_dropout(rate = 0.4) %>% 
#     layer_dense(units = 128, activation = 'relu') %>%
#     layer_dropout(rate = 0.3) %>%
#     layer_dense(units = 10, activation = 'softmax')

# # Summary
# summary(model)

# # Compile model
# model %>% compile(
#   loss = 'categorical_crossentropy',
#   optimizer = optimizer_rmsprop(),
#   metrics = c('accuracy')
# )

# # Train model
# history <- model %>% fit(
#   x_train, y_train, 
#   epochs = 30, batch_size = 128, 
#   validation_split = 0.2
# )

# # Plot history
# plot(history)

# # Testing
# model %>% evaluate(x_test, y_test)






###########################
# Modelling Study Choices #
###########################

# Loading support packages
library(keras) # ML library
# Sys.sleep(5)
library(tensorflow) # It rests to define which to use
# Sys.sleep(5)
library(tidyverse) # Data treatment
# Sys.sleep(5)



#################
# Data adaptation
#################

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv")
# dataset = load("../../../../data/simulation/dataset.Rdata") 

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
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), 
        length = nrow(dataset))
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
        Price = 0,
        Alternative = "C",
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
rm(dverif, dsubset)

# # Normalzed version
# ## Make a copy of the initial dataset
# dataset_norm = dataset
# ## Normalization
# dataset_norm[,3:12] = scale(dataset_norm[,3:12])

# Reshape dataframe to wide format (ONE LINE FOR EACH CHOICE SET)
# Data transformation for NN - wide format
dataset_wide = dataset %>%
    # filter(Alternative != "C") %>%
    pivot_wider(
        names_from = Alternative, 
        values_from = c(
            "Choice", 
            "Sex", "Age", "Salary", "Habit",
            "Price", "Buy", "Label", "Carbon", "LC"
        ),
        names_sep = "_"
    ) %>% 
    # This part is not needed ?
    # replace_na(list(
    #         A = 0,
    #         B = 0,
    #         C = 0
    #     )
    # ) %>%
    # Group by alternatives 
    arrange(ID, Set) %>%
    select(
        ID, Set,
        Choice_A, Choice_B, Choice_C,
        Sex_A, Age_A, Salary_A, Habit_A, Price_A, Buy_A, Label_A, Carbon_A, LC_A,
        Sex_B, Age_B, Salary_B, Habit_B, Price_B, Buy_B, Label_B, Carbon_B, LC_B,
        Sex_C, Age_C, Salary_C, Habit_C, Price_C, Buy_C, Label_C, Carbon_C, LC_C,
    )

# Normalized version
# ## Copy objects
# dataset_wide_norm = dataset_wide 
# ## Normalize
# dataset_wide_norm[,c(6:10, 12:19, 21:23)] = scale(dataset_wide_norm[,c(6:10, 12:19, 21:23)])



#####################
# Subsetting datasets
#####################

# Observation number
n = nrow(dataset_wide)
part = 0.8

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
invisible(Y <- to_categorical(Y, 3))

# CONVOLUTION LAYER REQUIRE 2D OR 3D INPUT TENSOR

# Separate train and validation
## Training
X_train = X[train_index, ]
Y_train = Y[train_index, ]
## Testing
X_test = X[test_index, ]
Y_test = Y[test_index, ]



#############################
# Modelisation layer by layer
#############################

# ASSUMING WE USE COMPLETE DATASET
npars = 9

# IT APPEARS TENSORFLOW STILL HAS NOT THIS FUNCTIONNALITY ?
# Setup model
model = keras_model_sequential()
# Precise model definition

## Preparation and reshaping of the dataset 
model %>%
    layer_reshape(
        target_shape = c(27, 1),
        input_shape = 27,
        trainable = FALSE
    )

## First layer (convolution layer)
model %>% 
    # 1D CONVOLUTION LAYER ALLOWS US TO SEPARATE ENTRIES FOR DIFFERENT ALTERNATIVES
    layer_conv_1d(
        filters = 1L, # Dimentions of the output space
        kernel_size = 9L, # Number of parameters
        strides = 9L, # Strides of convolution equal to parameters side
        use_bias = FALSE, 
        activation = "linear", # We want a linear activation function to achieve the same thing as for MNL
        input_shape = c(27, 1),
        trainable = TRUE
    ) 
## Reshaping first layer
model %>% 
    # layer_reshape(
    #     target_shape = c(1, 3),
    #     batch_input_shape = c(3, 1),
    #     trainable = FALSE
    # )
    layer_flatten(
        data_format = "channels_first"
    )

# Define custom layer activation function
# custom_softmax = function(x) {
#     k_softmax(x, -2)
# }
# Define custom softmax 2
softmax_new = function(x) {
    ex = exp(x)
    x = ex / sum(ex)
    return(x)
}

## Second layer (Softmax choice)
model %>%
    layer_dense(
        # input_shape = 3,
        units = 3, # Number of units equal to categories (3 utilities)
        use_bias = FALSE,
        kernel_initializer = "ones",
        trainable = FALSE,
        # activation = "softmax" # Softmax layer (to obtain probabilities)
        # activation = custom_softmax
        activation = softmax_new
    )

## Reshaping second layer
# model %>% 
#     layer_reshape(
#         target_shape = c(3),
#         batch_input_shape = c(3, 1),
#         trainable = FALSE
#     )

# Summary
summary(model)



##########################
# Testing results by layer
##########################

# it may be required to compile the model before

# Get intermidiate results
## Layer to study
layer_name = "reshape_2"
layer_name = "conv1d_2"
layer_name = "flatten_2"
layer_name = "dense_2"
# layer_name = "reshape_21"
## Intermediate
int_layer = keras_model(
    inputs = model$input,
    outputs = get_layer(model, layer_name)$output
)
## Observe output
int_output = predict(
    int_layer,
    X_test
)
## Print
head(int_output[1, , ])
head(int_output)

# THE PROBLEM IS IN DENSE SOFTMAX LAYER SPECIFICATION !!!!



##############################
# Compilation and verification
##############################

# Compile model
model %>% compile(
    loss = "categorical_crossentropy", # Loss function
    # loss = "...", # Loss function
    # optimizer = optimizer_rmsprop(), # Optimizer implemented
    # optimizer = "adam",
    # optimizer = optimizer_sgd(
    #     learning_rate = 0.1
    # ),
    # optimizer = optimizer_adam(
    #     lr = 1e-6, 
    #     beta_1 = 0.9, beta_2 = 0.999,
    #     epsilon = NULL, 
    #     decay = 0, 
    #     amsgrad = FALSE, 
    #     clipnorm = NULL,
    #     clipvalue = NULL
    # ),
    metrics = c("accuracy") # Target metrics
)

# Evaluation
history = model %>% 
    fit(
        X_train, Y_train, 
        epochs = 50, 
        # steps = 0.1,
        batch_size = 4200,
        validation_data = list(X_test, Y_test)
    )

# Plot estimation results
plot(history)

# Testing
## Evaluate on testing
model %>% evaluate(X_test, Y_test)
## Results prediction
res_test = model %>% 
    # predict_classes(
    #     X_test, 
    #     verbose = 1
    # ) %>% 
    predict(
        X_train, 
        verbose = 1
    )
# Get weights
get_weights(model)
# Observe predicted probabilities
round(head(res_test, 10), 4)
head(Y_test, 10)

# Install prep packages
# devtools::install_github("andrie/deepviz")
# library(deepviz)

# # Plot
# plot_model(
#     model,  
#     to_file = "model_2.png",
#     show_shapes = TRUE,
#     show_layer_names = TRUE
# ) 