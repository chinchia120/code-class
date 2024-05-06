setwd("C:\\Users\\user\\Documents\\code\\introduction-to-scientific-computing-software\\homework\\C5_HW4")
getwd()

#Q1
data1 <- read.csv("C5_Q1.csv")

shapiro.test(data1$�W��[data1$�}��==1])
shapiro.test(data1$�W��[data1$�}��==2])

bartlett.test(�W��~�}��, data=data1)

t.test(data1$�W��[data1$�}��==1], data1$�W��[data1$�}��==2], var.equal=TRUE)

#Q2
data2 <- read.csv("C5_Q2.csv")

shapiro.test(data2$�ݯf����)
hist(data2$�ݯf����, main="�ݯf����", xlab="�ݯf����")

data2$�ݯf����_sqrt <- sqrt(data2$�ݯf����)
shapiro.test(data2$�ݯf����_sqrt)
hist(data2$�ݯf����_sqrt, main="�ݯf���� in Sqrt", xlab="�ݯf����")
