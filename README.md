Code Book
==========

## Pre Analysis
This script will check if the data file is present in your working directory. (If not, will download and unzip the file)

## 1. Read data and Merge
* subject_test : subject IDs for test
* subject_train  : subject IDs for train
* X_test : values of variables in test
* X_train : values of variables in train
* Y_test : activity ID in test
* Y_train : activity ID in train
* activity_labels : Description of activity IDs in Y_test and Y_train
* features : description(label) of each variables in X_test and X_train

* data : bind of X_train and X_test

## 2. Extract only mean() and std()
Create a vector of only mean and std labels, then use the vector to subset data.
* meanStdOnly : a vector of only mean and std labels extracted from 2nd column of features
* data : at the end of this step, data will only contain mean and std variables

## 3. Changing Column label of data
Create a vector of "clean" feature names by getting rid of "()" at the end. Then, will apply that to the data to rename column labels.
* cleanFeatureNames : a vector of "clean" feature names 

## 4. Adding Subject and Activity to the data
Combine test data and train data of subject and activity, then give descriptive lables. Finally, bind with data. At the end of this step, data has 2 additonal columns 'subject' and 'activity' in the left side.
* subject : bind of subject_train and subject_test
* activity : bind of Y_train and Y_test

## 5. Rename ID to activity name
Group the activity column of data as "act_group", then rename each levels with 2nd column of activity_levels. Finally apply the renamed "act_group" to data's activity column.
* act_group : factored activity column of data

## 6. Output tidy data
In this part, data is melted to create tidy data. It will also add [mean of] to each column labels for better description. Finally output the data as "tidy_data.txt"
* baseData : melted tall and skinny data
* data.second : casete baseData which has means of each variables
