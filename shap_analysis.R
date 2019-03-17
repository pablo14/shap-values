library(tidyverse)
library(xgboost)
library(caret)
source("shap.R")

##############################################
# How to calculate and interpret shap values
##############################################

load(url("https://github.com/christophM/interpretable-ml-book/blob/master/data/bike.RData?raw=true"))
#readRDS("bike.RData")

bike_2=select(bike, -days_since_2011, -cnt, -yr)

bike_dmy = dummyVars(" ~ .", data = bike_2, fullRank=T)
bike_x = predict(bike_dmy, newdata = bike_2)

## Create the xgboost model
model_bike = xgboost(data = bike_x, 
                   nround = 10, 
                   objective="reg:linear",
                   label= bike$cnt)  


cat("Note: The functions `shap.score.rank, `shap_long_hd` and `plot.shap.summary` were
originally published at https://github.com/liuyanguu/Blogdown/blob/master/hugo-xmag/content/post/2018-10-05-shap-visualization-for-xgboost.Rmd
All the credits to the author.")

## Calculate shap values
shap_result_bike = shap.score.rank(xgb_model = model_bike, 
                              X_train =bike_x,
                              shap_approx = F
                              )

# `shap_approx` comes from `approxcontrib` from xgboost documentation. 
# Faster but less accurate if true. Read more: help(xgboost)

## Plot var importance based on SHAP
var_importance(shap_result_bike, top_n=10)

## Prepare data for top N variables
shap_long_bike = shap.prep(shap = shap_result_bike,
                           X_train = bike_x , 
                           top_n = 10
                           )

## Plot shap overall metrics
plot.shap.summary(data_long = shap_long_bike)


## 
xgb.plot.shap(data = bike_x, # input data
              model = model_bike, # xgboost model
              features = names(shap_result_bike$mean_shap_score[1:10]), # only top 10 var
              n_col = 3, # layout option
              plot_loess = T # add red line to plot
              )


# Do some classical plots
# ggplotgui::ggplot_shiny(bike)
