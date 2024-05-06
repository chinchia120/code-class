#�@Week 8 2022/04/20
#�@Chi-square test
#�@Fisher��s exact test
#
install.packages("vcd") #�w��vcd�M��
########################
#�@Example 1
########################
#�@Create example table

Ex1 <- data.frame(Phenotype=c("1","1","1","1","2","2","2","2"))
#Column name = value ���W��: �ƭ�
Ex1        # view Ex1 �T�{Ex1���e

Ex1_Chi <- table(Ex1$Phenotype) 
#generate a contingency table �إߦC�p��
Ex1_Chi    # view Ex1_Chi �T�{Ex1_Chi���e

chisq.test(Ex1_Chi)  #use ��chisq.test()�� to obtain the results of chi-square tests �d����R�A���]�C�ؾ��v���ۦP

#Warning message:
#�@In chisq.test(Ex1_Chi) : Chi-squared approximation may be incorrect
##because many of the expected values will be very small and therefore the approximations of p may not be right.
##if expected values < 5, this warning will occur
##reference: https://stats.stackexchange.com/questions/81483/warning-in-r-chi-squared-approximation-may-be-incorrect
##
##solve method: add a parameter to calculate simulate p value, simulate.p.value = TRUE
###

chisq.test(Ex1_Chi, simulate.p.value = TRUE) 
# dosen't assign the probability of phenotype �d����R�A�����w���v(���ۦP)�A�p�����p��

chisq.test(Ex1_Chi, p = c(3/4, 1/4), simulate.p.value = TRUE) 
# Assign probability. (type1: 3/4, type2: 1/4) ���w���v�Ĥ@��3/4, �ĤG��1/4

########################
#�@Exercise 1
########################

Exe1_Chi <- data.frame(Gold=10, Red=5, White=45) #�����إߦC�p��
Exe1_Chi 

chisq.test(Exe1_Chi, p = c(3/100, 9/100, 88/100), simulate.p.value = TRUE)





########################
#�@Example 2
########################
Ex2_Chi <- data.frame(row.names=c("Drug", "No Drug"), Healthy= c(105,110), Unhealthy = c(15,40)) 
#�����إߦC�p��
Ex2_Chi

prop.table(Ex2_Chi)  #�d�ݦʤ��� 
prop.table(data.matrix(Ex2_Chi), 2)  #�d�ݦU��ʤ��� #�n���Ndataframe�榡�ରdata.matrix
prop.table(data.matrix(Ex2_Chi), 1)  #�d�ݦU�C�ʤ��� #�n���Ndataframe�榡�ରdata.matrix
# for a matrix 1 indicates rows, 2 indicates columns

chisq.test(Ex2_Chi)

#Dataframe �C�@�泣�i�H�����P����ƫ��A
#Data Matrix �P�@��ݭn�Τ@��ƫ��A

########################
#�@Exercise 2
########################

Exe2_Chi <- data.frame(row.names=c("������", "�S����"), ���� = c(38,22), �S���� = c(40,40)) #�����إߦC�p��
Exe2_Chi

prop.table(Exe2_Chi)  #�d�ݦʤ��� 
prop.table(data.matrix(Exe2_Chi), 2)  #�d�ݦU��ʤ��� #�n���Ndataframe�榡�ରdata.matrix
prop.table(data.matrix(Exe2_Chi), 1)  #�d�ݦU�C�ʤ��� #�n���Ndataframe�榡�ରdata.matrix

chisq.test(Exe2_Chi)

########################
#�@Example 3
########################

Ex3_Chi <- data.frame(row.names=c("�ﵽ", "���ﵽ"), A = c(24,12), B = c(30,18), C = c(21,10)) #�����إߦC�p��
Ex3_Chi

prop.table(Ex3_Chi)  #�d�ݦʤ��� 
prop.table(data.matrix(Ex3_Chi), 2)  #�d�ݦU��ʤ��� #�n���Ndataframe�榡�ରdata.matrix
prop.table(data.matrix(Ex3_Chi), 1)  #�d�ݦU�C�ʤ��� #�n���Ndataframe�榡�ରdata.matrix

chisq.test(Ex3_Chi)

########################
#�@Exercise 3
########################

Exe3_Chi <- data.frame(row.names=c("����", "������"), �� = c(20,10), �� = c(28,22), ���� = c(30,10), ���� = c(15,15)) #�����إߦC�p��
Exe3_Chi

prop.table(Exe3_Chi)  #�d�ݦʤ��� 
prop.table(data.matrix(Exe3_Chi), 2)  #�d�ݦU��ʤ��� #�n���Ndataframe�榡�ରdata.matrix
prop.table(data.matrix(Exe3_Chi), 1)  #�d�ݦU�C�ʤ��� #�n���Ndataframe�榡�ରdata.matrix

chisq.test(Exe3_Chi)

########################
#�@Example 4
########################

Ex4_Fis <- data.frame(row.names=c("Drug", "No Drug"), Healthy= c(21,22), Unhealthy = c(3,8)) #�����إߦC�p��
Ex4_Fis

prop.table(Ex4_Fis)  #�d�ݦʤ��� 
prop.table(data.matrix(Ex4_Fis), 2)  #�d�ݦU��ʤ��� #�n���Ndataframe�榡�ରdata.matrix
prop.table(data.matrix(Ex4_Fis), 1)  #�d�ݦU�C�ʤ��� #�n���Ndataframe�榡�ରdata.matrix

chisq.test(Ex4_Fis)

library(vcd) #�ҥ�vcd�M��
independence_table(data.matrix(Ex4_Fis)) #�إߴ���Ȫ�

#chisq.test(Ex4_Fis, simulate.p.value = TRUE)

fisher.test(Ex4_Fis)


########################
#�@Practice 1 - Chi-squared Test 
########################
data1 <- data.frame(one=20, two=28, three=30, four=15, five=24, six=19)
chisq.test(data1, simulate.p.value=FALSE)

########################
#�@Practice 2 - Fisher's exact test 
########################
data2 <- data.frame(row.names=c("yes", "no"), come=c(7,7),  no_come=c(15,2)) 
fisher.test(data2, simulate.p.value=FALSE)