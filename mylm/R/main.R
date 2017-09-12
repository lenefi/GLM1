
#main script

install.packages("car")
library(car)
data(SLID, package = "car")
SLID <- SLID[complete.cases(SLID), ]

summary(SLID)
lm(SLID)

install.packages("GGally")
install.packages("ggplot2")

library("GGally")
ggpairs(SLID, columns = 1:5)
