# FinancialAnalytics-Backtesting
Hi all, this is a Financial Analytics Project ! - Backtesting with Simple Moving Average (SMA) trading strategy.


### Project Objective

* The purpose of this project is to apply backtesting with Simple Moving Average (SMA) trading strategy in order to understand  the performance of a strategy or model if it had been employed during a past period. 


### Methods Used

* Simple moving average crossing (SMA):

  -  Simple Moving Average (SMA) is an arithmetic moving average calculated by adding the closing price of the security for a number of time periods and then dividing this total by the number of time periods. Most traders watch for short-term averages to cross above longer-term averages to signal the beginning of an uptrend. Short-term averages can act as levels of support when the price experiences a pullback.


### Technologies and Packaged Used

* Statistical Analysis System (SAS)
* SAS: Macro
* SAS: Sgplot
* SAS: SQL

### Project Description

* Motivation:
  - In general, a moving average helps cut down the amount of **noise** on a price chart. Look at the the direction of the moving average to get a basic idea of which way the price is moving. For instance, if the angle goes up, the price is moving up (or was recently) overall. On the other hand, if the angle goes down, then the price is moving down (or was recently) overall. If it moves sideways, the price is likely in a range. From those information, I can utilize the feature to help with the trading decision.
  
* Data and Scope:
  - Here, I download three representative stocks of different industries and also one index from **1/1/2010 to 11/30/2018** via Yahoo Finance. They are Apple Inc. **(APPL)**, General Electric Company **(GE)**, Morgan Stanley **(MS)** and **S&P 500 (^GSPC)**. 

* Methodology Approach:
  a. In the beginning, I import and convert all csv files downloaded from Yahoo Finance into SAS files. 
  b. After that, I calculate their basic statistical analysis and plot time series for easy understanding.
  c. Furthermore, I create and add two additional moving average curves which are “SMA_Short” and “SMA_Long” with “Date” and “Close” as variables into the model (50 days for short term and 200 days for long term).

* Conclusion:







