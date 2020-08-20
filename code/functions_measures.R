eval_performance = function(
    y_predicted,
    y_real,
    alpha = 1) {  # Alpha for balanced measures

        ########################
        # Confusion matrix based
        ########################

        # Check levels
        if (mean(levels(y_predicted) == levels(y_real)) != 1) {
            # Reorder levels if needed
            y_real = ordered(
                y_real, 
                levels = levels(y_predicted)
            )
        }

        # Confusion matrix generation
        conf_m = table(y_real, y_predicted)



        #################
        # General metrics
        #################

        # Empirical error rate (or Empirical risk)
        ERR = (sum(conf_m) - sum(diag(conf_m))) / sum(conf_m)
        # Accuracy
        AC = sum(diag(conf_m)) / sum(conf_m)



        ###########################
        # Variable specific metrics
        ###########################

        # Here we find a problem at defining true and false negatives 
        # There should be a way around it
        # The formulas below are not fully cmplete
        
        # True-positives 
        TP = diag(conf_m)
        names(TP) = colnames(conf_m)
        # False-positives
        FP = colSums(conf_m) - diag(conf_m)
        # False positives
        TN = vapply(
            diag(conf_m), 
            function(x) {sum(diag(conf_m)) - x}, 
            numeric(1)
        )
        names(TN) = colnames(conf_m)
        # False-negatives
        # FN = rowSums(conf_m) - diag(conf_m)
        FN = vapply(
            rowSums(conf_m) - diag(conf_m), 
            function(x) {sum(rowSums(conf_m) - diag(conf_m)) - x}, 
            numeric(1)
        )

        # True-positive rate (or Sensitivity)
        TPR = TP / (TP + FN)
        # False-positive rate
        FPR = FP / (FP + TN)
        # True-negative rate (or Specificity)
        TNR = TN / (TN + FP)
        # False-negative rate
        FNR = FN / (FN + TP)
        # Likelihood ratio +
        LRp = TPR / (1 - TNR)
        # Likelihood ratio -
        LRn = (1 - TPR) / TNR
        # Precision
        PPV = diag(conf_m) / colSums(conf_m)
        Prec = TP / (TP + FP)
        # Recall
        Rec = TP / (TP + FN)
        # Geometric mean 1
        GM_1 = sqrt(TPR * TNR)
        # Geometric mean 2
        GM_2 = sqrt(TPR * PPV)

        # F-measure (balanced variant)
        a = alpha # Setting ponderation parameter (1 for balanced type)
        F_a = (1 + a)*(Prec * Rec) / (a*Prec + Rec)
        # Class ratio
        r = (TP + FN) / (FP + TN)



        ############################
        # Probability based measures
        ############################

        # First version
        # Get probabilities
        input_p = summary(y_real) / length(y_real)
        out_p = summary(y_predicted) / length(y_predicted)
        # Kullback–Leiblerdivergence (KL divergence or Relative Entropy)
        KL = LaplacesDemon::KLD(
            px = out_p,
            py = input_p
        )

        # Second version
        # Get probabilities in matrix format (taking into account the missclassification)
        lev = length(unique(y_real))
        input_pm = matrix(0, nrow = lev, ncol = lev) 
        diag(input_pm) = summary(y_real) / length(y_real)
        out_pm = conf_m / sum(conf_m)
        # Relative Entropy (KL Divergence)
        RE = LaplacesDemon::KLD(
            px = out_pm,
            py = input_pm
        )



        ##################
        # Output eneration 
        ##################

        # Output list generation
        output = list()

        # List composition
        output$ERR = ERR 
        output$AC = AC 
        output$TP = TP 
        output$FP = FP 
        output$TN = TN 
        output$FN = FN
        output$TPR = TPR
        output$FPR = FPR
        output$TNR = TNR
        output$FNR = FNR
        output$LRp = LRp
        output$LRn = LRn
        output$Precision = Prec
        output$Recall = Rec
        output$GeomMean1 = GM_1
        output$GeomMean2 = GM_2
        output$Fmeasure = F_a
        output$ClassRatio = r
        output$KLDvec = KL
        output$KLDmat = RE

        # Adding confusion matrix
        output$CM = conf_m

        # Return
        return(output)
    }