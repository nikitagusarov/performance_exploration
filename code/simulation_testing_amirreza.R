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
library(tidyr)
library(dplyr)
library(data.table)


######################################
# Full Factorial Design Alternatives #
######################################

# IT'S BETTER NOT TO USE LISTS AS INPUTS
# Testing input
input = list(
  attr.lvls = c(7, 2, 2),
  c.lvls = list(
    c(1.5, 2, 2.5, 3, 3.5, 4, 4.5)
  ),
  type = c("C", "D", "D")
)

# FF-Desing
FFD = function(input) {
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

# Testing
dD = FFD(input)
dD

##################################
# Individuals Dataset Generation #
##################################

# See Amirrezas repo for instructions
# IT'S BETTER NOT TO USE LISTS AS INPUTS
# Testing input
input2 = list(
  n = 1000,
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
      sigma = 18.89,
      lowerbound = 18,
      upperbound = 85,
      feature = 2
    )
  )
)

###################
# Support functions
###################

binary_characteristics = function(n, p) {
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


continuous_characteristics = function(n, mu, sigma, lowerbound, upperbound, feature) {
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

individual = function(input2) {
  # Object preparation
  data0 = matrix("numeric", nrow = input2$n, ncol = 4)
  vec = c()
  for (i in 1:2) {
    vec = binary_characteristics(
      input2$n, 
      input2$bpar[i]
    )
    data0[, i] = vec
    vec = continuous_characteristics(
      input2$n, 
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

# Testing
indiv_data = individual(input2)
indiv_data


#################################################
# Utility calculation and choice set generation # 
#################################################

################################
# Parametrization of individuals
################################

# Constant parameters framework


# Constant parameters for the socioeconomic characteristics, we simply make a matrix 
# with N number of columns and put the constant parameters vector in each of the columns(each column is an individual)

ind_params = function(N_individuals, mu) {
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

# Testing
## Constant parameters
indiv_parameters = ind_params(
  N_individuals = 1000,
  mu = c(1.42, 1.027, 0.057, 0.009)
)

# Random parameters framework
alt_params = function (N_individuals,
                       mu_alt,
                       var_cov) {
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

mu_column = matrix(c(1,2,3,4), nrow = 4, 3)
mu_column
# Testing
## Random parameters
### Aux object generation
#### VERSION FOR VARIANCE-COVARIANCE
vc_1 = matrix(
  c(  2.654^2,8.77 ,  -2.33,  -0.54, 
      8.77,   3.535^2,-4.82,  -4.39, 
      -2.33,  -4.82,  2.711^2,6.17,
      -0.54,  -4.39,  6.17,   3.202^2
  ),
  4, 4
)

#### VERSION FOR VARIANCE ONLY
vc_2 = matrix( 
  c(  2.654^2,0,      0,      0, 
      0,      3.535^2,0,      0, 
      0,      0,      2.711^2,0,
      0,      0,      0,      3.202^2
  ),
  4, 4
)
#### VERSION FOR FIXED EFFECTS (theoretically it should work: yes, but chol requires a positive definite matrix, #I fixed the problem)
vc_3 = matrix( 
  c(  0,      0,      0,      0, 
      0,      0,      0,      0, 
      0,      0,      0,      0,
      0,      0,      0,      0
  ),
  4, 4
)
mu_alt = c(2.824, 6.665, -2.785, 2.285)
### Random parameters generation
alt_parameters_rand_cor = alt_params(1000, mu, vc_1)
alt_parameters_rand_var = alt_params(1000, mu, vc_2)
alt_parameters_fix = alt_params(1000, mu, vc_3)

##############################
# Utility functions derivation
##############################


# Calculating socioeconomic variables' utility, finally, it is a single vector 1*N
utility_characteristics = function(ind_params_matrix,
                                   socioeconomic_data) {
  # Setting objects
  cons_u_individual = vector("numeric", ncol(ind_params_matrix))
  constant_utility = ind_params_matrix * t(socioeconomic_data)
  # utility
  cons_u_individual = colSums(constant_utility)
  # Output
  return(cons_u_individual)
}

# Testing 
## Socioeconomic
utility_socioeconomic = utility_characteristics(indiv_parameters,
                                                indiv_data)
utility_socioeconomic

# Calculating alternatives' utility
utility_alt = function(alt_params_matrix,
                       design,interactions = c(2,3)) {
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
  price = matrix(c(rep(-1.63, ncol(
    alt_params_matrix
  ))),
  1,
  ncol(alt_params_matrix))
  alt_params_matrix = rbind(price, alt_params_matrix)
  utility_alt_matrix = t(alt_params_matrix) %*% design_const
  
  # Output
  return(utility_alt_matrix)
}

# Testing
utilityalt = utility_alt(alt_parameters_rand_cor, dD,c(2,3))
utilityalt

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

# Testing 
totalutility = total_utility(utilityalt,utility_socioeconomic,c(0,1))


### Calculation
utility_alternatives_rand_cor = utility_alt(
  alt_params_matrix = alt_parameters_rand_cor,
  design = dD, c(2,3)
)
utility_alternatives_rand_var = utility_alt(
  alt_params_matrix = alt_parameters_rand_var,
  design = dD, c(2,3)
)
utility_alternatives_fix = utility_alt(
  alt_params_matrix = alt_parameters_fix,
  design = dD, c(2,3)
)
## Total utility calculation
totalutility_rand_cor = total_utility(
  utility_alternatives_rand_cor,
  utility_socioeconomic
)
totalutility_rand_var = total_utility(
  utility_alternatives_rand_var,
  utility_socioeconomic
)
totalutility_fix = total_utility(
  utility_alternatives_fix,
  utility_socioeconomic
)



#################
# Decision making 
#################



choice = function(total_utility,
                  Gumbel = c(0, 1),
                  no_of_alternatives_per_choiceset = 2,
                  no_choice = TRUE) {
  # Separate generation of no choice noise option
  rows = nrow(t(total_utility))
  columns = ncol(t(total_utility))
  b = prod(rows, columns) / no_of_alternatives_per_choiceset
  utilities_columns = matrix(as.vector(t(total_utility)), b, no_of_alternatives_per_choiceset)
  if (no_choice == TRUE) {
    noise_no_choice = matrix(rGumbel(b, Gumbel[1], Gumbel[2]),
                             rows / no_of_alternatives_per_choiceset,
                             columns)
    noise_no_choice_column = as.vector(noise_no_choice)
    utilities_columns = cbind(utilities_columns, noise_no_choice_column)
  }
  choices_vector = apply(utilities_columns, 1, function(p)
    which.max(p))
  # Overall choice extraction
  r = nrow(utilities_columns)
  c = ncol(utilities_columns)
  choices = matrix(0, r, c)
  for (i in 1:r) {
    choices[i, choices_vector[i]] = 1
  }
  choices_vector_final = as.vector(t(choices))
  utilities_columns_final = as.vector(t(utilities_columns))
  return(cbind(utilities_columns_final, choices_vector_final))
}

choice(totalutility_rand_cor,c(0,1),2,TRUE)

######################
####Data generation###
######################

data = function(input,
                input2,
                N_individuals,
                mu,
                mu_alt,
                var_cov,
                interactions,
                Gumbel,
                no_of_alternatives_per_choiceset = 2,
                no_choice = TRUE) {
  design = FFD(input)
  data_individuals = individual(input2)
  socioeconomic_parameters =  ind_params(N_individuals, mu)
  alternatives_parameters = alt_params(N_individuals, mu_alt, var_cov)
  characteristics_utility =  utility_characteristics(socioeconomic_parameters, data_individuals)
  alternative_specific_utility = utility_alt(alternatives_parameters, design, interactions)
  total_utilities_avec_noise = total_utility(alternative_specific_utility,
                                             characteristics_utility,
                                             Gumbel)
  choices_final = choice(total_utilities_avec_noise,
                         Gumbel,
                         no_of_alternatives_per_choiceset,
                         no_choice)
  if (no_choice == TRUE) {
    no_of_rows = sum(nrow(design), (nrow(design) / no_of_alternatives_per_choiceset))
    Choice_set = rep(rep(
      1:(nrow(design) / no_of_alternatives_per_choiceset),
      each = sum(no_of_alternatives_per_choiceset, 1)
    ), N_individuals)
    characteristics_utility = rep(characteristics_utility, each = nrow(design))
    design = matrix(rep(t(design), N_individuals),
                    prod(nrow(design), N_individuals),
                    ncol(design),
                    byrow = TRUE)
    alternative_specific_utility = as.vector(t(alternative_specific_utility))
    id = rep(rep(1:(
      nrow(design) / no_of_alternatives_per_choiceset
    ), each = no_of_alternatives_per_choiceset),
    N_individuals)
    design_utilities = cbind(id, design,characteristics_utility, alternative_specific_utility)
    design_utilities = as.data.table(design_utilities)[, lapply(.SD, `length<-`, sum(no_of_alternatives_per_choiceset, 1)), by = design_utilities[, 1]]
    design_utilities = design_utilities[,-c(1,2)]
  } else{
    no_of_rows = nrow(design)
    Choice_set = rep(rep(1:(
      nrow(design) / no_of_alternatives_per_choiceset
    ), each = no_of_alternatives_per_choiceset),
    N_individuals)
    alternative_specific_utility = as.vector(t(alternative_specific_utility))
    design = matrix(rep(t(design), N_individuals),
                    ncol = ncol(design),
                    byrow = TRUE)
    characteristics_utility = rep(characteristics_utility, each =  nrow(design))
    design_utilities = cbind(design,characteristics_utility, alternative_specific_utility)
  }
  ID = rep(1:N_individuals, each = no_of_rows)
  data_individuals = matrix(rep(data_individuals, each = no_of_rows),
                            prod(no_of_rows, N_individuals))
  
  data0 = cbind(
    ID,
    Choice_set,
    data_individuals,
    design_utilities,
    choices_final
  )
  return(as.data.frame(data0))
}
data1=data(input,input2,1000,mu,mu_alt,vc_1,interactions=c(2,3),Gumbel=c(0,1), no_of_alternatives_per_choiceset = 2,no_choice = TRUE)
data1

