This repository contains the backround code of: 
[How to intepret SHAP values in R](https://blog.datascienceheroes.com/how-to-interpret-shap-values-in-r/)


To execute this project, open and run `shap_analysis.R` (wich loads `shap.R`). 

It will load the `bike` dataset, do some data preparation, create a predictive model (xgboost), obtaining the SHAP values and then it will plot them:



<img src="https://blog.datascienceheroes.com/content/images/2019/03/shap_summary_bike.png" alt="Shap summary" width="400px">


<img src="https://blog.datascienceheroes.com/content/images/2019/03/shap_value_all.png" alt="Shap summary" width="400px">

It is easy to reproduce with other data. Have fun!

