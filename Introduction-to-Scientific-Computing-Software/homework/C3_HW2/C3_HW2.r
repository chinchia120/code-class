setwd("C:\\Users\\user\\Documents\\code\\introduction-to-scientific-computing-software\\homework\\C3_HW2")
getwd()

dataset <- read.csv("C3_HW.csv", encoding = "utf-8")

library(psych)
skew(dataset$�ū�)   
kurtosi(dataset$�ū�)

library(nortest)
lillie.test(dataset$�ū�)

boxplot(formula = �ū�~Season, data = dataset, xlab = "Season", ylab = "�ū�", col = "blue")

boxplot(formula = �ū�~year, data = subset(dataset, dataset$city == "�s�_��"), xlab = "Year", ylab = "�ū�", col = "blue")
