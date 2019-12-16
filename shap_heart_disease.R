library(tidyverse)
library(funModeling)
library(xgboost)
library(caret)
source("shap.R")

## Some data preparation
heart_disease_2=select(heart_disease, -has_heart_disease, -heart_disease_severity)

dmytr = dummyVars(" ~ .", data = heart_disease_2, fullRank=T)
heart_disease_3 = predict(dmytr, newdata = heart_disease_2)
target_var=ifelse(as.character(heart_disease$has_heart_disease)=="yes", 1,0)

## Create the xgboost model
model_hd = xgboost(data = heart_disease_3,
                   nround = 10,
                   objective = "binary:logistic",
                   label= target_var)  

## Calculate shap values
shap_result = shap.score.rank(xgb_model = model_hd, 
                              X_train = heart_disease_3,
                              shap_approx = F)

## Plot var importance
var_importance(shap_result, top_n=10)

## Prepare shap data
shap_long_hd = shap.prep(X_train = heart_disease_3 , top_n = 10)

## Plot shap overall metrics
plot.shap.summary(data_long = shap_long_hd)

# Note: The functions shap.score.rank, shap_long_hd and plot.shap.summary were 
# originally published at https://liuyanguu.github.io/post/2018/10/14/shap-visualization-for-xgboost/
# All the credits to the author.


## Shap
xgb.plot.shap(data = heart_disease_3, 
              model = model_hd, 
              features = names(shap_result$mean_shap_score)[1:10], 
              n_col = 3, 
              plot_loess = T)


################################
# Dowload the file from here: 
# https://github.com/christophM/interpretable-ml-book/blob/master/data/bike.RData
load("bike.RData")
bike_2=select(bike, -days_since_2011, -cnt, -yr)

bike_dmy = dummyVars(" ~ .", data = bike_2, fullRank=T)
bike_x = predict(bike_dmy, newdata = bike_2)


## Create the xgboost model
model_bike = xgboost(data = bike_x, 
                   nround = 10, 
                   objective="reg:linear",
                   label= bike$cnt)  



## Calculate shap values
shap_result_bike = shap.score.rank(xgb_model = model_bike, 
                              X_train =bike_x,
                              shap_approx = F
                              )


# `shap_approx` comes from `approxcontrib ` from xgboost documentation. 
# Faster but less accurate if true. Read more: help(xgboost)


## Plot var importance
var_importance(shap_result_bike, top_n=10)

## Prepare shap data
shap_long_bike = shap.prep(X_train = bike_x , top_n = 10)

## Plot shap overall metrics
plot.shap.summary(data_long = shap_long_bike)


## 
xgb.plot.shap(data = bike_x, 
              model = model_bike, 
              features = names(shap_result_bike$mean_shap_score[1:10]), 
              n_col = 3, plot_loess = T)



ggplotgui::ggplot_shiny(bike)
