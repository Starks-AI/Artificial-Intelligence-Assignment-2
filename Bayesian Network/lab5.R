#Lab_5 Assignment

#packages we need to install
# (bnlearn) , (e1071), (caTools), (caret)
library(bnlearn)
library(e1071) 
library(caret) 
library(caTools)


# Provided data set file "2020_bn_nb_data.txt"
pds<-read.table("C:/Users/admin/Documents/R Codes/AI/2020_bn_nb_data.txt",head=TRUE,stringsAsFactors=TRUE)


#Part 1 :- 
#Consider grades earned in each of the courses as random
# variables and learn the dependencies between courses. 

ds_grades=pds
ds_net<-hc(ds_grades,score="k2")
ds_net
plot(ds_net)




#Part 2 :- 
#Using the data, learn the CPTs for each course node.

dsnet_bnfit <- bn.fit(ds_net, ds_grades )
print(dsnet_bnfit)





#Part 3 :-
# What grade will a student get in PH100 if he earns DD in EC100, 
# CC in IT101 and CD in MA101.

g_list <- list("AA","AB","BB","BC","CC","CD","DD","F")
max_probability <- 0.0
final_grade=""

for(grade in g_list) {
  m_prob <- cpquery(dsnet_bnfit, event = (PH100== grade), evidence = ( IT101=="CC" & MA101=="CD" & EC100=="DD" ))
  if(max_probability<m_prob){
    max_probability=m_prob;
    final_grade=grade
  }
}
sprintf("The grade student will get in PH100 is %s ",final_grade)




#Part 4:- A part
#The last column in the data file indicates whether a student
#qualifies for an internship program or not. From the given data, 
#take 70 percent data for training and build a naive Bayes classifier 
#(considering that the grades earned in different courses are 
#independent of each other) which takes in the student's performance 
#and returns the qualification status with a probability.
# Test your classifier on the remaining 30 percent data. 
# Report results about the accuracy of your classifier.

ds_grades=pds
s_split <- sample.split(ds_grades, SplitRatio = 0.7) 
tr <- subset(ds_grades, s_split == "TRUE") 
test <- subset(ds_grades, s_split == "FALSE") 
nb_classifier<- naiveBayes(QP ~ ., data = tr)
y_tr=predict(nb_classifier, newdata = tr)
y_prediction <- predict(nb_classifier, newdata = test)

pass_tr<- table(tr$QP, y_tr)
accuracy_tr = (pass_tr[1,1]+pass_tr[2,2])/sum(pass_tr)

pass_test <- table(test$QP, y_prediction)
accuracy_test = (pass_test[1,1]+pass_test[2,2])/sum(pass_test)

print(round(cbind("Trained Accuracy" = accuracy_tr), 4))
print(round(cbind("Test Accuracy" = accuracy_test), 4))




#Part 4:- B part
#Repeat this experiment for 20 random selection of training
# and testing data.

ds_grades=pds
ds_grades=ds_grades[sample(nrow(ds_grades), 20), ]
s_split <- sample.split(ds_grades, SplitRatio = 0.7) 
tr <- subset(ds_grades, s_split == "TRUE") 
test <- subset(ds_grades, s_split == "FALSE")
nb_Classifier<- naiveBayes(QP ~ ., data = tr)
y_tr=predict(nb_Classifier, newdata = tr)
y_prediction <- predict(nb_Classifier, newdata = test)

pass_tr<- table(tr$QP, y_tr)
accuracy_tr = (pass_tr[1,1]+pass_tr[2,2])/sum(pass_tr)

pass_test <- table(test$QP, y_prediction)
accuracy_test = (pass_test[1,1]+pass_test[2,2])/sum(pass_test)

print(round(cbind("Trained Accuracy" = accuracy_tr), 4))
print(round(cbind("Test Accuracy" = accuracy_test), 4))




#Part 5 :- A
# Repeat Part 4, considering that the grades earned in different
# courses may be dependent.

ds_grades=pds

s_split <- sample.split(ds_grades, SplitRatio = 0.7)
tr <- subset(ds_grades, s_split == "TRUE")
test <- subset(ds_grades, s_split == "FALSE")
tr.hc=suppressWarnings(hc(tr, score="k2"))

nb_Classifier<- suppressWarnings(bn.fit(tr.hc, tr))
y_tr <- predict(nb_Classifier,node="QP", data = tr)
y_prediction <- predict(nb_Classifier,node="QP", data = test)

pass_tr<- table(tr$QP, y_tr)
accuracy_tr = (pass_tr[1,1]+pass_tr[2,2])/sum(pass_tr)

pass_test <- table(test$QP, y_prediction)
accuracy_test = (pass_test[1,1]+pass_test[2,2])/sum(pass_test)


plot(tr.hc)
print(round(cbind("Trained Accuracy" =accuracy_tr), 4))
print(round(cbind("Test Accuracy" =accuracy_test), 4))




#Part 5 :- B
# Repeat Part 4, considering that the grades earned in different
# courses may be dependent.
#Repeat this experiment for 20 random selection of training
# and testing data.

ds_grades=pds
ds_grades=ds_grades[sample(nrow(ds_grades), 20), ]
s_split <- sample.split(ds_grades, SplitRatio = 0.7) 
tr <- subset(ds_grades, s_split == "TRUE") 
test <- subset(ds_grades, s_split == "FALSE")
tr.hc=suppressWarnings(hc(tr, score="k2"))

nb_Classifier<- suppressWarnings(bn.fit(tr.hc, tr))
y_tr <- predict(nb_Classifier,node="QP", data = tr)
y_prediction <- predict(nb_Classifier,node="QP", data = test)

pass_tr<- table(tr$QP, y_tr)
accuracy_tr = (pass_tr[1,1]+pass_tr[2,2])/sum(pass_tr)

pass_test <- table(test$QP, y_prediction)
accuracy_test = (pass_test[1,1]+pass_test[2,2])/sum(pass_test)

plot(tr.hc)
print(round(cbind("Trained Accuracy" =accuracy_tr), 4))
print(round(cbind("Test Accuracy" =accuracy_test), 4))
