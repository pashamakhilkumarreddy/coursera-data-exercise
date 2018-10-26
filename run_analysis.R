## Data download and unzip 

# variables for the files to be downloaded
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
fileName <- 'UCIdata.zip'
dir <- 'UCI HAR Dataset'

# Download the file only if it doesn't exist
if (!file.exists(fileName)) {
  download.file(fileUrl, fileName, mode="wb")
}

# Check for the presence of the directory and unzip the downloaded file
if (!dir.exists(dir)) {
  unzip(fileName, files=NULL, exdir=".")
}

# install data.table only if it is not installed
if (!require("data.table")) {
  install.packages("data.table")
}

# require data.table package
require("data.table")

## Read the data
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
X_test <- read.table('UCI HAR Dataset/test/X_test.txt')
X_train <- read.table('UCI HAR Dataset/train/X_train.txt')
Y_test <- read.table('UCI HAR Dataset/test/y_test.txt')
Y_train <- read.table('UCI HAR Dataset/train/y_train.txt')

activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')
features <- read.table('UCI HAR Dataset/features.txt')

## 1
# Merge the train and test data set to create a single data set
data <- rbind(X_train, X_test)

## 2
# Extract only the measurements on mean and standard deviation for each measurement. 
# Create a vector of only mean and std, use the vector to subset.
meanStdOnly <- grep("mean()|std()", features[,2])
data <- data[,meanStdOnly]

## 4
#  Label the data set with descriptive activity names.
# Create vector of "Clean" feature names by getting rid of "()" apply to the data to rename labels.
cleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(data) <- cleanFeatureNames[meanStdOnly]

# combine test and train of subject data and activity data, and give descriptive labels
subject <- rbind(subject_train, subject_test)
names(subject) <- 'subject'
activity <- rbind(Y_train, Y_test)
names(activity) <- 'activity'

# combine subject, activity, and mean and std only data set to create final data set.
data <- cbind(subject,activity, data)

## 3
#  Use the descriptive activity names to name the activities in the data set
# group the activity column of data, re-name lable of levels with activity_levels, and apply it to data.
act_group <- factor(data$activity)
levels(act_group) <- activity_labels[,2]
data$activity <- act_group


## 5
# Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# check if reshape2 package is installed
if (!"reshape2" %in% installed.packages()) {
  install.packages("reshape2")
}
# require reshape2
library("reshape2")

# melt data to tall skinny data and cast means. Finally write the tidy data to the working directory as "tidy_data.txt"
baseData <- melt(data,(id.vars=c("subject","activity")))
data.second <- dcast(baseData, subject + activity ~ variable, mean)
names(data.second)[-c(1:2)] <- paste("[mean of]" , names(data.second)[-c(1:2)] )
write.table(data.second,row.name=FALSE, "tidy_data.txt", sep = ",")
