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
library(tidyverse)
library(stargazer)
library(arsenal)
# Arsenal transformation
source("../../code/arsenal_to_stargazer.R")
```





<!-- ################################################################## -->
<!-- ################################################################## -->
<!-- ################################################################## -->

## Practical implementaiton

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

# Data presentation 

In this section we will discuss the resulting datasets simulated under the listed above assumptions. 

We will start by presenting the original dataset as figuring in the article contrasted against the one, obtained with simulation techniques.
During this step we will observe only the individual characteristics and alternatives' attributes as they are not affected by the assumption concerning the utility function specification.
In other words, we will start with short discussion on the artificial data's general characteristics that are shared by both of the experimental settings and compare them with the input specification.

Only afterwards we will switch to a discussion of the differences in utility specifications between two generated datasets, their implications and the expected impacts on the observed results. 



## Original dataset (descriptive statistics as in the paper ?)

We have already provided some of the comments concerning the possible distributions of responses as well as the dataset dimentions : 1224 observations, 33 of which were omitted due to the absence of any response.
Among the remining valid observations the option tu "Buy" a rose was selected 804 times, while its counterpart designed as "Not to buy" was chosen only 387 times.
To onrtain this dataset 102 faced 12 choice sets in random order as the choice sets were distributed simultaneously and the subjects were free to choose the starting point and order of choice sets.

The population of respondents was described by four socio-economic variables : their sex, age, personal income and their habits in buying organic products.
The following table regroups the descriptive statistics for these variables as for the population estimates in the article : 

<!-- Generated version -->

```{r OriginalDataset}
# Load package for reading Stata files
library(foreign)

# Read Stata file
data_orig = read.dta("../../data/roses/r.dta") 

# Rescaling library
# library(scales)

# Create individuals database
data_orig_ind = data_orig[!duplicated(data_orig$id), ] %>%
    # Here we rename variables and subset only individual characteristics
    select(
        Sex = sex,
        Habit = buy_organic_nofood,
        Salary = income,
        Age = age
    ) %>% 
    mutate(
        Habit = Habit - 1
    )
# data_orig_ind$Habit = rescale(data_orig_ind$Habit, c(0, 1))
```

*It appears here is some confusion with extraction of habits : mean for buy_organic is 0.5 on rescale, mean for buy_organic_nofood is more accurate, but I'm unsure whether it's a correct variable*

\FloatBarrier

```{r OriginalDescriptiveStats_Ind, results = "asis"}
stargazer(
    data_orig_ind,
    title = "Original individuals descriptive statistics",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier

<!-- Version fom the article -->

\FloatBarrier

\begin{table}[!htbp] \centering 
  \caption{Individuals descriptive statistics} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lccccc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
Statistic & \multicolumn{1}{c}{N} & \multicolumn{1}{c}{Mean} & \multicolumn{1}{c}{St. Dev.} & \multicolumn{1}{c}{Min} & \multicolumn{1}{c}{Max} \\ 
\hline \\[-1.8ex] 
Sex & 102 & 0.49 & 0.50 & 0 & 1 \\ 
Habit & 102 & 0.65 & 0.45 & 0 & 1 \\ 
Salary & 102 & 2.15 & 1.22 & 1 & 6 \\ 
Age & 102 & 39.74 & 18.89 & 18 & 85 \\ 
\hline \\[-1.8ex] 
\end{tabular} 
\end{table} 

\FloatBarrier

The correlation matrix for the individual characteristics is as follows :

*Add here a description for correlation table (maybe put the tables side by side ? add tests for correlation ?)*

\FloatBarrier

```{r OriginalDescriptiveStats_Ind_cor, results = "asis"}
# Individuals dataset
data_orig_ind_cor = data_orig_ind %>% 
    cor()

# Print results
output = capture.output(
    stargazer(
        data_orig_ind_cor,
        summary = FALSE,
        title = "AIndividual characteristics correlation matirx",
        header = FALSE
    )
)

# Clear results
output = str_replace_all(output, "\\$-\\$", "-")
cat(paste(output, collapse = "\n"), "\n")
```

\FloatBarrier

Each choice alternative is defined by three factors : price of the rose, varying by steps of 0.50€ in range between 1.50€ and 4.50€; information provided about the carbon footprint (greater or lower); and finally an eco-label describing the agricultural techniques implemented during the cultivation.

\FloatBarrier

\begin{table}[!htbp] \centering 
  \caption{Alternatives' attributes} 
  \label{} 
\begin{tabular}{@{\extracolsep{5pt}}lccccc} 
\\[-1.8ex]\hline 
\hline \\[-1.8ex] 
Statistic & \multicolumn{1}{c}{N} & \multicolumn{1}{c}{Levels} & \multicolumn{1}{c}{Min} & \multicolumn{1}{c}{Max} \\ 
\hline \\[-1.8ex] 
Price & 2448 & 7 & 1.5 & 4.5 \\ 
Label & 2448 & 2 & 0 & 1 \\ 
Carbon & 2448 & 2 & 0 & 1 \\
\hline \\[-1.8ex] 
\end{tabular} 
\end{table} 

\FloatBarrier

*Provide comments on alternatives' attributes descriptive statistics (here a table for "buy" alternative features*

*It appears that I've not taken into account the ommited observations ?*

\FloatBarrier

```{r OriginalDescriptiveStats_Alt, results = "asis"}
# Individuals dataset
data_orig_alt = data_orig %>% 
    filter(c == 0) %>%
    mutate(LC = label * carbon) %>%
    select(
        Price = price, 
        Label = label, # Not sure here 
        Carbon = carbon, 
        # Choice = , 
        LC
    )

# Print results
stargazer(
    data_orig_alt,
    title = "Original alternatives' attributes",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier

*Add comments on correlation (no correlation observed)*

\FloatBarrier

```{r OriginalDescriptiveStats_Alt_cor, results = "asis"}
# Individuals dataset
data_orig_alt_cor = data_orig_alt %>% 
    cor()

# Print results
output = capture.output(
    stargazer(
        data_orig_alt_cor,
        summary = FALSE,
        title = "Alternatives' attributes correlation matrix",
        header = FALSE
    )
)

# Clear results
output = str_replace_all(output, "\\$-\\$", "-")
cat(paste(output, collapse = "\n"), "\n")
```

\FloatBarrier

The experimental design used to generate the choice sets assumed no branding for the alternatives to avoid any undesired bias in the results.
Pairing of the binary attributes resulted in situation with only four different specifications for an alternative, which could be combined in six different choice sets (the ten othervise possible choice sets with identical products were excluded from the study).
The titles (A or B) inside agiven choice set were allocated randomly, as well as were the prices.
Theoretically this design should have provided an equilibrated dataset with no correlation among between different attributes, although the size of the final dataset migh have affected the results.

*Complete dataset descriptive statistics*

\FloatBarrier

```{r OriginalDescriptiveStats_Full, results = "asis"}
# Dataset subsetting
data_orig = data_orig %>%
    mutate(
        LC = label * carbon,
        buy_organic_nofood = buy_organic_nofood - 1
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
        LC
    )

# Stargazer output
stargazer(
    data_orig,
    title = "Descriptive statistics",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier



## Simulated dataset 

*It may be more concise to mergre some of the tables contrasting different datasets* 

First of all we present the dataset with relaxed ...

```{r ReadData}
# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("../../data/simulation/dataset.csv")  
```

```{r DataAdaptation, include = FALSE}
# Data adaptation

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
        Alternative = rep(c("A", "B"), length = nrow(dataset))
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

# Save dataset
# save(dataset, file = "../../data/simulation/dataset_mod.Rdata")
```

<!-- Brief glance at dataset - head() function with stargazer -->
<!-- Then descriptive statistics for this dataset -->
<!-- It may be usefull to include the variance covariance matrix as well to demonstrate the absence of correealtion -->

Descriptive statistics by individual :

\FloatBarrier

```{r DescriptiveStats_Ind, results = "asis"}
# Individuals dataset
dataset_ind = dataset %>% 
    distinct(ID, .keep_all = TRUE) %>%
    select(Sex, Habit, Salary, Age)

# Print results
stargazer(
    dataset_ind,
    title = "Individuals descriptive statistics",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier

Correlation matrix of the individual characteristics :


\FloatBarrier

```{r DescriptiveStats_Ind_cor, results = "asis"}
# Individuals dataset
dataset_cor_ind = dataset %>% 
    distinct(ID, .keep_all = TRUE) %>%
    select(Sex, Habit, Salary, Age) %>%
    cor()

# Print results
output = capture.output(
    stargazer(
        dataset_cor_ind,
        summary = FALSE,
        title = "AIndividual characteristics correlation matrix",
        header = FALSE
    )
)

# Clear results
output = str_replace_all(output, "\\$-\\$", "-")
cat(paste(output, collapse = "\n"), "\n")
```

\FloatBarrier

Print descriptive statistics of alternatives (over choice options only) :

\FloatBarrier

```{r DescriptiveStats_Alt, results = "asis"}
# Individuals dataset
dataset_alt = dataset %>% 
    filter(Age != 0) %>%
    select(Price, Label, Carbon, # Choice, 
        LC)

# Print results
stargazer(
    dataset_alt,
    title = "Alternatives' descriptive statistics",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier

Correlation matrix presentation for alternatives' features :

\FloatBarrier

```{r DescriptiveStats_Alt_cor, results = "asis"}
# Individuals dataset
dataset_cor_alt = dataset %>% 
    filter(Age != 0) %>%
    select(Price, Label, Carbon, # Choice, 
        LC) %>%
    cor()

# Print results
output = capture.output(
    stargazer(
        dataset_cor_alt,
        summary = FALSE,
        title = "Alternatives' attributes correlation matrix",
        header = FALSE
    )
)

# Clear results
output = str_replace_all(output, "\\$-\\$", "-")
cat(paste(output, collapse = "\n"), "\n")
```

\FloatBarrier

Finally we represent a complete dataset containing three possible alternatives for each choice set.
We set all variables equal to 0 for "No choice" alternative, as it is the reference alternative for our study and we are interested in contrasting the obseved effects for "Buy" choices agains this particular baseline.
It worth mentionning as well, that this table for the descriptive statistics takes into account the 0's mentionned.

\FloatBarrier

```{r DescriptiveStats_Full, results = "asis"}
stargazer(
    dataset,
    title = "Descriptive statistics",
    header = FALSE,
    omit.summary.stat = c("p25", "p75")
)
```

\FloatBarrier







<!-- ################################################################## -->
<!-- ################################################################## -->
<!-- ################################################################## -->

# *Combined data presentation*

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
    filter(Alternative != "C") %>%
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
    filter(
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
    filter(
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

\FloatBarrier

```{r Original, results = "asis"}
# Tableby transform
original_by = tableby(
    Alternative ~ Sex + Habit + Salary + Age +  
        Price + Label + Carbon + LC +
        Choice,
    data = original,
    total = FALSE
)

# Capturing arsenal output
original_alt = capture.output(
    summary(
        original_by,
        text = "latex"
    )
)

# Transforming and printing output
transform_arsenal(
    input = original_alt,
    position = "!htbp",
    caption = "Original dataset descriptive statistics by group",
    label = ""
)
```

\FloatBarrier

\FloatBarrier

```{r Generated, results = "asis"}
# Tableby transform
generated_by = tableby(
    Alternative ~ Sex + Habit + Salary + Age +  
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