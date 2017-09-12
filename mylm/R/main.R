
#main script

install.packages("car")
library(car)
data(SLID, package = "car")
SLID <- SLID[complete.cases(SLID), ]

summary(SLID)
