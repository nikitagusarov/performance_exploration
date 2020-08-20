##############################
# Calculate effects for MNLS #
##############################

################
# Load support #
################

library(mlogit)
library(MASS)



################
# MNLs simples #
################

# Load model 
load("data/memoire/mnl_novar_estimates.Rdata")

# Get params
wtp_mnl_novar = data.frame(
    Rose = - mnl_novar_estimates$model$coefficients[6] / 
        mnl_novar_estimates$model$coefficients[5],
    Label = - mnl_novar_estimates$model$coefficients[7] /
        mnl_novar_estimates$model$coefficients[5],
    Carbon = - mnl_novar_estimates$model$coefficients[8] /
        mnl_novar_estimates$model$coefficients[5],
    LC = - sum(mnl_novar_estimates$model$coefficients[7:9]) /
        mnl_novar_estimates$model$coefficients[5]
)

# Assign 
mnl_novar_estimates$wtp = wtp_mnl_novar

# Save
save(mnl_novar_estimates, file = "data/memoire/mnl_novar_estimates.Rdata")

# Load model 
load("data/memoire/mnl_covar_estimates.Rdata")

# Get params
wtp_mnl_covar = data.frame(
    Rose = - mnl_covar_estimates$model$coefficients[6] / 
        mnl_covar_estimates$model$coefficients[5],
    Label = - mnl_covar_estimates$model$coefficients[7] /
        mnl_covar_estimates$model$coefficients[5],
    Carbon = - mnl_covar_estimates$model$coefficients[8] /
        mnl_covar_estimates$model$coefficients[5],
    LC = - sum(mnl_covar_estimates$model$coefficients[7:9]) /
        mnl_covar_estimates$model$coefficients[5]
)

# Assign 
mnl_covar_estimates$wtp = wtp_mnl_covar

# Save
save(mnl_covar_estimates, file = "data/memoire/mnl_covar_estimates.Rdata")



#########
# MMNLs #
#########

# Load model 
load("data/memoire/mmnl_novar_estimates.Rdata")

# Etimates from mlogit
estimates = data.frame(
        Rose = summary(
            rpar(mmnl_novar_estimates$model, "Buy", norm = "Price")
        ),
        Label = summary(
            rpar(mmnl_novar_estimates$model, "Label", norm = "Price")
        ),
        Carbon = summary(
            rpar(mmnl_novar_estimates$model, "Carbon", norm = "Price")
        ),
        LC = summary(
            rpar(mmnl_novar_estimates$model, "Buy", LC = "Price")
        )
    )[-c(1,6), ] %>% 
    t()

# Get params
means = c(
    mmnl_novar_estimates$model$coefficients[6],
    mmnl_novar_estimates$model$coefficients[7],
    mmnl_novar_estimates$model$coefficients[8],
    mmnl_novar_estimates$model$coefficients[9]
)
covariance = vcov(
    mmnl_novar_estimates$model, 
    what = "rpar"
)

# Generate distribution
distribution = mvrnorm(
        n = 1000,
        mu = as.vector(means), 
        Sigma = as.matrix(covariance)
    ) %>% 
    as.data.frame()
wtp_distribution = distribution %>%
    mutate_all(function(x) - x / mmnl_novar_estimates$model$coefficients[5]) %>%
    mutate(
        LC = LC + Carbon + Label
    )

# Assign 
mmnl_novar_estimates$wtp_ml = estimates
mmnl_novar_estimates$wtp_dist = wtp_distribution

# Save
save(mmnl_novar_estimates, file = "data/memoire/mmnl_novar_estimates.Rdata")

# Load model 
load("data/memoire/mmnl_covar_estimates.Rdata")

# Etimates from mlogit
estimates = data.frame(
        Rose = summary(
            rpar(mmnl_covar_estimates$model, "Buy", norm = "Price")
        ),
        Label = summary(
            rpar(mmnl_covar_estimates$model, "Label", norm = "Price")
        ),
        Carbon = summary(
            rpar(mmnl_covar_estimates$model, "Carbon", norm = "Price")
        ),
        LC = summary(
            rpar(mmnl_covar_estimates$model, "Buy", LC = "Price")
        )
    )[-c(1,6), ] %>% 
    t()

# Get params
means = c(
    mmnl_covar_estimates$model$coefficients[6],
    mmnl_covar_estimates$model$coefficients[7],
    mmnl_covar_estimates$model$coefficients[8],
    mmnl_covar_estimates$model$coefficients[9]
)
covariance = vcov(
    mmnl_covar_estimates$model, 
    what = "rpar"
)

# Generate distribution
distribution = mvrnorm(
        n = 1000,
        mu = as.vector(means), 
        Sigma = as.matrix(covariance)
    ) %>% 
    as.data.frame()
wtp_distribution = distribution %>%
    mutate_all(function(x) - x / mmnl_covar_estimates$model$coefficients[5]) %>%
    mutate(
        LC = LC + Carbon + Label
    )

# Assign 
mmnl_covar_estimates$wtp_ml = estimates
mmnl_covar_estimates$wtp_dist = wtp_distribution

# Save
save(mmnl_covar_estimates, file = "data/memoire/mmnl_covar_estimates.Rdata")

















# Alternatives' effects means 
mu_alt = c(2.824, 6.665, -2.785, 2.285)

## VERSION FOR VARIANCE-COVARIANCE
vc_1 = matrix(
	c(  2.654^2,8.77 ,  -2.33,  -0.54, 
		8.77,   3.535^2,-4.82,  -4.39, 
		-2.33,  -4.82,  2.711^2,6.17,
		-0.54,  -4.39,  6.17,   3.202^2
	),
	4, 4
)

# Get params
means = c(
    mmnl_novar_estimates$model$coefficients[6],
    mmnl_novar_estimates$model$coefficients[7],
    mmnl_novar_estimates$model$coefficients[8],
    mmnl_novar_estimates$model$coefficients[9]
)
covariance = vcov(
    mmnl_novar_estimates$model, 
    what = "rpar"
)

# Generate distribution
distribution = mvrnorm(
        n = 1000,
        mu = mu_alt, 
        Sigma = vc_1
    ) %>% 
    as.data.frame()
colnames(distribution) = c("Label", "Carbon", "LC", "Buy")
wtp_distribution = distribution %>%
    mutate_all(function(x) - x / -1.631) %>%
    mutate(
        LC = LC + Carbon + Label
    )
stargazer(wtp_distribution)