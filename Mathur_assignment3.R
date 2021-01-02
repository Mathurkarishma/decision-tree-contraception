#DATA 630 Assignment 3
#Written by Karishma Mathur
#Professor Bati
#Due July 7, 2020

#Set working directory to where file is located

#Read the cars data

cmc<-read.csv(file="cmc.csv", head=TRUE, sep=",", as.is=FALSE)

#Install packages for decision tree modeling

install.packages("party")
library("party")

#Preview the structure

str(cmc)
summary(cmc)

#Missing values

nrow(cmc[!complete.cases(cmc),])

#Exploratory analysis; viewing histograms on variables

hist(cmc$WifeEducation) #most have highest education, many have higher
hist(cmc$HusbandEducation) #more have highest and high education
hist(cmc$NumChildren) #most have no children, or not many
hist(cmc$WifeReligion) #most are Islamic (but Indonesia is)
hist(cmc$WifeWorking) #most are not working
hist(cmc$HusbandOccupation) #1=2, 3 is highest, 4 is VERY low
hist(cmc$LivingStandardIndex) #fairly similar ratio compared to wife education
hist(cmc$MediaExposure) #large majority have good media exposure
hist(cmc$ContraceptiveMethod) #good distribution for analysis

#Transform integers into categorical variables

cmc$WifeEducation<-factor(cmc$WifeEducation)
cmc$HusbandEducation<-factor(cmc$HusbandEducation)
cmc$LivingStandardIndex<-factor(cmc$LivingStandardIndex)
cmc$ContraceptiveMethod<-factor(cmc$ContraceptiveMethod)

#Split the data into a training and test set

set.seed(1234)
ind <- sample(2, nrow(cmc), replace = TRUE, prob = c(0.7, 0.3))
train.data <- cmc[ind == 1, ]
test.data <- cmc[ind == 2, ]

#Run the ctree method on training data

myFormula<-ContraceptiveMethod~.
model <- ctree(myFormula, data = train.data, controls=ctree_control(minbucket = 50, maxdepth = 4))

#Output the tree structure

print(model)

#Visualize the tree

plot(model)
plot(model, type="simple", drop_terminal = FALSE)

#Confusion matrix

table(predict(model), train.data$ContraceptiveMethod, dnn=c("Predicted","Actual"))

sum(predict(model)==train.data$ContraceptiveMethod)/length(train.data$ContraceptiveMethod)

#Evaluate the model on a test data
testPred <- predict(model, newdata = test.data)
table (testPred, test.data$ContraceptiveMethod)

sum(testPred==test.data$ContraceptiveMethod)/length(test.data$ContraceptiveMethod)

#End of script
