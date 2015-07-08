# Set Working Directory to your Desired Path where data files are located
#setwd("C:/Users/mcohen/Documents/R/Dataiku")

######################################################################
# Read in data, tidy it up, summarize it graphically and numerically #
######################################################################

# Read in Census Learning Data
CenIncLearnDF = read.csv("census_income_learn.csv")

# Read in Names of Variables
VarNames = data.frame(read.csv("VarNames.csv"))

# Source function that prepares and visualizes the data
source("prepdata.R")
learn = prepdata(CenIncLearnDF,VarNames)

# Summarize Data
summary(learn)

###########################################################################
# Model the 50k over/under with cross-validated lasso-logistic regression #
###########################################################################

library(glmnet)

# For testing hypothesis about factors determining savings, specify a model that specifies arguably plausible variables
xfactors = model.matrix(dv ~ age + industry_disc + weeks_worked + education + marital_status + race + gender + 
                          capital_gains + capital_losses + stock_dividends + household_summary,learn)
x = as.matrix(data.frame(xfactors))
# logistic lasso regression with population weighting to approximate population inference
# First identify lambda that minimizes MSE - 3-folds to keep things moving...
cvmodel = cv.glmnet(x,y=learn[['dv']],weights = learn[['instance_weight']], alpha=1,family='binomial',nfolds=3)
plot(cvmodel,xvar="lambda")
coef(cvmodel)

# Document Mechanical Fit
learn.pred = table(predict(cvmodel,x,s="lambda.min",type = 'class'),learn[['dv']])
learn.error = 1-sum(diag(learn.pred))/sum(learn.pred)
print(learn.error)

###############################################
# Model the 50k over/under with decision tree #
###############################################

library(rpart)

# grow tree 
set.seed(345)
fit_tree = rpart(dv ~ age + industry_disc + weeks_worked + education + marital_status + race + gender + capital_gains + capital_losses + stock_dividends + household_summary,method="class",weights = learn[['instance_weight']], data=learn)
plot(fit_tree, uniform = TRUE)
text(fit_tree,use.n = TRUE, cex = 0.75)
summary(fit_tree)
plotcp(fit_tree)
printcp(fit_tree)

# Prune Tree
fit_tree2 = prune(fit_tree, cp = 0.012)
plot(fit_tree2, uniform = TRUE)
text(fit_tree2,use.n = TRUE, cex = 0.75)
summary(fit_tree2)

# Document Mechanical Fit
printcp(fit_tree2)

#################################
# Asses Models on Test data set #
#################################

# Read in Test Data
CenIncTestDF = read.csv("census_income_test.csv")

# Prepares and visualize the test data
test = prepdata(CenIncTestDF,VarNames)

# Assess logistic lasso prediction
xfactTest = model.matrix(dv ~ age + industry_disc + weeks_worked + education + marital_status + race + gender + 
                          capital_gains + capital_losses + stock_dividends + household_summary,test)
xtest = as.matrix(data.frame(xfactTest))
logit_test.pred = table(predict(cvmodel,xtest,s="lambda.min",type = 'class'),test$dv)
logit_test.error = 1-sum(diag(logit_test.pred))/sum(logit_test.pred)
print(logit_test.error)
  
# Assess Decision Tree Prediction
tree_test.class = table(predict(fit_tree2,test,type="class"),test$dv)
tree_test.error = 1-sum(diag(tree_test.class))/sum(tree_test.class)
print(tree_test.error)
