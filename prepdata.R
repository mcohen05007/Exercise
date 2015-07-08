prepdata = function(CenIncLearnDF,VarNames){
  vnames = as.character(VarNames$Variable)
  
  # Rename vairables, plot 
  for (ii in 1:ncol(CenIncLearnDF)){
    # Replace missing values denoted as question mark with NA
    ind = CenIncLearnDF[ii]==" ?"
    is.na(CenIncLearnDF[ii])=ind
    percent_missing = sum(ind)/length(ind)
    cat("variable name: ",vnames[ii], fill = TRUE)
    cat("Missing ",floor(100*percent_missing),"%", fill = TRUE)
    names(CenIncLearnDF)[ii]=vnames[ii]
    if (VarNames$Cardinal[ii]){
      CenIncLearnDF[ii]=factor(CenIncLearnDF[[ii]])
      # Plot freq of factors
      plot(CenIncLearnDF[ii],main = vnames[ii])
    }else{
      # Plot distribution of continuous numeric values
      hist(as.numeric(CenIncLearnDF[[ii]]),main = vnames[ii])
      # Normalize continuous variables to ease results comparison
      CenIncLearnDF[ii]=as.numeric(CenIncLearnDF[[ii]])/max(as.numeric(CenIncLearnDF[[ii]]))
    }
  }
  return(CenIncLearnDF)
}