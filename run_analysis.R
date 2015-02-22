# =============================================
# run_analysis.R
# =============================================

# Script to read Samsung train and test data of "Human Activity Recognition
# database built from the recordings of 30 subjects performing activities of
# daily living". 

# The goal is to build a tidy data set with the average of each variable for
# each activity and each subject.



# You should create one R script called run_analysis.R that does the following. 
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. From the data set in step 4, creates a second, independent tidy data set 
#      with the average of each variable for each activity and each subject.


library(dplyr)
library(tidyr)

# UCI HAR Dataset expected in working directory

# ==============================================================================
# 1. READ DATA & MERGE DATA

# read feature names
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
# convert feature name to valid names
valid_column_names <- make.names(names=features$V2, unique=TRUE, allow_ = TRUE)

# Read training data. 
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
names(X_train) <- valid_column_names
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Add column for subject identification and experiment identification
all_train <- cbind(subject_train, y_train)
names(all_train) <- c("subject", "activity")
all_train <- cbind(all_train, X_train)

# Read test data.
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
names(X_test) <- valid_column_names
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Add column for subject identification and experiment identification
all_test <- cbind(subject_test, y_test)
names(all_test) <- c("subject", "activity")
all_test <- cbind(all_test, X_test)

# merge all data
all <- rbind(all_train, all_test)

# clean unused variables
rm(X_test, X_train, y_test, y_train, subject_test, subject_train, all_test, all_train)

# ==============================================================================
# 2. SELECT & EXTRACT

# Extracts only the mean and standard deviation for each measurement. 
# Only keep column that included mean() and std() in the original.

sub <- all %>% select(subject, activity, 
                      matches("mean\\.\\.|std\\.\\.", ignore.case = FALSE))

# ==============================================================================
# 3. LABEL ACTIVITY

# create a factor variable for activity in sub
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")
sub <- sub %>% mutate(activity = factor(activity, 
                                        levels = activity_label[,1], 
                                        labels = activity_label[,2]))

# ==============================================================================
# 4. LABEL DATA

# Appropriately labels the data set with descriptive variable names.

# remove camel case and multiple '.'. For example, transforms:
# fBodyGyro.mean...Y into f_body_gyro_mean_Y

clean_names <- gsub("([a-z])([A-Z])","\\1_\\L\\2",names(sub), perl=TRUE)
clean_names <- gsub("\\.\\.\\.", "_", clean_names)
clean_names <- gsub("\\.\\.", "", clean_names)
clean_names <- gsub("\\.", "_", clean_names)

names(sub) <- clean_names

# ==============================================================================
# 5. TIDY DATA SET WITH AVERAGE

# tidy data set with the average of each variable for each activity and each subject.
# Expected dimension 180 rows *68 column

tidy_data <- sub %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean)) # calculate the mean for each columns grouping by subject and activity

# write data to file.
write.table(tidy_data, "hra_summary.txt", row.name=FALSE)


