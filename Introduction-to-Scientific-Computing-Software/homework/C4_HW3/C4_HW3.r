setwd("C:\\Users\\user\\Documents\\code\\introduction-to-scientific-computing-software\\homework\\C4_HW3")
getwd()

dataset1 <- read.csv("C4_1_HW.csv") 
dataset2 <- read.csv("C4_2_HW.csv")

t.test(dataset1$���n, mu = 20)

t.test(dataset2$A�}���魫�W��, dataset2$B�}���魫�W��, paired = TRUE)