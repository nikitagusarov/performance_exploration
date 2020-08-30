---
output: 
    pdf_document:
        toc: FALSE
        df_print: "kable"
        fig_width: 5
        fig_height: 4
        fig_caption: true
header-includes:
    - \usepackage{placeins}
    - \AtBeginDocument{\let\maketitle\relax}
fontsize: 11pt
bibliography: ../../litterature/bibliographie.bib
---






```{r Knitr, echo = FALSE}
#################
# Knitr options #
#################

knitr::opts_chunk$set(
    fig.align = "center",
    eval = FALSE,
    echo = FALSE
)
```

```{r Packages, echo= FALSE, include = FALSE}
####################
# PAckages and AUX #
####################

# General document wide packages
library(foreign)
library(tidyverse)
library(stargazer)
library(arsenal)
# Arsenal transformation
source("../../code/arsenal_to_stargazer.R")
```




<!-- ################################################################## -->
<!-- ################################################################## -->
<!-- ################################################################## -->

## Synthetic data

As it was mentionned our study is based on the article of @llerena2013rose where the willingness to pay for environmental attributes is explored. 
The original dataset was created using experimentally collected information in February 2008. 
In this experimental design 102 consumers were asked to complete 12 decisions (using 12 different choice sets) resulting in 1224 observation, 33 of which were dropped from the final dataset due to no response (no option was sircled on choice card).

We have already delimited the scope of study and the eventual changes we want to explore ...
the main interest is how these suppositions may affect observed target results ...

For simplicity we relax some of the assumptions made in the paper in order to generate two different datasets.
For the first dataset we assume that estimations made in the paper and the derived utility functions are correct and reflect the real world sitation.
For the second one, we relax some of the advanced assumtions and regenerate a simplified version, which will allow us to contrast the performances of different models in different choice context assuming different nture of choice functions.

*It should be stated/ presneted as a good scientific way to answer the research question.* 
*Here it is still narative*
*Maybe this part should describe first the general method to test based on the simulated data and then secondly use the figures of the paper as the values for the empirical casestudy.* 
*Hence the paper should not be discussed before this part (or lightly)*

In both situations the utility functions are determined as in paper: we use the exact means for the coefficients estimates, assuming they are correct. 
The only difference is in the specification of the randomness of these coefficients as they may vary or not across population. 
It means, that the first dataset is generated assuming the variance-covariance matirx for correlated random coefficients is composed with 0's only and the resulting multivariate normal distribution produces exact means for the coefficients.
The second dataset is generated using the exact estimates of the variance-covariance matrix as provided in the article.

*As this section follows the simulator presentation, it should be more precise about the assumptions taht have to be done to simulate data.*

Additionally we impose some supplementary constraints to our data due to the limitations of the simulation tool.
Particularly, the individual characteristics are supposed to be not correlated, which can be explained by the fact that the context of a controlled experiment offers a possibility to controll this particular feature.
Obviously, this is not optimal decision, as naturally the age, sex, income and environmental habits of individuals should be correlated.
Unfortunately, the original article does not provide information about the characteristics' variance-covariace matrix.

The targeted features and requirements to the resulting dataset are numerous and they make a contrast compared to the initial empirical dataset.

As it was mentionned earlier, the simulated dataset allows us to explore significant number of choice sets for numerous artificial individuals, which ensures statistical validity for obtained results and permits us to use advanced estimation algorithms (such as neural networks, for example).
It means that we generate a large sample with exhaustive number of choice sets, in which all the possible combinations of alternative attributes are represented.
Here by *attributes* we understand the binary factors describing rose's labelling and carbon footprint and ignore the price, the latter being added aftervards using randomisation techniques.
This choice is similar to the experimental design described in the @llerena2013rose work and is easily explained when we take a closer look at the number of choice sets for different specifications.
In simulated datasets it is traditional (*add source*) to use Full-Factorial (FF) experimental design as it uncovers completely the sull potential of simulation tools: it allows to observe all the possible combinations of factors affecting some precess and fully explore their implications.
In our case, a simple full factorial design for a binary choice context has 28 combinations of factors (7 levels of prices, 2 levels for Label and 2 levels for Carbon imprint), but a complete full factorial design for a choice context with two alternatives implies 784 different combinations (as we have two alternatives each having 28 possible variants), which is unrealistic in a standart experimental study context and risks to be too demanding in terms of calculation times.

The dataset should be equilibred with relatively identical number of choices for all three alternatives. 
In the field experiment the researches managed to achieve satisfying result with 67.5% of "Buy" choices and 32.5% for "Not to buy" choices.

*Rank effect was mentionned*

The distribution inside the "Buy" group for different alternatives ("A" and "B") is quasi-identical, resulting equally distributed 3 groups of choices each nearing 33.3%.
Even if this property is not as important for a traditional MNL mode, we are interested to observe the same choice structure in our artificial dataset, because it may highly affect the performance of more advanced models (such as NN).

*Explain advanced effects.* 
*This is one the the guess or assumption that can be stated about the method to be applied.*
*choice structure may impact performance of tools - vs - soem tools' results (perf) are robust to the choice structure*





<!-- ################################################################## -->
<!-- ################################################################## -->
<!-- ################################################################## -->

### Data presentation 

In this section we will discuss the resulting datasets simulated under the listed above assumptions. 

We will start by presenting the original dataset as figuring in the article contrasted against the one, obtained with simulation techniques.
During this step we will observe only the individual characteristics and alternatives' attributes as they are not affected by the assumption concerning the utility function specification.
In other words, we will start with short discussion on the artificial data's general characteristics that are shared by both of the experimental settings and compare them with the input specification.

Only afterwards we will switch to a discussion of the differences in utility specifications between two generated datasets, their implications and the expected impacts on the observed results. 

We have already provided some of the comments concerning the possible distributions of responses as well as the dataset dimentions : 1224 observations, 33 of which were omitted due to the absence of any response.
Among the remining valid observations the option tu "Buy" a rose was selected 804 times, while its counterpart designed as "Not to buy" was chosen only 387 times.
To onrtain this dataset 102 faced 12 choice sets in random order as the choice sets were distributed simultaneously and the subjects were free to choose the starting point and order of choice sets.

The population of respondents was described by four socio-economic variables : their sex, age, personal income and their habits in buying organic products.
The following table regroups the descriptive statistics for these variables as for the population estimates in the article : 

Each choice alternative is defined by three factors : price of the rose, varying by steps of 0.50€ in range between 1.50€ and 4.50€; information provided about the carbon footprint (greater or lower); and finally an eco-label describing the agricultural techniques implemented during the cultivation.

The experimental design used to generate the choice sets assumed no branding for the alternatives to avoid any undesired bias in the results.
Pairing of the binary attributes resulted in situation with only four different specifications for an alternative, which could be combined in six different choice sets (the ten othervise possible choice sets with identical products were excluded from the study).
The titles (A or B) inside agiven choice set were allocated randomly, as well as were the prices.
Theoretically this design should have provided an equilibrated dataset with no correlation among between different attributes, although the size of the final dataset migh have affected the results.

*This is a testing part for dataset presentation and comparison*

```{r DataManagement, include = FALSE}
##################
# Original dataset
##################

# Read Stata file
data_orig = read.dta("../../data/roses/r.dta") 

# Modify dataset
data_orig = data_orig %>%
    mutate(
        LC = label * carbon,
        buy_organic_nofood = buy_organic_nofood - 1,
        Data = "Original",
        Alternative = ifelse(rose == 1, "A",
            ifelse(rose == 2, "B",
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
        Label = label,
        Carbon = carbon,
        Choice = choice,
        Buy = buy,
        LC,
        Data,
        Alternative
    )



###################
# Resulting dataset
###################

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("../../data/simulation/dataset.csv") 

# Clearing and modifying 
dataset = dataset %>%
    select(
        ID, Set = Choice_set, Sex, Habit, Salary, 
        Age, Price, Label, Carbon, Choice
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 1,
        LC = Label * Carbon,
        Alternative = rep(c("A", "B"), 
        length = nrow(dataset))
    )

# Auxilaty
## Verify choices
dverif = dataset %>%
    group_by(ID, Set) %>%
    summarize(
        Choice = sum(as.integer(Choice))
    ) %>%
    arrange(ID, Set)
## Subset creation for "no choice"
dsubset = dataset %>%
    distinct(
        ID, Set, Sex, Habit, Salary, Age
    ) %>%
    arrange(ID, Set) %>%
    mutate(
        Buy = 0,
        Sex = Sex,
        Habit = Habit,
        Salary = Salary,
        Age = Age,
        # Sex = Buy * Sex,
        # Habit = Buy * Habit,
        # Salary = Buy * Salary,
        # Age = Buy * Age,
        Price = 0,
        Alternative = "C",
        Label = 0,
        Carbon = 0, 
        LC = 0,
        Choice = as.integer(dverif$Choice == FALSE)
    ) 
## Merge with original dataset and arrange
dataset = full_join(dataset, dsubset) %>%
    arrange(ID, Set) %>%
    mutate(
        Alternative = as.factor(Alternative),
        Data = "Generated"
    ) %>% 
    select(
        ID,
        Set,
        Sex,
        Habit,
        Salary,
        Age,
        Price,
        Label,
        Carbon,
        Choice,
        Buy,
        LC,
        Data,
        Alternative
    )
## Clear environment
rm(dverif, dsubset)



##################
# Combined dataset
##################

# Combine dataframez
combined_data = full_join(
        dataset,
        data_orig
    ) %>% 
    mutate(
        Data = as.factor(Data)
    )



###########################
# Treatment and combination
###########################

# Individuals subset
individuals = combined_data %>% 
    distinct(Data, ID, .keep_all = TRUE) %>%
    select(
        Sex, 
        Habit, 
        Salary, 
        Age,
        Data
    )

# Alternatives subset
alternatives = combined_data %>%
    dplyr::filter(Alternative != "C") %>%
    select(
        Price,
        Label, 
        Carbon,
        Choice,
        LC,
        Data
    )



###########################
# Treatment and combination
###########################

# Original subset
original = combined_data %>% 
    dplyr::filter(
        Data == "Original",
        Alternative != "C"
    ) %>%
    select(
        Alternative,
        Sex, 
        Habit, 
        Salary, 
        Age,
        Price,
        Label, 
        Carbon,
        Choice,
        LC
    )

# Generated subset
generated = combined_data %>%
    dplyr::filter(
        Data == "Generated",
        Alternative != "C"
    ) %>%
    select(
        Alternative,
        Sex, 
        Habit, 
        Salary, 
        Age,
        Price,
        Label, 
        Carbon,
        Choice,
        LC
    )
```

We may observe the individuals descriptive statistics for tqo of the datasets, the original one, gathered by @llerena2013ec and the two generated ones ...

\FloatBarrier

```{r Individuals, results = "asis"}
# Tableby transform
individuals_by = tableby(
    Data ~ Sex + Habit + Salary + Age,
    data = individuals,
    total = FALSE
)

# Capturing arsenal output
capture_ind = capture.output(
    summary(
        individuals_by,
        text = "latex"
    )
)

# Transforming and printing output
transform_arsenal(
    input = capture_ind,
    position = "!htbp",
    caption = "Individuals descriptive statistics",
    label = ""
)
```

\FloatBarrier

The same goes for alternative descriptive statistics ...

\FloatBarrier

```{r Alternatives, results = "asis"}
# Tableby transform
alternatives_by = tableby(
    Data ~ Price + Label + Carbon  + LC,
    data = alternatives,
    total = FALSE
)

# Capturing arsenal output
capture_alt = capture.output(
    summary(
        alternatives_by,
        text = "latex"
    )
)

# Transforming and printing output
transform_arsenal(
    input = capture_alt,
    position = "!htbp",
    caption = "Alternatives descriptive statistics",
    label = ""
)
```

\FloatBarrier

Finally, we may be interested in comparing the statistics for different classes in our sample to ensure that they are not biased in favour of label "A" or label "B", as in this case it risks to bias the estimates.

\FloatBarrier

```{r Generated, results = "asis"}
# Tableby transform
generated_by = tableby(
    Alternative ~ # Sex + Habit + Salary + Age +  
        Price + Label + Carbon + LC +
        Choice,
    data = generated,
    total = FALSE
)

# Capturing arsenal output
generated_alt = capture.output(
    summary(
        generated_by,
        text = "latex"
    )
)

# Transforming and printing output
transform_arsenal(
    input = generated_alt,
    position = "!htbp",
    caption = "Generated dataset descriptive statistics by group",
    label = ""
)
```

\FloatBarrier