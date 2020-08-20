# To run this file we use this guide: http://www.r-datacollection.com/blog/making-r-files-executable/
# In short we :
#     1) Define new file type systemwide
#     2) Define R.exe as program by default to open this filetype
# For now it's a Windows compatible guide (there is still need to find something similar for Linux)
# Probably try this : http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/

# This file executes "./litterature_verification.R" script
# The script autocompiles reference tables for each subdirectory in "./litterature" folder
# It autocompiles the integral litterature reference file, as well as generates .pdf file with all entries
# The generating file is "./litterature/bibliographie.Rmd" for now 

# Announce execution
message("Working directory is : \n    ")
message(getwd())
message("\n \n")
message("The bibliography treatment is being executed... \n\n")

# Execute the script 
try(
    source("./code/litterature_verification.R", 
        local = TRUE)
)

# Inform about code completion
message("\n")
message("The bibliography treatment is complete !")

# Wait for the user before quit
Sys.sleep(3)