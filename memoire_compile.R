######################
# COMPILATION SCRIPT #
######################

# THIS METHOD HAS A PROBLEM WITH PAGE COUNT !!!

# This script generates and compiles everything in the subfolders
# It is deviced to be called through a bash script, that will then compile all subfolder documents into a single one

# Test





################
# Introduction #
################

# Define variables 
cat("Reading variables ... \n")
## Working directory (should end with "/")
directory = "./memoire"
## Ordered set of folders to read 
folders = c(
    "the_introduction",
    "the_story",
    "the_application",
    "the_data",
    "the_modelisation",
    "the_performance",
    "the_conclusion",
    "annexes"
)
# ## Add annexes 
# annexes = c(
#     "annexes"
# )
## fin_output file name
fin_output = "compiled"
title = "memoire"

# Load packages
library(pdftools)
library(doParallel)

# Setup multitread
registerDoParallel(cores = 4)

# Create vector of paths
paths = paste0(directory, "/", folders)

# Get a list of .Rmd files for each subdirectory
cat("Reading .Rmd files ... \n")
## Define type
files = list()
## Read files
for (i in 1:length(paths)) {
    files[[i]] = list.files(
        paths[i], 
        pattern = "*.Rmd"
    )
}
# ## Annexes
# ax_path = paste0(directory, "/", annexes)
# ## Readfiles
# ax = c()
# for (i in 1:length(ax_path)) {
#     ax[i] = list.files(
#         ax_path[i], 
#         pattern = "*.Rmd"
#     )
# }





###########################
# RMarkdown based version #
###########################

# Run .Rmd's and render them
cat("Rendering found .Rmd files ... \n")
## This structure is not efficient when one folder contains multiple files
invisible(
    foreach (i = 1:length(files)) %dopar% { # For each folder
        for (j in 1:length(files[[i]])) { # For each file
            tryCatch({
                rmarkdown::render(
                    paste0(
                        paths[[i]], "/",
                        files[[i]][j]
                    ), 
                    encoding = "UTF-8"
                )
            }, 
            error = function(e) {
                cat(
                    "ERROR :", 
                    conditionMessage(e), 
                    "\n"
                )
            })
        }
    }
)
# ## For annexes
# invisible(
#     foreach (i = 1:length(annexes)) %dopar% { # For each folder
#         rmarkdown::render(
#             paste0(
#                 ax_path, "/",
#                 ax[i]
#             ), 
#             encoding = "UTF-8"
#         )
#     }
# )

# To compile into single .tex file
cat("Compile unique .Rmd file ... \n")
## Define files
to_combine = paste0(
    paths, "/",
    files
)
## Genrate aux
contents = list()
## Empty separators
empty = c(
    "",
    "",
    "",
    "",
    ""
)
## Read files
for (i in 1:length(paths)) {
    # Read file (try allows to continue on error)
    try(
        {rlines = readLines(to_combine[i])}, 
        silent = TRUE
    )
    # Modify files
    if (i == 1) {
        contents[[i]] = append(
            rlines[
                1:length(rlines)
            ], 
            empty
        )
    } else {
        contents[[i]] = append(
            rlines[
                50:length(rlines)
            ], 
            empty
        )
    }
    # Clear workspace
    rm(rlines)
}

# Create single .Rmd file
cat("Merge single file ... \n")
## Merge .tex
complete = unlist(contents)
## Write file
writeLines(
    complete, 
    paste0(
        directory, "/", 
        fin_output, "/", 
        fin_output, ".Rmd"
    )
)

# Render RMarkdown file
## File to render
rmdfile = paste0(
    directory, "/", 
    fin_output, "/",
    fin_output, ".Rmd"
)
## Render
rmarkdown::render(
    rmdfile, 
    encoding = "UTF-8"
)
## Publish to root folder 
file.copy(
    from = "./memoire/compiled/compiled.pdf", 
    to = "./"
)
## Rename publish 
file.rename(
    from = "./compiled.pdf", 
    to = "./Memoire M2 (Gusarov N).pdf"
)

# ## Append annexes
# ## This version does not allow more than one .pdf per folder !!!
# to_combine = c(
#     paste0(
#         directory, "/", 
#         fin_output, "/",
#         fin_output, ".pdf"
#     ),
#     paste0(
#         ax_path, "/",
#         annexes, ".pdf"
#     )
# )
# ## Combine
# pdf_combine(
#     to_combine, 
#     output = paste0(
#         directory, "/", 
#         title, ".pdf"
#     )
# )






# ########################
# # PDF based generation #
# ########################

# # Run .Rmd's and render them
# cat("Rendering found .Rmd files ... \n")
# ## This structure is not efficient when one folder contains multiple files
# invisible(
#     foreach (i = 1:length(files)) %dopar% { # For each folder
#         for (j in 1:length(files[[i]])) { # For each file
#             rmarkdown::render(
#                 paste0(
#                     paths[[i]], "/",
#                     files[[i]][j]
#                 ), 
#                 encoding = "UTF-8"
#             )
#         }
#     }
# )

# # Get a list of .pdf files for each subdirectory
# cat("Reading generated .pdf files ... \n")
# ## Define type
# files = list()
# ## Read files
# for (i in 1:length(paths)) {
#     files[[i]] = list.files(
#         paths[i], 
#         pattern = "*.pdf"
#     )
# }

# # Combine .pdf files into single fin_output
# ## Create file list
# ## This version does not allow more than one .pdf per folder !!!
# to_combine = paste0(
#     paths, "/",
#     files
# )
# ## Combine
# pdf_combine(
#     to_combine, 
#     fin_output = paste0(
#         directory, "/", 
#         fin_output, "/", 
#         fin_output, ".pdf"
#     )
# )





# ###############
# # Another way #
# ###############

# # This version requires "tex = TRUE" option !!!

# # Run .Rmd's and render them
# cat("Rendering found .Rmd files ... \n")
# ## This structure is not efficient when one folder contains multiple files
# invisible(
#     foreach (i = 1:length(files)) %dopar% { # For each folder
#         for (j in 1:length(files[[i]])) { # For each file
#             rmarkdown::render(
#                 paste0(
#                     paths[[i]], "/",
#                     files[[i]][j]
#                 ), 
#                 encoding = "UTF-8"
#             )
#         }
#     }
# )

# # Get a list of .tex files for each subdirectory
# cat("Reading generated .tex files ... \n")
# ## Define type
# files = list()
# ## Read files
# for (i in 1:length(paths)) {
#     files[[i]] = list.files(
#         paths[i], 
#         pattern = "*.tex"
#     )
# }

# # To compile into single .tex file
# cat("Compile unique .tex file ... \n")
# ## Define files
# to_combine = paste0(
#     paths, "/",
#     files
# )
# ## Genrate aux
# contents = list()
# ## Empty separators
# empty = c(
#     "",
#     "",
#     "",
#     "",
#     ""
# )
# ## Read files
# for (i in 1:length(paths)) {
#     # Read file (try allows to continue on error)
#     try(
#         {rlines = readLines(to_combine[i])}, 
#         silent = TRUE
#     )
#     # Modify files
#     if (i == 1) {
#         contents[[i]] = append(
#             rlines[
#                 1:(which(rlines == "\\end{document}") - 1)
#             ], 
#             empty
#         )
#     } else if (i == length(paths)) {
#         contents[[i]] = append(
#             rlines[
#                 (which(rlines == "\\begin{document}") + 1):
#                 (which(rlines == "\\end{document}"))
#             ], 
#             empty
#         )
#     } else {
#         contents[[i]] = append(
#             rlines[
#                 (which(rlines == "\\begin{document}") + 1):
#                 (which(rlines == "\\end{document}") - 1)
#             ], 
#             empty
#         )
#     }
#     # Clear workspace
#     rm(rlines)
# }

# # Create single .tex file
# cat("Merge single file ... \n")
# ## Merge .tex
# complete = unlist(contents)
# ## Write file
# writeLines(
#     complete, 
#     paste0(
#         directory, "/", 
#         fin_output, "/", 
#         fin_output, ".tex"
#     )
# )

# # Render LaTeX file
# ## File to render
# texfile = paste0(
#     directory, "/", 
#     fin_output, "/",
#     fin_output, ".tex"
# )
# ## Render
# ### Stewd
# setwd(paste0(
#     directory, "/", 
#     fin_output))
# ### Final
# system2("pdflatex", args = paste0(fin_output, ".tex"))
# # system2("rubber", args = paste0("--clean", fin_output)) - getopt error
# ### Reset WD
# setwd("../../")