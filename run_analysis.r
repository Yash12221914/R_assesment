# Load necessary libraries
library(dplyr)

# Read feature names
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))

# Extract only the mean and standard deviation measurements
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$functions)

# Read activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Read training data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[mean_std_features]
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

# Read test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[mean_std_features]
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# Merge the training and test sets to create one data set
merged_data <- bind_rows(train, test)
merged_activities <- bind_rows(train_activities, test_activities)
merged_subjects <- bind_rows(train_subjects, test_subjects)

# Use descriptive activity names
merged_activities$activity <- factor(merged_activities$activity, levels = activity_labels$code, labels = activity_labels$activity)

# Appropriately label the data set with descriptive variable names
colnames(merged_data) <- features$functions[mean_std_features]

# Combine all data into one data frame
data <- cbind(merged_subjects, merged_activities, merged_data)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Write the tidy data set to a file
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)