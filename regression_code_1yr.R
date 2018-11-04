### These codes compute standard and penalized regressoin models using 2012 data to predict 2013 health care costs  ###

install.packages("dplyr")
library(dplyr)
install.packages("glmnet")
library(glmnet)

#  function for measureing model performance
performance<-function(df_preds, df_actual){
  dual<-cbind(df_preds, df_actual)%>% mutate(decile = ntile(preds, 10)) 
  dual %>%summarize(
    ct=n(), mean_preds=mean(preds), mean_actual=mean(actual),
    r2=1-sum((preds-actual)^2)/sum((actual-mean(actual))^2), 
    rmse=sqrt(sum((preds-actual)^2)/ct),
    mape=mean(abs(preds-actual)), 
    predictive_ratio=mean_preds/mean_actual
  )->summ
  
  dual %>% group_by(decile) %>% 
    summarize(
      ct=n(), mean_preds=mean(preds), mean_actual=mean(actual),
      rmse=sqrt(sum((preds-actual)^2)/ct),
      mape=mean(abs(preds-actual)), 
      predictive_ratio=mean_preds/mean_actual
    )->summ_decile
  print(summ)
  print(summ_decile)
}

### test standard linear regression on the full set of 2012 predictors

load("trainset_fullset_1yr.Rdata")
load("testset_fullset_1yr.Rdata")

lmfit<-lm(total_allowed_2013 ~ ., data = trainset_fullset_1yr)
preds<-predict(lmfit, newdata = testset_fullset_1yr)
df_preds<-as.data.frame(preds)
df_actual<-as.data.frame(testset_fullset_1yr[1])%>%rename(actual=total_allowed_2013)
performance(df_preds, df_actual)


### Penalized regression of health care costs on 1 year of prior data

# Lasso regression
y<-trainset_fullset_1yr$total_allowed_2013
x<-as.matrix(trainset_fullset_1yr[-1])
nx<-as.matrix(testset_fullset_1yr[-1])

set.seed(123)
cv.penalizedmmod<-cv.glmnet(x, y, alpha=1,  family="gaussian", standardize=T)
# coefficents for standard linear regression with predictors selected by lasso
coef<-coef(cv.penalizedmmod, s="lambda.min")
coefselected<-x[,coef@i]

penalizedmmod<-glmnet(x, y, alpha=1,  family="gaussian", lambda=cv.penalizedmmod$lambda.min, standardize=T)
df_actual<-as.data.frame(testset_fullset_1yr[1])%>%rename(actual=total_allowed_2013)
df_preds<-as.data.frame(predict(penalizedmmod, newx = nx))%>%rename(preds=s0)
performance(df_preds, df_actual)

# elastic net and ridge regression
for (i in c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9)) {
  set.seed(123)
  cv.penalizedmmod<-cv.glmnet(x, y, alpha=i,  family="gaussian", standardize=T)
  penalizedmmod<-glmnet(x, y, alpha=i,  family="gaussian", lambda=cv.penalizedmmod$lambda.min, standardize=T)
  df_preds<-as.data.frame(predict(penalizedmmod, newx = nx))%>%rename(preds=s0)
  cat("Model performance: alpha = ", i, "\n")
  performance(df_preds, df_actual)
}

### test standard linear regerssion on 2012 predictors selected by lasso regression with lambda.min

load("trainset_reducedset_1yr.Rdata")
load("testset_reducedset_1yr.Rdata")

lmfit_reducedset_1yr<-lm(total_allowed_2013 ~ ., data = trainset_reducedset_1yr)
preds<-predict(lmfit_reducedset_1yr, newdata = testset_reducedset_1yr)
df_preds<-as.data.frame(preds)
performance(df_preds, df_actual)
