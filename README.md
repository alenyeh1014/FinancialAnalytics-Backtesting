# FinancialAnalytics-Backtesting
Hi all, this is a Financial Analytics Project ! - Backtesting with Simple Moving Average (SMA) trading strategy.


### Project Objective

* The purpose of this project is to apply backtesting with Simple Moving Average (SMA) trading strategy in order to understand  the performance of a strategy or model if it had been employed during a past period. 


### Methods Used

* Simple Moving Average (SMA):

  -  Simple Moving Average (SMA) is an arithmetic moving average calculated by adding the closing price of the security for a number of time periods and then divide the total by the number of time periods. Most traders look for **short-term averages to cross above long-term averages to signal the beginning of an uptrend**. Short-term averages can act as levels of support when the price experiences a pullback.


### Technologies and Packages Used

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
  - In the beginning, I import and convert all csv files downloaded from Yahoo Finance into SAS data. 
  - After that, I calculate their basic statistical analysis and plot time series for easy understanding.
  - Furthermore, I create and add two additional moving average curves which are **“SMA_Short”** and **“SMA_Long”** with **“Date”** and **“Close”** as variables into the model **(50 days for short term and 200 days for long term)**.
  - In addition, I point out the interactions of **"SMA_Short"** curve and **"SMA_Long"** curve and label them as **“Buy”** and **“Sell”** signals for traders.
  - Finally, I compare the results between applying SMA trading strategy or just holding the stock.

### Conclusion:
  - Most of the time, implementing SMA trading strategy can only earn little profit, which is much less than just holding the stocks (for some stocks applying SMA will even loss money). The possible reason is **the way I generate SMA curves with too many days and this result may cause SMA trading strategy to become less sentative**. Therefore, I should use shorter periods for both short term and long term in order to obtain a better performance.
  
  - Meanwhile, for the stocks grow rapidly such as **AAPL**, SMA will miss the best opportunity to get in the market; for the stocks have great volatility on their prices such as **GE**, SMA would not act in time before the market trend changes. To sum up, even though some results can be distinguished with SMA trading strategy, more modifications are needed.






