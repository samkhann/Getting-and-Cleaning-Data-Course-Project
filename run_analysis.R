library(reshape2)

file_name <- "rawdata.zip"

# 0. Getting raw data
if (!file.exists(file_name)){
  file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(file_url, file_name, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}

# 1. Merges the training and the test sets to create one data set

train_x <- read.table("UCI HAR Dataset/train/X_train.txt")[mean_std]
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_y, train_x)

test_x <- read.table("UCI HAR Dataset/test/X_test.txt")[mean_std]
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_y, test_x)

merged_data <- rbind(train, test)
colnames(merged_data) <- c("subject", "activity", mean_std.names)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

mean_std <- grep(".*mean.*|.*std.*", features[,2])
mean_std.names <- features[mean_std,2]
mean_std.names <- gsub('-mean', 'Mean', mean_std.names)
mean_std.names <- gsub('-std', 'Std', mean_std.names)
mean_std.names <- gsub('[-()]', '', mean_std.names)

# 3 & 4. Uses descriptive activity names to name the activities in the data set, then appropriately labels the data set with descriptive variable names.

merged_data$activity <- factor(merged_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
merged_data$subject <- as.factor(merged_data$subject)

merged_data.melted <- melt(merged_data, id = c("subject", "activity"))
merged_data.mean <- dcast(merged_data.melted, subject + activity ~ variable, mean)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(merged_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)