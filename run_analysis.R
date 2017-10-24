#website
urlzip <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Name Zip
namezip <- "UCI HAR Dataset.zip"

#Zip local directory 
destzip <- "C:/Users/junio/Desktop/COURSERA/DATA SCIENCE/COURSE 3 - Getting and Cleaning Data/Project/UCI HAR Dataset.zip"

#Check if zip exists
if (!file.exists(namezip)) {
    download.file(urlzip, destzip, method = "wininet")
}

#current work directory
setwd("C:/Users/junio/Desktop/COURSERA/DATA SCIENCE/COURSE 3 - Getting and Cleaning Data/Project")

#unzip zip file containing data if data directory doesn't already exist
pathzip <- "UCI HAR Dataset"
if (!file.exists(pathzip)) {
  unzip(namezip)
}

#reading testing tables
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#reading trainings tables
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#reading feature vector
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)

#reading activity labels
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

#assigning column names
colnames(x_test) <- features[,2] 
colnames(y_test) <- "IdActivity"
colnames(subject_test) <- "IdSubject"

colnames(x_train) <- features[,2] 
colnames(y_train) <-"IdActivity"
colnames(subject_train) <- "IdSubject"

colnames(activityLabels) <- c("IdActivity","TypeActivity")

#merging data
merge_test <- cbind(y_test, subject_test, x_test)
merge_train <- cbind(y_train, subject_train, x_train)
setTotal <- rbind(merge_train, merge_test)

#create vector for defining ID, mean and standard deviation:
mean_std <- (grepl("IdActivity" , colnames)|grepl("IdSubject" , colnames)|grepl("mean.." , colnames)|grepl("std.." , colnames))

#subset from setTotal
set_mean_std <- setTotal[, mean_std == TRUE]

#using descriptive activity names to name the activities in the data set
set_ActivityNames <- merge(set_mean_std, activityLabels, by="IdActivity", all.x=TRUE)

#create a second independent tidy
set_tidy <- aggregate(. ~IdSubject + IdActivity, set_ActivityNames, mean)
set_tidy <- set_tidy[order(set_tidy$IdSubject, set_tidy$IdActivity),]

#create a second independent tidy
write.table(set_tidy, "set_tidy.txt", row.name=FALSE)







