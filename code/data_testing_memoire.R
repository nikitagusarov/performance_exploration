###########################
# DATASET GENERATION FILE #
###########################



#####################
# Preload Functions #
#####################

# Source file
source("code/amirreza_functions.R")
# This source file adds all required packages
# We'll need only to add this one
library(arsenal)
library(foreign)
library(foreach)
library(doparallel)
# Clusters
doParallel::registerDoParallel(6)
# registerDoParallel(cores = 6)


##################
# Dataset inputs #
##################

# Testing input 2
input = list(
	attr.lvls = c(7, 2, 2),
	c.lvls = list(
		c(1.5, 2, 2.5, 3, 3.5, 4, 4.5)
	),
	type = c("C", "D", "D")
)
# IT'S BETTER NOT TO USE LISTS AS INPUTS

# Testing input 1
input1 = list(
	attr.lvls = c(2, 2, 2, 2),
	type = c("D", "D", "D", "D")
)
# IT'S BETTER NOT TO USE LISTS AS INPUTS

# Testing input 3
input2 = list(
	bpar = c(0.49, 0.35),
	musigma = list(
		c(
			mu = 1220,
			sigma = 2150,
			lowerbound = 0,
			upperbound = 1000000000000,
			feature = 1
		),
		c(
			mu = 39.74,
			sigma = 16.3,
			lowerbound = 18,
			upperbound = 85,
			feature = 2
		)
	)
)

# Testing input
input3 = list(
	attr.lvls = c(2, 2),
    type = c("D", "D")
)



####################
# Parameter inputs #
####################

# Individual parameters means 
mu = c(1.42, 1.027, 0.057, 0.009)

# Alternatives' effects means 
mu_alt = c(2.824, 6.665, -2.785, 2.285)

# Covariance matrices
## VERSION FOR VARIANCE-COVARIANCE
vc_1 = matrix(
	c(  2.654^2,8.77 ,  -2.33,  -0.54, 
		8.77,   3.535^2,-4.82,  -4.39, 
		-2.33,  -4.82,  2.711^2,6.17,
		-0.54,  -4.39,  6.17,   3.202^2
	),
	4, 4
)
## VERSION FOR VARIANCE ONLY
vc_2 = matrix( 
	c(  2.654^2,0,      0,      0, 
		0,      3.535^2,0,      0, 
		0,      0,      2.711^2,0,
		0,      0,      0,      3.202^2
	),
	4, 4
)
## VERSION FOR FIXED EFFECTS
vc_3 = matrix( 
	c(  0,      0,      0,      0, 
		0,      0,      0,      0, 
		0,      0,      0,      0,
		0,      0,      0,      0
	),
	4, 4
)





#################
# Fixed effects #
#################

statistics = foreach (run = 1:10, .combine = "rbind") %:% 
    foreach(samples = 1:10, .combine = "rbind") %dopar% {

        # FFD Multichoice
        long = wide_to_long(
            samples = samples,
            input1
        )

        res = foreach (
            NIndividuals = c(
                10, 25, 50, 75, 100, 
                150, 200, 250, 300, 350, 400, 450, 500, 
                750, 1000), 
            .combine = "rbind") %do% {
                
            times = system.time({
                # No random effects
                dataset = dataset_generation(
                    # design = paperdesign,
                    design = long,
                    input2 = input2,
                    N_individuals = NIndividuals,
                    mu = mu,
                    mu_alt = mu_alt,
                    var_cov = vc_3,
                    interactions = c(2, 3),
                    Gumbel = c(0, 1),
                    no_of_alternatives_per_choiceset = 2,
                    no_choice = TRUE
                )

                # No random effects
                ## Rename 
                colnames(dataset) = c(
                    "ID",
                    "Set",
                    "Sex", "Habit", "Salary", "Age",
                    "Price", "Label", "Carbon", 
                    "SU", "AU", "TU", 
                    "Choice"
                ) 
                ## Reshape
                dataset = dataset %>% 
                    select(
                        - SU, - AU, - TU
                    ) %>%
                    mutate_all(
                        ~ replace(., is.na(.), 0)
                    ) %>% 
                    mutate(
                        LC = Carbon * Label
                    )

                ## Add Labels
                dataset$Alternative = rep(
                    c("A", "B", "C"),
                    length(nrow(dataset))
                )

                ## Prepare data 
                dataset = dataset %>% 
                    select(
                        Alternative,
                        Sex, Habit, Salary, Age,
                        Price, Label, Carbon, Choice
                    ) 

                ## Results 
                data_mean = dataset %>% 
                    group_by(Alternative) %>%
                    summarize_all(mean) %>%
                    mutate(
                        Individuals = NIndividuals,
                        Replications = samples,
                        Type = "mean",
                        Run = run
                    )
                data_var = dataset %>% 
                    group_by(Alternative) %>%
                    summarize_all(var) %>%
                    mutate(
                        Individuals = NIndividuals,
                        Replications = samples,
                        Type = "var",
                        Run = run
                    )
            })

            ## Organise results 
            results = rbind(data_mean, data_var)
            return(results)
        }

        return(res)
    }

# Verification
stat_novar = statistics
svae(stat_novar, "data/memoire/stat_novar.R")





#############################
# Correlated random effects #
#############################

statistics = foreach (run = 1:10, .combine = "rbind") %:% 
    foreach(samples = 1:10, .combine = "rbind") %dopar% {

        # FFD Multichoice
        long = wide_to_long(
            samples = samples,
            input1
        )

        res = foreach (
            NIndividuals = c(
                10, 25, 50, 75, 100, 
                150, 200, 250, 300, 350, 400, 450, 500, 
                750, 1000), 
            .combine = "rbind") %do% { 

            times = system.time({
                # No random effects
                dataset = dataset_generation(
                    # design = paperdesign,
                    design = long,
                    input2 = input2,
                    N_individuals = NIndividuals,
                    mu = mu,
                    mu_alt = mu_alt,
                    var_cov = vc_1,
                    interactions = c(2, 3),
                    Gumbel = c(0, 1),
                    no_of_alternatives_per_choiceset = 2,
                    no_choice = TRUE
                )

                # No random effects
                ## Rename 
                colnames(dataset) = c(
                    "ID",
                    "Set",
                    "Sex", "Habit", "Salary", "Age",
                    "Price", "Label", "Carbon", 
                    "SU", "AU", "TU", 
                    "Choice"
                ) 
                ## Reshape
                dataset = dataset %>% 
                    select(
                        - SU, - AU, - TU
                    ) %>%
                    mutate_all(
                        ~ replace(., is.na(.), 0)
                    ) %>% 
                    mutate(
                        LC = Carbon * Label
                    )

                ## Add Labels
                dataset$Alternative = rep(
                    c("A", "B", "C"),
                    length(nrow(dataset))
                )

                ## Prepare data 
                dataset = dataset %>% 
                    select(
                        Alternative,
                        Sex, Habit, Salary, Age,
                        Price, Label, Carbon, Choice
                    ) 

                ## Results 
                data_mean = dataset %>% 
                    group_by(Alternative) %>%
                    summarize_all(mean) %>%
                    mutate(
                        Individuals = NIndividuals,
                        Replications = samples,
                        Type = "mean",
                        Run = run
                    )
                data_var = dataset %>% 
                    group_by(Alternative) %>%
                    summarize_all(var) %>%
                    mutate(
                        Individuals = NIndividuals,
                        Replications = samples,
                        Type = "var",
                        Run = run
                    )
            })

            ## Organise results 
            results = rbind(data_mean, data_var)
            return(results)
        }

        return(res)
    }

# Verification
stat_covar = statistics
svae(stat_covar, "data/memoire/stat_covar.R")





################
# Plot results #
################

##############################
# Individual characteristics #
##############################

# Sex
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Sex, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )

# Habit
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Habit, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )

# Salary
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Salary, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )

# Age
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Age, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )

############################
# Alternatives' attributes #
############################

# Price
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean",
        Alternative != "C"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Price, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )

# Choice
statistics %>% 
    mutate(
        Type = as.factor(Type)
    ) %>% 
    dplyr::filter(
        Type == "mean",
        Alternative != "C"
    ) %>% 
    group_by(Individuals) %>%
    ggplot(aes(y = Choice, x = Individuals, col = Replications)) +
        stat_summary(
            geom = "ribbon", 
            fun.data = mean_sdl, 
            fill = "lightblue"
        ) +
        stat_summary(
            geom = "line", 
            fun = mean, 
            linetype = "dashed"
        ) +
        geom_point(
            size = 1
        ) + 
        scale_color_gradient(
            low = "blue", 
            high = "red"
        )