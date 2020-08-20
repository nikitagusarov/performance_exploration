#################################################################
# Transformation function from arsenal style to stargazer style #
#################################################################

transform_arsenal = function(
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