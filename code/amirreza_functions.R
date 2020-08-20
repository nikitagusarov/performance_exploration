###################
# Amirreza's work #
###################

# GENRAL REMARKS
# THERE EXIST FASTER ITERATORS THAN IF LOOPS: I agree, it seems unprofessional, I will optimize the codes later, 
#vectorization, multi-trading, apply family, dplyr functions
# IT MAY BE INTERESTING TO USE MULTITASKING WHEN COMPILING COMPLETE FUNCTION


###############
# Preparation #
###############

# Loading packages
library(QRM)
# library(tidyr)
# library(dplyr)
library(tidyverse)
library(magrittr)
library(data.table)
library(foreach)


######################################
# Full Factorial Design Alternatives #
######################################


# FF-Desing
FFD = function(
	  input
) {
	# Number of Alternatives(Profiles or alternatives)
	n.alt = prod(input$attr.lvls)
	n.rep = vector("numeric", length(input$attr.lvls))
	for (i in 1:(length(input$attr.lvls) - 1)) {
		lvl_rep = 1
		lvl_rep = prod(input$attr.lvls[(i + 1):(length(input$attr.lvls))])
		n.rep[i] = lvl_rep
	}
	n.rep[length(input$attr.lvls)] = 1
	FF_D = matrix(nrow = n.alt, ncol = length(input$attr.lvls))
	for (i in 1:length(input$attr.lvls)) {
		column = c()
		for (j in 1:input$attr.lvls[i]) {
			if (input$type[i] == "D") {
				column = c(column, rep(j - 1, n.rep[i]))
			}
			else {
				column = c(column, rep(input$c.lvls[[i]][j], n.rep[i]))
			}
		}
		column = rep(column, (n.alt / (input$attr.lvls[i] * n.rep[i])))
		FF_D[, i] = column
	}
	# Output preparation
	FF_D = FF_D[sample(nrow(FF_D), n.alt),]
	# Output
	return(FF_D)
}

# Output transformation
wide_to_long = function(
 	input1,
	samples
) {
	# wide = FFD(input1)
	wide = foreach (i = 1:samples, .combine = rbind) %do% {
		FFD(input1)
	}
	wide = matrix(as.vector(t(wide)), prod(nrow(wide),2), 2, byrow = TRUE)
	return(cbind(price_rand(nrow(wide)), wide))
}

# THIOS SHOULD GO BEFORE AS IT'S USED FOR WIDE DATA TRANSFORMATION
# Price randomiser
price_rand = function(
  	N_rows
) {
	# Setting offest for warmup
	offset = 1000
	# # Numbers generation
	# random_number = rdunif(
	# 	N_rows + offset, 
	# 	b = 1, 
	# 	a = 7
	# )
	# # Remapping
	# random_number[random_number == 7] = 4.5
	# random_number[random_number == 6] = 3.5
	# random_number[random_number == 5] = 2.5
	# random_number[random_number == 1] = 1.5
	random_number = runif(
		N_rows + offset, 
		0, 
		1
	)
	# Subsetting
	random_number = random_number[-(1:offset)]
	a = which(random_number < 1 / 7)
	random_number[a] = 1.5
	a = which(1 / 7 <= random_number  & random_number < 2 / 7)
	random_number[a] = 2
	a = which(2 / 7 <= random_number  & random_number < 3 / 7)
	random_number[a] = 2.5
	a = which(3 / 7 <= random_number  & random_number < 4 / 7)
	random_number[a] = 3
	a = which(4 / 7 <= random_number  & random_number < 5 / 7)
	random_number[a] = 3.5
	a = which(5 / 7 <= random_number  & random_number < 6 / 7)
	random_number[a] = 4
	a = which(6 / 7 <= random_number & random_number <= 1)
	random_number[a] = 4.5
	return(random_number)
}

# Paper design imitation
paper_design = function(
	input3, 
	samples,
	continuous_levels
) {
	# full_factorial_matrix = FFD(input3)
	full_factorial_matrix = foreach (i = 1:samples, .combine = rbind) %do% {
		FFD(input3)
	}
	combination_matrix = combn(
		1:nrow(full_factorial_matrix),
		ncol(full_factorial_matrix)
	)
	combination_index = as.vector(combination_matrix)
	matrix_A_B = matrix(
		0, 
		length(combination_index), 
		length(input3$attr.lvls)
	)
	A_B_index = seq(1:nrow(matrix_A_B))
	A_B_design =  full_factorial_matrix[combination_index[A_B_index],]
	matrix_B_A = matrix(
		0, 
		length(combination_index), 
		length(input3$attr.lvls)
	)
	B_A_index = seq(nrow(matrix_B_A), 1)
	matrix_B_A = A_B_design[B_A_index,]
	design = rbind(A_B_design, matrix_B_A)
	return(cbind(price_rand(nrow(design)), design))
}



##################################
# Individuals Dataset Generation #
##################################


###################
# Support functions
###################

binary_characteristics = function(
	n, 
	p
) {
	# USE SIMPLE BINOMIAL DISTRIBUTION: Nikita, I tried both, this one gives better results, I think This is also a kind of binomial trial.
	# Object generation
	s_h = runif(n, 0, 1)
	x = vector("numeric", n)
	x = which(s_h < p[1])
	s_h[x] = 0
	s_h[-x] = 1
	# Output generation
	return(s_h)
}


continuous_characteristics = function(
	n, 
	mu, 
	sigma, 
	lowerbound, 
	upperbound, 
	feature
) {
	# Object generation
	y = c()
	x = c()
	a = vector("numeric",n)
	# Data generation
	while (length(x) < n) {
		# HERE YOU MAY USE DIRECTLY DISTRIBUTION FUNCTION, It is not possible, as age ranges from 18 to 85 and salaray from 0 to +inf, 
		# I have tried log normal and truncated normal, but the below codes gives even better results.
		y = mu + sigma * rnorm(1, 0, 1)
		# SHOULD WE LIMIT THIS ? 
		if (lowerbound <= y & y <= upperbound) {
		x = round(c(x, y)) 
		}
	}
	
	# Factor level attribution
	# ADD CONTROL OVER THIS FUNCTION
	# ALLOW TO SPECIFY WHICH FEATURE
	# ALLOW TO SPECIFY LABELS
	# IT MAY BE A GOOD IDEA TO SEPARATE THIS PART
	# JUST GENERATE RANDOM DATA AND THEN USER WILL CONVERT DATASET IF NEEDED
	if (feature == 1) {
		a = which(x < 1000)
		x[a] = 1
		a = which(1000 <= x & x < 2000)
		x[a] = 2
		a = which(2000 <= x  & x < 3000)
		x[a] = 3
		a = which(3000 <= x & x < 4000)
		x[a] = 4
		a = which(4000 <= x & x < 5000)
		x[a] = 5
		a = which(5000 <= x)
		x[a] = 6
	}
	# Output generation
	return(x)
}

##########################
# Main generation function
##########################

individual = function(
	input2, 
	N_individuals
) {
	# Object preparation
	data0 = matrix("numeric", nrow = N_individuals, ncol = 4)
	vec = c()
	for (i in 1:2) {
		vec = binary_characteristics(
			N_individuals, 
			input2$bpar[i]
		)
		data0[, i] = vec
		vec = continuous_characteristics(
			N_individuals, 
			input2$musigma[[i]][1], 
			input2$musigma[[i]][2], 
			input2$musigma[[i]][3], 
			input2$musigma[[i]][4], 
			input2$musigma[[i]][5]
		)
		data0[, i + 2] = vec
	}
	# Saving data
	storage.mode(data0) = "numeric"
	return(data0)
}


#################################################
# Utility calculation and choice set generation # 
#################################################

################################
# Parametrization of individuals
################################

# Constant parameters framework


# Constant parameters for the socioeconomic characteristics, we simply make a matrix 
# with N number of columns and put the constant parameters vector in each of the columns(each column is an individual)

ind_params = function(
	N_individuals, 
	mu
) {
	# Object generation
	constant_params = matrix(
		0, 
		nrow = length(mu), 
		ncol = N_individuals
	)
	constant_params[, 1:N_individuals] = mu
	# Ouput generation
	return(constant_params)
}



# Random parameters framework
alt_params = function(
	N_individuals,
	mu_alt,
	var_cov
) {
	# Object generation
	mu_column = matrix(mu_alt, nrow = length(mu_alt), ncol = N_individuals)
	random_params = matrix(0, nrow = length(mu_alt), ncol = N_individuals)
	cholesky_de = try(chol(var_cov), silent = TRUE)
	if (class(cholesky_de) != "try-error") {
		L_prime = chol(var_cov)
		L = t(L_prime)
		R = matrix(rnorm(length(mu_alt) * N_individuals),
				length(mu_alt),
				N_individuals)
		random_params = mu_column + L %*% R
		
	} else {
		random_params = mu_column
	}
	# Output generation
	return(random_params)
}



##############################
# Utility functions derivation
##############################


# Calculating socioeconomic variables' utility, finally, it is a single vector 1*N
utility_characteristics = function(
	ind_params_matrix,
	socioeconomic_data
) {
	# Setting objects
	cons_u_individual = vector("numeric", ncol(ind_params_matrix))
	constant_utility = ind_params_matrix * t(socioeconomic_data)
	# utility
	cons_u_individual = colSums(constant_utility)
	# Output
	return(cons_u_individual)
}


# Calculating alternatives' utility
utility_alt = function(
	alt_params_matrix,
	design,
	interactions = c(2, 3)
) {
	# CREATE INTERACTION TERM
	if (!is.null(interactions)) {
		vector1 = vector("numeric", nrow(design))
		vector1 = design[, interactions[1]] * design[,interactions[2]]
		design = cbind(design, vector1)
	}
	# CREATE THE CONSTANT AS A SEPARATE VARIABLE IN DATA GENERATION STEP
	constant = c(rep(1, nrow(design)))
	design_const = rbind(t(design), constant)
	# ATTACH THE CONSTANT PARAMETER(PRICE)
	price = matrix(
		c(
			rep(
				-1.631, 
				ncol(alt_params_matrix)
			)
		), 
		1, 
		ncol(alt_params_matrix)
	)
	alt_params_matrix = rbind(price, alt_params_matrix)
	utility_alt_matrix = t(alt_params_matrix) %*% design_const
	
	# Output
	return(utility_alt_matrix)
}


# Total Utility (PUT CONTROL ON GUMBEL PARAMETERS)
total_utility = function(
	alt_u_matr, 
	cons_u_indiv,
	Gumbel = c(0, 1)
) {
	# Objects
	## Presets
	rows = nrow(alt_u_matr)
	columns = ncol(alt_u_matr)
	## AUX
	total_u = matrix(0, rows, columns)
	cons_u = matrix(0, rows, columns)
	# Converting socioeconomic utility vector to a matrix, each column for an individual
	cons_u[,1:columns] = cons_u_indiv 
	# Random Extreme Values (Noise generation)
	noise = matrix(
		rGumbel(
		rows*columns,
		Gumbel[1], 
		Gumbel[2]
		), 
		rows, 
		columns
	)
	
	# Total Utility calculation
	total_u = noise + cons_u + alt_u_matr

	# Output
	return(total_u)
}




#################
# Decision making 
#################

# NEVER DEFINE AMBIGUOUS NAMES !
# CHOICE IS TOO SIMPLE IS PROBABLY ALREADY USED SOMEWHERE !!!

choice = function(
	total_utility,
	Gumbel = c(0, 1),
	no_of_alternatives_per_choiceset = 2,
	no_choice = TRUE
) {
	# Separate generation of no choice noise option
	rows = nrow(t(total_utility))
	columns = ncol(t(total_utility))
	b = (prod(rows, columns) / no_of_alternatives_per_choiceset)
	utilities_columns = matrix(
		as.vector(t(total_utility)), 
		b, 
		no_of_alternatives_per_choiceset,
		byrow = TRUE
	)
	if (no_choice == TRUE) {
		noise_no_choice = matrix(
			c(
				rGumbel(
					b, 
					Gumbel[1], 
					Gumbel[2]
				)
			),
			rows / no_of_alternatives_per_choiceset,
			columns
		)
		noise_no_choice_column = as.vector(noise_no_choice)
		# ERROR SOMEWHERE HERE !!!! (OR SOMECHERE AROUND THIS PLACE)
		utilities_columns = cbind(
			utilities_columns, 
			noise_no_choice_column
		)
	}
	choices_vector = apply(
		utilities_columns, 
		1, 
		function(p)
		which.max(p)
	)
	# Overall choice extraction
	r = nrow(utilities_columns)
	c = ncol(utilities_columns)
	choices = matrix(0, r, c)
	for (i in 1:r) {
		choices[i, choices_vector[i]] = 1
	}
	choices_vector_final = as.vector(t(choices))
	utilities_columns_final = as.vector(t(utilities_columns))

	# Output
	return(cbind(utilities_columns_final, choices_vector_final))
}


######################
####Data generation###
######################

# NEVER DEFINE AMBIGUOUS NAMES !
# DATA IS ALREADY IN BASE AND IT DOES OTHER THINGS !

dataset_generation = function(
	design,
	input2,
	N_individuals,
	mu,
	mu_alt,
	var_cov,
	interactions,
	Gumbel,
	no_of_alternatives_per_choiceset = 2,
	no_choice = TRUE
) {
	#   
	data_individuals = individual(
		input2,
		N_individuals
	)
	#
	socioeconomic_parameters = ind_params(
		N_individuals, 
		mu
	)
	#
	alternatives_parameters = alt_params(
		N_individuals, 
		mu_alt, 
		var_cov
	)
	# 
	characteristics_utility = utility_characteristics(
		socioeconomic_parameters, 
		data_individuals
	)
	#
	alternative_specific_utility = utility_alt(
		alternatives_parameters, 
		design, 
		interactions
	)
	# 
	total_utilities_avec_noise = total_utility(
		alternative_specific_utility,
		characteristics_utility,
		Gumbel
	)
	#
	choices_final = choice(
		total_utilities_avec_noise,
		Gumbel,
		no_of_alternatives_per_choiceset,
		no_choice
	)
	#
	if (no_choice == TRUE) {
		# No_choice
		no_of_rows = sum(
			nrow(design), 
			(nrow(design) / no_of_alternatives_per_choiceset)
		)
		Choice_set = rep(
			rep(
				1:(nrow(design) / no_of_alternatives_per_choiceset),
				each = sum(no_of_alternatives_per_choiceset, 1)
			), 
			N_individuals
		)
		characteristics_utility = rep(
			characteristics_utility, 
			each = nrow(design)
		)
		design = matrix(
			rep(
				t(design), 
				N_individuals
			),
			prod(
				nrow(design), 
				N_individuals
			),
			ncol(design),
			byrow = TRUE
		)
		alternative_specific_utility = as.vector(t(alternative_specific_utility))
		id = rep(
			rep(
				1:(nrow(design) / no_of_alternatives_per_choiceset), 
				each = no_of_alternatives_per_choiceset
			),
			N_individuals
		)
		design_utilities = cbind(
			id, 
			design, 
			characteristics_utility, 
			alternative_specific_utility
		)
		design_utilities = as.data.table(design_utilities)[ 
			, 
			lapply(
				.SD, 
				`length<-`, 
				sum(no_of_alternatives_per_choiceset, 1)
			), 
			by = design_utilities[, 1]
		]
		design_utilities = design_utilities[,-c(1,2)]
	} else {
		# Choice
		no_of_rows = nrow(design)
		Choice_set = rep(
			rep(
				1:(nrow(design) / no_of_alternatives_per_choiceset
			), 
			each = no_of_alternatives_per_choiceset
		),
		N_individuals
		)
		alternative_specific_utility = as.vector(t(alternative_specific_utility))
		design = matrix(
		rep(
			t(design), 
			N_individuals
		),
		ncol = ncol(design),
		byrow = TRUE
		)
		characteristics_utility = rep(
			characteristics_utility, 
			each = nrow(design)
		)
		design_utilities = cbind(
			design, 
			characteristics_utility, 
			alternative_specific_utility
		)
	}
	# IDs
	ID = rep(1:N_individuals, each = no_of_rows)

	# Individuals dataset part
	data_individuals = matrix(
		rep(
			data_individuals, 
			each = no_of_rows
		),
		prod(
			no_of_rows, 
			N_individuals
		)
	)
	
	# Generate dataset
	data0 = cbind(
		ID,
		Choice_set,
		data_individuals,
		design_utilities,
		choices_final
	)

	# Output
	return(as.data.frame(data0))
}
# AS YOU SEE THE RSTUDIO DEFAULT SETTINGS FOR LINE BREAKING ARE FAR FROM BEST
# I ADVICE NOT TO USE THIS LAYOUT BUT TO ORGANISE YOUR CODE IN PYTHON STYLE 
# IT MAY BE GOOD AS WELL TO REDEFINE TAB LEVELS IN RSTUDIO (TAB = 4 SPACES AS USUALLY IN PYTHON)
# DON'T FORGET COMMENTS