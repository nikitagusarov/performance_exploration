# This code is made to manage the litterature directory

# Featuring :
# - Automated synthese presence verification
# - Automated litterature table creation

# Loading packages
cat("Loading packages ... \n")
library(tidyverse)

# Get subdirectories in "litterature"
cat("Reading directories tree ... \n")
dirs = list.dirs("./litterature/", recursive = FALSE)

# Get a list of .pdf files for each subdirectory
cat("Reading .pdf files ... \n")
# Define type
files = list()
# Read files
for (i in 1:length(dirs)) {
    files[[i]] = list.files(dirs[i], pattern = "*.pdf")
    files[[i]] = substr(files[[i]], 1, nchar(files[[i]]) - 4)
}

# Get a list of .md files from each "synt"
cat("Reading synthese files ... \n")
# Define type
synts = list()
# Read files
for (i in 1:length(dirs)) {
    synts[[i]] = list.files(paste0(dirs[i], "/synt"), pattern = ".md")
    synts[[i]] = substr(synts[[i]], 1, nchar(synts[[i]]) - 3)
}

# Get a list of bibliography entries
cat("Reading bibliography ... \n")
# Create file
biblio = list()
# Create empty lines to separate parts
empty = c(
    "",
    "",
    "",
    "",
    ""
)
# Read files
for (i in 1:length(dirs)) {
    # Read file (try allows to continue on error)
    try({
        rlines = readLines(paste0(dirs[i], "//biblio.bib"))
    }, silent = TRUE)
    # Verify contents
    if (exists("rlines") == TRUE) {
        biblio[[i]] = append(rlines, empty)
    } else {
        biblio[[i]] = c("", "", "")
    }
    # Clear environment
    rm(rlines)
}
# Identifiers
cat("Separating bibentries identifiers ... \n")
# Aux object
entries = list()
# Select only identifiers
for (i in 1:length(biblio)) {
    # Find entry lines
    elines = biblio[[i]][grepl("^@.*\\{.*", biblio[[i]])]
    # Clear entry lines
    entries[[i]] = str_match(elines, "^@.*\\{(.*?),")[,2]
}

# Create a correspondence table for each subdirectory
cat("Subdirectory mapping to tables ... \n")
# Data type
tables = list()
# Merge corresponding entries
for (i in 1:length(dirs)) {
    # Define entries
    set_entries = union(files[[i]], entries[[i]])
    set_entries = union(set_entries, synts[[i]])
    # Check document presence
    Doc = set_entries %in% files[[i]]
    # Check entries presence
    Entr = set_entries %in% entries[[i]]
    # Check synthese presence
    Synt = set_entries %in% synts[[i]]
    # Get subdirectory
    Xdir = substr(dirs[i], 16, nchar(dirs[i]))
    # Create tables
    tables[[i]] = data.frame(
        Type = rep(Xdir, length(set_entries)),
        Refrence = set_entries,
        Fichier = as.integer(Doc),
        Bibentry = as.integer(Entr),
        Synthese = as.integer(Synt)
    )
    # Remove AUX
    rm(set_entries,
        Doc, Entr, Synt, Xdir)
}
# Write tables
cat("Writting tables ... \n")
for (i in 1:length(dirs)) {
    write.csv2(file = paste0(dirs[i], "//ref_table.csv"), tables[[i]], row.names = FALSE)
}

# Create an integral table for all litterature
cat("Mapping generalisation ... \n")
complete_table = do.call("rbind", tables)
# Write table
write.csv2(file = "./litterature/ref_table.csv", complete_table, row.names = FALSE)

# Complete full bibliography file
cat("Generalising bibliography ... \n")
# Merge bibliography files
complete_biblio = unlist(biblio)

# Verification part (not run)
# Read biblio
# bib = readLines("./litterature/bibliographie.bib")
# Difference
# View(diff <- setdiff(complete_biblio, bib))

# Write bibliography
writeLines(complete_biblio, "./litterature/bibliographie.bib")

# Insert collected identifiers into bibliography generating .Rmd file
# Set yaml header
# yaml = c(
#     "---",
#     "title: \"Bibliograhie\"",
#     "output: ", 
#     "    pdf_document:",
#     "        keep_tex: false",
#     "bibliography: bibliographie.bib",
#     "---",
#     "",
#     "",
#     ""
# )
# Apparently there is no need to recreate .Rmd file (for now)

# Run .Rmd to generate bibliographie.pdf
cat("Rendering bibliography to pdf ... \n")
rmarkdown::render("./litterature/bibliographie.Rmd", encoding = "UTF-8")