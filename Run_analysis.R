#============================
# Getting and Cleaning Data
#============================

library(dplyr)

# Downloading and importing data

file.name = "Coursera_DS3_Final.zip"

if (!file.exists(file.name)){
  fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, file.name, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(file.name) 
}


features = read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject.test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest = read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest = read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject.train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain = read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain = read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
head(features); head(activities); head(xtest); head(ytest); head(subject.train)
head(xtrain); head(ytrain)



## Step 1: Merges the training and the test sets to create one data set.

X.all = rbind(xtrain, xtest)
Y.all = rbind(ytrain, ytest)
Subject = rbind(subject.train, subject.test)
MergedData = cbind(Subject, Y.all, X.all)
head(MergedData)


## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

TidyData = MergedData %>% select(subject, code, contains("mean"), contains("std"))


## Step 3: Uses descriptive activity names to name the activities in the data set.

TidyData$code = activities[TidyData$code, 2]


## Step 4: Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData) = gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) = gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) = gsub("BodyBody", "Body", names(TidyData))
names(TidyData) = gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) = gsub("^t", "Time", names(TidyData))
names(TidyData) = gsub("^f", "Frequency", names(TidyData))
names(TidyData) = gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) = gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData) = gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) = gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) = gsub("angle", "Angle", names(TidyData))
names(TidyData) = gsub("gravity", "Gravity", names(TidyData))


## Step 5: From the data set in step 4, creates a second, independent tidy data 
#set with the average of each variable for each activity and each subject.

FinalData = TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)


## Final Check Stage

str(FinalData); head(FinalData)











