Files Contained in Repository:

DATA FILES:
census_income_learn.csv - census income data sample from 1994 and 1995 for model training and validation
census_income_test.csv - census income data sample from 1994 and 1995 for model testing
census_income_metadata.txt - describes the data fields and values contained in the learn and test data 
VarNames.csv - Names of the variables contained in the census income data according to metadata, as well as a field that takes the value false in the variable is a continuous numeric variable and true otherwise

R FUNCTIONS:
main.R - is the main script for the assessment of the data, modeling of the data, and assessment of the trained models on the test sample. 
prepdata.R - is a function designed for the DATA FILEs listed above. The function does many things inclduding: replace missing values with NA, print the % of missing values for each variable, fixes the names in the original data files to intuitive and simple names defined in VarNames.csv, converts categorical vairables in to R "factor" variables, plots frequency bar graphs for categorical variables, plots histograms for continuous variables, normalizes continuous variables to make model coefficient interpretation easier without loss of generality. 

Synopsis of Approach:

Procedure:
1. Set working directory
2. Read in learning data 
3. Audit data it for abnormalities, inconsistencies, outliers, empirical moments. document these features with histograms bar charts, moments, quantiles, ranges, frequencies, etc.
3. Simultaneously, prepare data for modeling, properly identify variables, missing, values, and variable types.
4. Specify a non-exhaustive set of variables to consider for modeling the likelihood of saving more than $50k
5. Train a logistic regression using a lasso penalization (L1, penalization to reduce model complexity to identify a reasonable size set of predictive variables). Use an k-fold cross-validation procedure to determine penalization parameter for parsimonious model. The data set appears to come with sampling weights for each respondent, specify those observation weights to improve population inference.
6. Print out mechanical fit of model for learning sample 
7. Train a classification tree on same variable set.
8. Plot the complexity parameter against number of branches to determine cp parameter.
9. Prune the tree according to the complexity parameter identified from the plot analysis above.
10. Document the model's mechanical fit on the learning data for comparison to other methods
11. compare the implied realitive importance of the variables in each model
12. Read in test data 
13. Audit it for abnormalities, inconsistencies, outliers, empirical moments. document these features with histograms bar charts, moments, quantiles, ranges, frequencies, etc.
14. Test the fit of the logistic regression model on the test data
15. Test the fit of the classification tree on the test data
16. Compare the fit using each modeling method
17. In addition to model fit, one can also compare a model trained on test data to the models trained on the learn data to see if there are any substantial parametric, or structural differences in the results.

Challenges:
1. Identifying and Rectifying Variable Names
2. Identifying continuous from categorical variables (Not difficult just time consuming)
3. Knowing when to move on to the next step in the analysis (very tempted to thoroughly iron out the model and spend more time testing model hypothesis, or to spend more time on sharpening and improving visualizations).
4. Limited time to consider more sophisticated models, particularly those that model heterogeneity variable importance. 
 

Insights: 
1. The results indicate that the variables most indicative of savings over $50k are: age, weeks_worked, 4yr university degree or higher, capital fluctuation (gains, loses, dividends). Race did not seem to play a big role and neither does employment status, though these variables are likely to have a stronger correlation in isolation due to their strong correlation with other socio-economic factors.

2. By and large, the two approaches yield similar finding with respect to strength of relationships and relative importance of predictive variables. Both identified stock dividends has being important variables though the logisitic regression shows that on the margin savings drastically increases in the magnitude of stock dividends.

3. Both the classification model and the logistic regression perform well with an similar misclassification error in the 5% range, though on both training and test data sets the logistic slightly outperforms the classification tree. It would be interesting so see how approaches designed to improve fit further, for example random forest versus random parameters logistic models, would compare.
 

