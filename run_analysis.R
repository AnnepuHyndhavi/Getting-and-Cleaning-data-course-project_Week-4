library(dplyr)

# testing data
X_test <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/test/y_test.txt")
Sub_test <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/test/subject_test.txt")

# training data
X_train <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/train/y_train.txt")
Sub_train <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/train/subject_train.txt")


# the description of data
variable_names <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/features.txt")

# reading the activity labels
activity_labels <- read.table("/Users/hyndhu/Desktop/UCI HAR Dataset/activity_labels.txt")

# Merging the training and the test sets to generate new data set.
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

# Extracting only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# Using descriptive activity names to name the different activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# labels the data set with the descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# From the data set above it generates a second, tidy data set with an average of each variable for each activity and subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "/Users/hyndhu/Desktop/UCI HAR Dataset/_tidy_data.txt", row.names = FALSE, col.names = TRUE)
