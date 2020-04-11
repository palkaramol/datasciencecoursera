library(dplyr)

file_name <- "DataClining.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,file_name,method="curl")

unzip(file_name)

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#You should create one R script called run_analysis.R that does the following.

# 1) Merges the training and the test sets to create one data set.

x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind (subject_train,subject_test)
mearge <- cbind(subject, y, x)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement.

mean_SD <- mearge %>% select(subject,code,contains("mean"),contains("std"))
mean_SD

# 3) Uses descriptive activity names to name the activities in the data set

mean_SD$code <- activities[mean_SD$code,2]

# 4) Appropriately labels the data set with descriptive variable names.

names(mean_SD)[2] = "activity"
names(mean_SD)<-gsub("Acc", "Accelerometer", names(mean_SD))
names(mean_SD)<-gsub("Gyro", "Gyroscope", names(mean_SD))
names(mean_SD)<-gsub("BodyBody", "Body", names(mean_SD))
names(mean_SD)<-gsub("Mag", "Magnitude", names(mean_SD))
names(mean_SD)<-gsub("^t", "Time", names(mean_SD))
names(mean_SD)<-gsub("^f", "Frequency", names(mean_SD))
names(mean_SD)<-gsub("tBody", "TimeBody", names(mean_SD))
names(mean_SD)<-gsub("-mean()", "Mean", names(mean_SD), ignore.case = TRUE)
names(mean_SD)<-gsub("-std()", "STD", names(mean_SD), ignore.case = TRUE)
names(mean_SD)<-gsub("-freq()", "Frequency", names(mean_SD), ignore.case = TRUE)
names(mean_SD)<-gsub("angle", "Angle", names(mean_SD))
names(mean_SD)<-gsub("gravity", "Gravity", names(mean_SD))

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

FinalDataSet <- mean_SD %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(FinalDataSet, "FinalDataSet.txt", row.name=FALSE)
