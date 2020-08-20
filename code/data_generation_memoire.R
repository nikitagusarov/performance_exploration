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

# Samples
samples = 10

# Individuals
NIndividuals = 1000



####################
# Generate Designs # 
####################

# FFD Multichoice
long = wide_to_long(
	samples = samples,
	input1
)

# Paperdesign Multichoice
paperdesign = paper_design(
	samples = samples,
	input3
)



#################
# Fixed effects #
#################

# No random effects
data_novar = dataset_generation(
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
colnames(data_novar) = c(
	"ID",
	"Set",
	"Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon", 
	"SU", "AU", "TU", 
	"Choice"
) 
## Reshape
data_novar = data_novar %>% 
	mutate_all(
		~ replace(., is.na(.), 0)
	) %>% 
	mutate(
		UU = TU - (AU + SU),
		LC = Carbon * Label,
		Buy = ifelse(
			Price != 0, 1,
			0
		)
	) %>%
	relocate(
		UU, 
		.before = TU
	) %>%
	relocate(
		LC,
		.after = Label
	) %>%
	mutate(
		Sex = Buy * Sex,
		Habit = Buy * Habit,
		Salary = Buy * Salary,
		Age = Buy * Age
	)
## Add Labels
data_novar$Alternative = rep(
	c("A", "B", "C"),
	length(nrow(data_novar))
)
## Add set identifier
data_novar$Effects = rep(
	"Fixed",
	length(nrow(data_novar))
)

save(data_novar, file = "data/memoire/data_novar.Rdata")

# Clean workspace
rm(data_novar); gc()



##################
# Random effects #
##################

# Variance only
data_var = dataset_generation(
	# design = paperdesign,
	design = long,
	input2 = input2,
	N_individuals = NIndividuals,
	mu = mu,
	mu_alt = mu_alt,
	var_cov = vc_2,
	interactions = c(2, 3),
	Gumbel = c(0, 1),
	no_of_alternatives_per_choiceset = 2,
	no_choice = TRUE
)

# No random effects
## Rename 
colnames(data_var) = c(
	"ID",
	"Set",
	"Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon", 
	"SU", "AU", "TU", 
	"Choice"
) 
## Reshape
data_var = data_var %>% 
	mutate_all(
		~ replace(., is.na(.), 0)
	) %>% 
	mutate(
		UU = TU - (AU + SU),
		LC = Carbon * Label,
		Buy = ifelse(
			Price != 0, 1,
			0
		)
	) %>%
	relocate(
		UU, 
		.before = TU
	) %>%
	relocate(
		LC,
		.after = Label
	) %>%
	mutate(
		Sex = Buy * Sex,
		Habit = Buy * Habit,
		Salary = Buy * Salary,
		Age = Buy * Age
	)
## Add Labels
data_var$Alternative = rep(
	c("A", "B", "C"),
	length(nrow(data_var))
)
## Add set identifier
data_var$Effects = rep(
	"Random",
	length(nrow(data_var))
)

save(data_var, file = "data/memoire/data_var.Rdata")

# Clean workspace
rm(data_var); gc()



#############################
# Random correlated effects #
#############################

# Variance-covariance
data_covar = dataset_generation(
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

# Variance-covariance
## Rename 
colnames(data_covar) = c(
	"ID",
	"Set",
	"Sex", "Habit", "Salary", "Age",
	"Price", "Label", "Carbon", 
	"SU", "AU", "TU", 
	"Choice"
) 
## Reshape
data_covar = data_covar %>% 
	mutate_all(
		~ replace(., is.na(.), 0)
	) %>% 
	mutate(
		UU = TU - (AU + SU),
		LC = Carbon * Label,
		Buy = ifelse(
			Price != 0, 1,
			0
		)
	) %>%
	relocate(
		UU, 
		.before = TU
	) %>%
	relocate(
		LC,
		.after = Label
	) %>%
	mutate(
		Sex = Buy * Sex,
		Habit = Buy * Habit,
		Salary = Buy * Salary,
		Age = Buy * Age
	)
## Add Labels
data_covar$Alternative = rep(
	c("A", "B", "C"),
	length(nrow(data_covar))
)
## Add set identifier
data_covar$Effects = rep(
	"Random Correlated",
	length(nrow(data_covar))
)

save(data_covar, file = "data/memoire/data_covar.Rdata")

# Clean workspace
rm(data_covar); gc()



####################
# Original dataset #
####################

# Read Stata file
data_orig = read.dta("data/roses/r.dta") 

# Modify dataset
data_orig = data_orig %>%
    mutate(
        LC = label * carbon,
		Data = "Original",
        buy_organic_nofood = buy_organic_nofood - 1,
        Alternative = ifelse(
			rose == 1, "A",
            ifelse(
				rose == 2, "B",
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
        Carbon = carbon,
        Label = label,
        Choice = choice,
        Buy = buy,
        Alternative,
		Data
    ) %>%
	mutate(
		Sex = Buy * Sex,
		Habit = Buy * Habit,
		Salary = Buy * Salary,
		Age = Buy * Age
	)

# Save dataset
save(data_orig, file = "data/memoire/data_orig.Rdata")



#############
# Clear all #
#############

rm(list = ls()); gc()



################
# Testing part #
################

# # Auxilary dataset
# data_novarNC = data_novar %>% 
# 	dplyr::filter(Alternative != "C") %>%
# 	mutate(
# 		PriceX = as.factor(Price)
# 	)

# # Tableby
# # tabdat = tableby(Alternative ~ ., data = data_novar)
# tabdat_NC = tableby(Alternative ~ ., data = data_novarNC)
# tabdat_Choice = tableby(Choice ~ ., data = data_novar)
# tabdat_ChoiceNC = tableby(Choice ~ ., data = data_novarNC)

# # Summaries
# # summary(tabdat)
# summary(tabdat_NC)
# summary(tabdat_Choice)
# summary(tabdat_ChoiceNC)