##########################################################
# Testing arsenal wrapper to get results as in stargazer #
##########################################################



#################
# Attach packages
#################

# Load package for reading Stata files
library(foreign)
library(arsenal)
# Rescaling library
# library(scales)



##################
# Original dataset
##################

# Read Stata file
data_orig = read.dta("data/roses/r.dta") 

# Modify dataset
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



###################
# Resulting dataset
###################

# Reading data
dataset = # read.csv2("../../../../data/simulation/dataset.csv") 
    read.csv("data/simulation/dataset.csv") 

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
        Alternative = rep(c("A", "B"), length = nrow(dataset))
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
        Alternative = as.factor(Alternative)
    )
## Clear environment
rm(dverif, dsubset)



###########################
# Treatment and combination
###########################

# Individuals dataset
dataset_ind = dataset %>% 
    distinct(ID, .keep_all = TRUE) %>%
    select(Sex, Habit, Salary, Age) %>%
    mutate(
        Data = "synt"
    )

# Combine dataframez
combined_ind = full_join(
    data_orig_ind,
    dataset_ind
)

# Create tableby onject
combined_ind_by = tableby(
    Data ~ Sex + Habit + Salary + Age,
    data = combined_ind,
    total = FALSE
)



###################
# Exploring results
###################

# Summary for arsenal
capture_1 = capture.output(
    summary(
        combined_ind_by,
        text = "latex"
    )
)
# Testing
capture_2 = capture.output(
    stargazer(
        combined_ind,
        header = FALSE
    )
)

# capture_1 
# capture_2



#########################
# Transformation function
#########################

transform = function(
    input = capture_1,
    position = "!htbp",
    caption = "Table",
    label = ""
) {
    # Read input object
    ## Begin environment line
    begin_line = gsub(
        "\\\\begin\\{tabular\\}",
        "",
        input[2]
    )
    begin_line = gsub(
        "\\||\\{",
        "",
        begin_line
    )
    begin_line = paste0(
        "\\begin{tabular}{@{\\extracolsep{5pt}}",
        begin_line
    )
    colnames_line = input[4]

    # Upper part
    upper = c(
        "",
        paste0("\\begin{table}[", position, "] \\centering "),
        paste0("  \\caption{", caption, "} "),
        paste0("  \\label{", label, "} "),
        begin_line,
        "\\\\[-1.8ex]\\hline ",
        "\\hline \\\\[-1.8ex] ",
        colnames_line,
        "\\hline \\\\[-1.8ex] "
    )

    # Main part 
    main = input[-c(1:5, 
        (length(input) - 2):length(input)) ]
    main = main[main != "\\hline"]

    # Lower part
    lower = c(
        "\\hline",
        "\\end{tabular}",
        "\\end{table}",
        ""
    )

    # Combine
    output = c(
        upper, 
        main, 
        lower
    )
    output = paste(output, sep = "\n")

    # Return
    cat(
        output,
        sep = "\n"
    )
}