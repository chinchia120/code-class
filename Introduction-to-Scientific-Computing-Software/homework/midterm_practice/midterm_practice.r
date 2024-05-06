setwd("C:\\Users\\user\\Documents\\code\\introduction-to-scientific-computing-software\\homework\\midterm_practice")
getwd()

#Q1
data1 <- read.csv("����ǰ�n�þ���.csv")
data2 <- subset(data1, data1$year=="2009")

summary(subset(data2, data2$city=="�҈@��"))
summary(subset(data2, data2$city=="�_����"))
round(sd(subset(data2, data2$city=="�҈@��")$�ض�,na.rm = TRUE),4)
round(sd(subset(data2, data2$city=="�_����")$�ض�,na.rm = TRUE),4)

library(psych)
skew(subset(data2, data2$city=="�҈@��")$�ض�)   
skew(subset(data2, data2$city=="�_����")$�ض�)  
kurtosi(subset(data2, data2$city=="�҈@��")$�ض�)
kurtosi(subset(data2, data2$city=="�_����")$�ض�)

library(nortest)
lillie.test(subset(data2, data2$city=="�҈@��")$�ض�)
lillie.test(subset(data2, data2$city=="�_����")$�ض�)

data1$month_ch <- as.character(data1$month)

library("lattice")
histogram(x = ~�ض�|month_ch, data = data1, xlab = "Temperature(��)", ylab = "Count", type = "count", layout = c(4,3))
boxplot(formula = �ض�~month, data = data1, xlab = "month", ylab = "Temperature(��)", col = "blue")

#Q2
data3 <- read.csv("weight.csv")

t.test(data3$weight_1, mu = 20.80)
t.test(data3$weight_2, mu = 23.35)

t.test(data3$score_1, data3$score_2, paired = TRUE)

#Q3_1
dim(subset(data2, data2$city=="�҈@��"))
dim(subset(data2, data2$city=="�_����"))

library(nortest)
lillie.test(data2$�ض�[data2$city=="�҈@��"])
lillie.test(data2$�ض�[data2$city=="�_����"])

library(car)
leveneTest(data2$�ض�, data2$city=="�҈@��", center=mean)
leveneTest(data2$�ض�, data2$city=="�_����", center=mean)

t.test(data2$�ض�[data2$city=="�҈@��"], data2$�ض�[data2$city=="�_����"], var.equal=FALSE)

#Q3_2
dim(subset(data2, data2$city=="������"))
dim(subset(data2, data2$city=="�_����"))

library(nortest)
lillie.test(data2$�ض�[data2$city=="������"])
lillie.test(data2$�ض�[data2$city=="�_����"])

library(car)
leveneTest(data2$�ض�, data2$city=="������", center=mean)
leveneTest(data2$�ض�, data2$city=="�_����", center=mean)

t.test(data2$�ض�[data2$city=="������"], data2$�ض�[data2$city=="�_����"], var.equal=FALSE)

#Q4
data4 <- read.csv("cost.csv")

shapiro.test(data4$NT_dollar)
hist(data4$NT_dollar, main="NT_dollar", xlab="NTD")

data4$NT_dollar_sqrt <- sqrt(data4$NT_dollar)
shapiro.test(data4$NT_dollar_sqrt)
hist(data4$NT_dollar_sqrt, main="NT_dollar in sqrt", xlab="NTD")

data4$NT_dollar_log <- log(data4$NT_dollar)
shapiro.test(data4$NT_dollar_log)
hist(data4$NT_dollar_log, main="NT_dollar in log", xlab="NTD")

#Q5
summary(aov(�ض�~ factor(year), data=data1)) 

library(car)
leveneTest(data1$�ض�, data1$year, center=mean)

library(PMCMRplus)
summary(gamesHowellTest(aov(�ض�~ factor(year), data=data1)))

data5 <- subset(data2, data2$city=="�_����" | data2$city=="����h" | data2$city=="�_����")
summary(aov(�ض�~ factor(city), data=data5))