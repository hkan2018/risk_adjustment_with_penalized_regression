# Exploring the use of machine learning for risk adjustment: a comparison of standard and penalized linear regression models in predicting health care costs in older adults
This study conducted a detailed comparison of standard and penalized linear regression of health care costs on features from the previous years including age, sex and clinical features. Clinical features included high-level groups of diagnosis codes (EDCs) and drug codes (RxMGs). There are 2 sets of R codes: <br/><br/>
    1. Regression_code_1yr.R for standard and penalized regression of 2013 health care costs on 2012 features. <br/><br/>
    2. Regression_code_4yrs.R for standard and penalized regression of 2013 health care costs on 2009-2012 features. <br/><br/>
The codes estimated standard, lasso, ridge, and elastic net linear regression models and compared their performance in the entire test sample as well as by deciles of predicted costs in the test sample. Penalized linear regression was first estimated using 10-fold cross-validation. The value of lambda that resulted in minimum mean squared error was used to re-estimate the model in the entire training sample. Model performance was evaluated in the test sample with R squared, root mean squared error, mean absolute prediction error, and prediction ratio. 
# Requirement
R package “glmnet.”
# How to execute
Users need to create high-level groups of diagnosis codes and drug codes. They do not need to be EDCs and RxMGs from the Johns Hopkins Adjusted Clinical Groups® (ACG®) System. Any standard groupers such as Clinical Classifications Software (CCS) from the Healthcare Cost and Utilization Project (HCUP) for grouping diagnosis codes can work. Users need to generate input features for training and test samples before applying the codes.
