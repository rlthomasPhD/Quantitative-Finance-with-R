#==================================================#
#                                                  #
#Video7.5 - Benefits and Pitfalls of VaR           #
#                                                  #
#==================================================#

if (!require("quantmod")) {
  install.packages("quantmod")
  library(quantmod)
}
if (!require("PerformanceAnalytics")) {
  install.packages("PerformanceAnalytics")
  library(PerformanceAnalytics)
}

#==================================================#
#Task 1 - ES Calculation                           #
#==================================================#
#get prices from Yahoo for S&P500 (GSPC is the ticker)
start <- as.Date("2018-01-01")
end <- as.Date("2018-11-01")
getSymbols("^gspc", src = "yahoo", from = start, to = end)
GSPC.prices <- na.omit(GSPC[, "GSPC.Adjusted"])
GSPC.returns <- periodReturn(GSPC.prices,period='daily',type='log')


#Parametric ES - Normality assumption
GSPC.mean <- mean(GSPC.returns)
GSPC.variance <- var(GSPC.returns)
horizon <- 1
confidence <- qnorm(0.05)
GSPC.VaR.p <- -(GSPC.mean*horizon + 
                  confidence*sqrt(horizon*GSPC.variance))
GSPC.ES.p <- -(GSPC.mean*horizon - sqrt(horizon*GSPC.variance)
               /(1-0.95)*exp(-0.5*confidence^2)/sqrt(2*pi))

help(ES)
help(ETL)

ES(GSPC.returns, p=.95, method="gaussian")

#Non-Parametric ES - model-free
GSPC.returns.sorted <- sort(GSPC.returns)
GSPC.VaR.np <- -GSPC.returns.sorted[round(0.05*dim(GSPC.returns)[1]),]
GSPC.ES.np <- -mean(GSPC.returns.sorted[1:round(0.05*dim(GSPC.returns)[1]),])
ES(GSPC.returns, p=.95, method="historical")

#Comparison
GSPC.VaR.p
GSPC.VaR.np

GSPC.ES.p
GSPC.ES.np


chart.VaRSensitivity(GSPC.returns, methods = c("GaussianES",
                                               "HistoricalES"),
                     clean = c("none", "boudt", "geltner"), elementcolor = "darkgray",
                     reference.grid = TRUE, xlab = "Confidence Level",
                     ylab = "Value at Risk", type = "l", lty = c(1, 2, 4), lwd = 1,
                     colorset = (1:12), pch = (1:12))
