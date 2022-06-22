## Getting and Cleaning Data Course Project: Samsung Activity Data

#loading and unzipping files
file <- "getdata_dataset.zip"
if (!file.exists(file)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, file, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file) 
}

#reading in train and test sets, activity and subject labels
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainactivity <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testactivity <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

featureslist <- read.table("features.txt")

#renaming columns in the activity output and label data frames
colnames(test) <- featureslist$V2
colnames(train) <- featureslist$V2
colnames(testsubjects) <- "Subject"
colnames(trainsubjects) <- "Subject"
colnames(testactivity) <- "Activity"
colnames(trainactivity) <- "Activity"

#bind test/train to subjects and activity labels
test <- cbind(testsubjects, testactivity, test)
train <- cbind (trainsubjects, trainactivity, train)

#bind test and train and sort by subject number
completedata <- rbind(test, train)
completedata <- completedata[order(completedata$Subject),]

## Changing activity values to character labels
install.packages("dplyr")
library(dplyr)
activitylabels <- read.table("activity_labels.txt")

completedata$Activity <- recode(completedata$Activity, `1` = "WALKING", `2` = "WALKING_UPSTAIRS", 
                                `3` = "WALKING_DOWNSTAIRS", `4`="SITTING", `5` = "STANDING", 
                                `6` = "LAYING")

#searching for mean and standard deviation columns
print(grep(c("mean|std"), colnames(completedata)))
meansandstds <- grep(c("mean|std"), names(completedata), value=TRUE)

#selecting the columns containing means and standard deviations
wantedcols <- c("Subject", "Activity", meansandstds) 
selecteddata <- completedata %>% select(wantedcols)

#Installing and loading required packages
install.packages("MASS")
install.packages("reshape2")
install.packages("reshape")
library(MASS)
library(reshape2)
library(reshape)

#melting df based on subject and activity 
molten.data <- melt(selecteddata, id = c("Subject","Activity"))

#Creating new df with mean of each variable for every subject and activity
Activitymeans <- cast(molten.data, Subject + Activity ~variable, mean)

#add "mean" prefix to variable column names
colnames(Activitymeans)[3:81] <- paste("mean", colnames(Activitymeans[,c(3:81)]), sep = "_")

#export 
write.table(Activitymeans, file = "Activitymeans.txt", sep = "")





