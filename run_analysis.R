
# get header column names from the features.txt file
feature_header <- read.table("UCI\ HAR\ Dataset/features.txt", colClasses="character")

# get activity labels from the activity_labels file
activity_labels <- read.table("UCI\ HAR\ Dataset/activity_labels.txt", colClasses="character")

# get user data from the two sets and join them into one set
x_test <- read.table("UCI\ HAR\ Dataset/test/X_test.txt")
x_train <- read.table("UCI\ HAR\ Dataset/train/X_train.txt")
full_set <- rbind(x_test, x_train)

# add header/column names
colnames(full_set) <- feature_header$V2

# make a set of just the columns whose names contain mean and std in them
full_set <- full_set[, grepl("mean|std", names(full_set), ignore.case=TRUE)]

# read in activity type data for both data sets and join them
y_test <- read.table("UCI\ HAR\ Dataset/test/y_test.txt")
y_train <- read.table("UCI\ HAR\ Dataset/train/y_train.txt")
all_activities <- rbind(y_test, y_train)

# translate activity ids to human readable strings and add a column name
all_activities$V1 <- factor(all_activities$V1, activity_labels$V1, activity_labels$V2)
colnames(all_activities) <- c("ActivityName")

# add activity column to dataset
full_set <- cbind(all_activities, full_set)

# read in subject data from both data sets and join them and add a column name
subject_test <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt")
subject_train <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt")
all_subjects <- rbind(subject_test, subject_train)
colnames(all_subjects) <- c("Subject")

# add subject column to dataset
full_set <- cbind(all_subjects, full_set)

# aggregate the data, and calculate the mean for all values, grouped by Subject and ActivityName
final_data <- aggregate(. ~ Subject + ActivityName, FUN = mean, data=full_set, na.rm=TRUE)

# write the tidy data table to a file
write.table(final_data, file = "tidy.txt", row.name=FALSE)

