# Human Activity Recognition Using Smartphones Dataset

The **Human Activity Recognition** (HAR) database was built from the recordings of 30 subjects performing activities of daily living, such as walking, sitting, laying, etc., while carrying a waist-mounted smartphone with embedded inertial sensors. The dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The script `run_analysis.R` summarizes the mean and standard deviation variables per subject and per activity of the HAR database.

### Structure of HAR database
Label files

- `features_info.txt`: Shows information about the variables used on the feature vector.
- `features.txt`: List of all features names.
- `activity_labels.txt`: For each activity class, provide a activity name

Training and test data files

- `train/X_train.txt`: 561 Feature vector for 7352 record.
- `train/y_train.txt`: activity class of the X_train records.
- `train/subject_train.txt`: Each row identifies the subject who performed the activity. Its range is from 1 to 30. 
- `train/Inertial Signals/* `: list of files containing the raw data used to compute X_train

- `test/X_test.txt`: 561 Feature vector for 2947 record.
- `test/y_test.txt`: activity class of the X_test records.
- `test/subject_test.txt`: Each row identifies the subject who performed the activity. Its range is from 1 to 30. 
- `test/Inertial Signals/* `: list of files containing the raw data used to compute X_test


### Getting Data
A zip file containing the dataset was downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The analysis scritp assumes that the HAR database is available in an unzipped **UCI HAR Dataset** folder in the working directory.

### Analysis

The analysis requires the packages `dplyr` and `tidyr`
##### 1. Reading and merging data
The observations in the data set have been separated into training and test sets. The first step is to combine those observations into one data frame.

Reading training data into a data frame:

1. Read `train/X_train.txt` files.
2. Labels columns of X using the names provided in `feature.txt`. The original variable names are not all valid for R, the names were cleaned using the `make.names()` function.
3. Read `train/y_train.txt`.
4. Read `train/subject_train.txt`.
5. Combine subject/y/X into one data frame by adding subject and y as first and second column to X respectively. The names of the first two columns is `subject` and `activity`.
 
Repeat step 1-5 for test data.

There is now one data frame for test data and one for training data.

- Merge the training and test data by using rbind()

The resulting data frame contains 563 variables and 10299 observations.

##### 2. Select variables of interest

In our analysis, we are only interested in variables containing `mean()` and `std()` in the original feature names. Using `select` from `dplyr`, the variables of interest are selected. 

There are 33 variables containing mean() and 33 variables containing std().
The subject and activity variables are kept as well giving a total of 68 variables.

The resulting data frame contains **68 variables and 10299 observations**

##### 3. Label activity

The value of the activity variable in the reduced data frame is transformed into a factor variable and the levels are provided using the file `activity_labels.txt`.

The resulting data frame has the activity column as a factor with the labels: `WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING`.


##### 4. Rename variables

Variable names have been set-up in step 1, using the names provided in the feature.txt file.

The `make.names()` function used in step 1 replaced invalid R variable charaters by '.'.

At this stage, the following is done to modify variable names:

- replace '.' by '_' and remove trailing '.' at the end of a variable name.
- replace CamelCase by camel_case

For example `fBodyGyro.mean...Y` is transformed into `f_body_gyro_mean_Y`.

##### 5. Summarize all columns

Generate a tidy data set where each column is average per subject and activity, resulting in a data frame of **180 rows and 68 columns**.
The data frame is save in **hra_summary.txt**

To read the data back:

```
data <- read.table("./hra_summary.txt", header = TRUE)
```
