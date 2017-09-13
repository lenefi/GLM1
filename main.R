
#main script

library(car)
library(ggplot2)
library("GGally")
library(mylm)

data(SLID, package = "car")
SLID <- SLID[complete.cases(SLID), ]

model1 <- mylm(wages ~ education, data = SLID)
model1b <- lm(wages ~ education, data = SLID)

# compare print
print(model1)
print(model1b)
# compare summary
#summary(model1) #avventer kode fra Martin
summary(model1b)
# compare plot
plot(model1)
#plot(model1b)
ggpairs(SLID, columns = 1:5)

