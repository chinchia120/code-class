#########################
# Set Working Directory #
#########################

# Get your current working directory #

setwd("C:\\Users\\user\\Documents\\code\\introduction-to-scientific-computing-software\\classdata\\C4_ClassData")
getwd()

dataset1<-read.csv("C4_1.csv") 
dataset2<-read.csv("C4_2.csv")
dataset_soil <- read.csv("C4_�g�[���.csv")
dataset_sick <- read.csv("C4_�h�����.csv")

str(dataset1)   #Check the variable format
View(dataset1)		#Check Dataset
dim(dataset1)
fix(dataset1)

###################
#      T-test     #
###################

## One-sample t-test##
#read dataset1
t.test(dataset1$PM25, mu = 15) 
t.test(dataset_soil$PH, mu = 7)

##Two-sample paired T-test
#read dataset2
t.test(dataset2$Rainfall_3, dataset2$Rainfall_2, paired = TRUE)
t.test(dataset_sick$�o�f�e, dataset_sick$�o�f��, paired = TRUE)
