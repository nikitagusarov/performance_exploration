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



#################
# Load packages #
#################

# Data management
library(tidyverse)

# Latex output generation
library(arsenal)
library(stargazer)
source("code/arsenal_to_stargazer.R")



#######################
# No variance dataset #
#######################

# Load dataset
load("data/memoire/data_novar.Rdata")

# Individuals 
data_novar_ind = data_novar %>%
	distinct(ID, .keep_all = TRUE) %>%
    select(
        Sex, Habit, Salary, Age
    ) 

# Alternatives 
## Auxilary dataset
data_novar_alt = data_novar %>% 
	dplyr::filter(Alternative != "C") %>%
    select(
        Alternative, Choice, 
        Price, Carbon, Label
    ) %>% 
	mutate(
		"Price by group" = as.factor(Price)
	)

## Tableby
stat_novar_alt = tableby(
    Alternative ~ ., 
    data = data_novar_alt
)

# Output summaries
## Arsenal output
alt_ars_novar = capture.output(
    summary(
        stat_novar_alt,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_novar = capture.output(
    transform_arsenal(
        input = alt_ars_novar,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by group, fixed coefficients",
        label = ""
    )
)
## Stargazer output
ind_star_novar = capture.output(
    stargazer(
        data_novar_ind,
        header = FALSE,
        title = "Individuals descriptive statistics, fixed coefficients"
    )
)

# Clear space
rm(data_novar)
rm(data_novar_ind)
rm(data_novar_alt)
rm(stat_novar_alt)
rm(alt_ars_novar)



#########################
# Varience only dataset #
#########################

# Load dataset
load("data/memoire/data_var.Rdata")

# Individuals 
data_var_ind = data_var %>%
	distinct(ID, .keep_all = TRUE) %>%
    select(
        Sex, Habit, Salary, Age
    ) 

# Alternatives 
## Auxilary dataset
data_var_alt = data_var %>% 
	dplyr::filter(Alternative != "C") %>%
    select(
        Alternative, Choice, 
        Price, Carbon, Label
    ) %>% 
	mutate(
		"Price by group" = as.factor(Price)
	)

## Tableby
stat_var_alt = tableby(
    Alternative ~ ., 
    data = data_var_alt
)

# Output summaries
## Arsenal output
alt_ars_var = capture.output(
    summary(
        stat_var_alt,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_var = capture.output(
    transform_arsenal(
        input = alt_ars_var,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by group, random effects",
        label = ""
    )
)
## Stargazer output
ind_star_var = capture.output(
    stargazer(
        data_var_ind,
        header = FALSE,
        title = "Individuals descriptive statistics, random effects")
)

# Clear space
rm(data_var)
rm(data_var_ind)
rm(data_var_alt)
rm(stat_var_alt)
rm(alt_ars_var)



#####################
# Cvariance dataset #
#####################

# To be repeated for each of three (two) datasets

# Load dataset
load("data/memoire/data_covar.Rdata")

# Individuals 
data_covar_ind = data_covar %>%
	distinct(ID, .keep_all = TRUE) %>%
    select(
        Sex, Habit, Salary, Age
    ) 

# Alternatives 
## Auxilary dataset
data_covar_alt = data_covar %>% 
	dplyr::filter(Alternative != "C") %>%
    select(
        Alternative, Choice, 
        Price, Carbon, Label
    ) %>% 
	mutate(
		"Price by group" = as.factor(Price)
	)

## Tableby
stat_covar_alt = tableby(
    Alternative ~ ., 
    data = data_covar_alt
)

# Output summaries
## Arsenal output
alt_ars_covar = capture.output(
    summary(
        stat_covar_alt,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_covar = capture.output(
    transform_arsenal(
        input = alt_ars_covar,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by group, correlated random effects",
        label = ""
    )
)
## Stargazer output
ind_star_covar = capture.output(
    stargazer(
        data_covar_ind,
        header = FALSE,
        title = "Individuals descriptive statistics, correlated random effects"
    )
)

# Clear space
rm(data_covar)
rm(data_covar_ind)
rm(data_covar_alt)
rm(stat_covar_alt)
rm(alt_ars_covar)



####################
# Original dataset #
####################

# Load individuals dataset
load("data/memoire/data_orig.Rdata")

# Individuals 
data_orig_ind = data_orig %>%
	distinct(ID, .keep_all = TRUE) %>%
    select(
        Sex, Habit, Salary, Age
    ) 

# Alternatives 
## Auxilary dataset
data_orig_alt = data_orig %>% 
	dplyr::filter(Alternative != "C") %>%
    select(
        Alternative, Choice, 
        Price, Carbon, Label
    ) %>% 
	mutate(
		"Price by group" = as.factor(Price)
	)

## Tableby
stat_orig_alt = tableby(
    Alternative ~ ., 
    data = data_orig_alt
)

# Output summaries
## Arsenal output
alt_ars_orig = capture.output(
    summary(
        stat_orig_alt,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_orig = capture.output(
    transform_arsenal(
        input = alt_ars_orig,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by group, correlated random effects",
        label = ""
    )
)
## Stargazer output
ind_star_orig = capture.output(
    stargazer(
        data_orig_ind,
        header = FALSE,
        title = "Individuals descriptive statistics, correlated random effects"
    )
)

# Clear space
rm(data_orig)
rm(data_orig_ind)
rm(data_orig_alt)
rm(stat_orig_alt)
rm(alt_ars_orig)



####################
# Combined dataset #
####################

# Load datasets and combine them 
load("data/memoire/data_novar.Rdata")
# load("data/memoire/data_var.Rdata")
load("data/memoire/data_covar.Rdata")
load("data/memoire/data_orig.Rdata")

# Merge datasets
dataset = full_join(
        data_novar, 
        data_covar
    ) %>%
    mutate(
        Data = "Generated"
    ) %>% 
    full_join(
        data_orig
    )

# Clear space
rm(data_novar)
rm(data_covar)
rm(data_orig)

# Individual 
ind_dataset = dataset %>%
    select(
        ID, Data, Effects,
        Sex, Habit, Salary, Age
    ) %>% 
	mutate(
        Dataset = ifelse(
            Data == "Original", "Original",
            ifelse(
                ((Data == "Generated") &  (Effects == "Fixed")), "Generated FE",
                "Generated RE"
            ) 
        )
	) %>%
	distinct(ID, Dataset, .keep_all = TRUE) %>%
    select(
        - ID,
        - Data,
        - Effects
    )

# Alternatives 
## Auxilary dataset
alt_dataset = dataset %>% 
	dplyr::filter(Alternative != "C") %>%
    select(
        Data, Effects,
        Alternative, Choice, 
        Price, Carbon, Label
    ) %>% 
	mutate(
        Dataset = ifelse(
            Data == "Original", "Original",
            ifelse(
                ((Data == "Generated") &  (Effects == "Fixed")), "Generated FE",
                "Generated RE"
            ) 
        ),
        "Price by group" = as.factor(Price)
	) %>%
    select(
        - Data,
        - Effects
    )

# By dataset
## Tableby
stat_data_alt = tableby(
    Dataset ~ ., 
    total = FALSE,
    data = alt_dataset
)
## Arsenal output
alt_ars_data = capture.output(
    summary(
        stat_data_alt,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_data = capture.output(
    transform_arsenal(
        input = alt_ars_data,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by dataset",
        label = ""
    )
)

# Stratified by group
## Tableby
stat_data_alt_strata = tableby(
    Dataset ~ ., 
    strata = Alternative,
    total = FALSE,
    data = alt_dataset
)
## Arsenal output
alt_ars_data_strata = capture.output(
    summary(
        stat_data_alt_strata,
        text = "latex"
    )
)
## Stargazer transformation
alt_star_data_strata = capture.output(
    transform_arsenal(
        input = alt_ars_data_strata,
        position = "!htbp",
        caption = "Alternatives' descriptive statistics by dataset, stratified by alternative",
        label = ""
    )
)

# Individuals by dataset
## Tableby
stat_data_ind = tableby(
    Dataset ~ ., 
    total = FALSE,
    data = ind_dataset
)
## Arsenal output
ind_ars_data = capture.output(
    summary(
        stat_data_ind,
        text = "latex"
    )
)
## Stargazer transformation
ind_star_data = capture.output(
    transform_arsenal(
        input = ind_ars_data,
        position = "!htbp",
        caption = "Individuals' descriptive statistics by dataset",
        label = ""
    )
)

# Clear space 
rm(dataset)
rm(alt_dataset)
rm(ind_dataset)
rm(stat_data_alt_strata)
rm(alt_ars_data_strata)
rm(stat_data_alt)
rm(alt_ars_data)
rm(stat_data_ind)
rm(ind_ars_data)



#################
# Save resultss #
#################

save.image(file = "data/memoire/descriptive_statistics.Rdata")