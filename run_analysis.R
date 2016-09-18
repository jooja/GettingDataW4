library(reshape2)

# Set working directory (setwd) before running the script (downloads files to wd)
# Download and unzip data (if it doesn't exists already)
storedfile <- "data.zip"
if (!file.exists(storedfile)){
  downloadedfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(downloadedfile, storedfile, method="curl")
} else {print("Existing ZIP file found & used.")}
if (!file.exists("UCI HAR Dataset")) { 
  unzip(storedfile) 
} else {print("Existing unzipped data (directory) found & used.")}

# Load labels + features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Only the measurements on the mean and standard deviation to be extracted
# Modify the names to be more readable
featuresExtracted <- grep(".*mean[(][)].*|.*std[(][)].*", features[,2])
featuresExtracted.names <- features[featuresExtracted,2]
featuresExtracted.names <- gsub("-mean[(][)]", "mean", featuresExtracted.names)
featuresExtracted.names <- gsub("-std[(][)]", "std", featuresExtracted.names)
featuresExtracted.names <- gsub("-", "", featuresExtracted.names)
featuresExtracted.names <- tolower(featuresExtracted.names)

# Load the 'train' and 'test' data; merge activity and subject columns
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresExtracted]
train_activities <- read.table("./UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train, train_activities, train_subjects)
test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featuresExtracted]
test_activities <- read.table("./UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test, test_activities, test_subjects)

# Merge train and test data, add column names
mergedData <- rbind(train, test)
colnames(mergedData) <- c(featuresExtracted.names, "activity", "subject")

# Convert activities (numeric) to factors
mergedData$activity <- factor(mergedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])

# Melt mergedData, apply dcast (examples e.g. http://seananderson.ca/2013/10/19/reshape.html)
meltedMergedData <- melt(mergedData, id = c("subject", "activity"))
meanData <- dcast(meltedMergedData, subject + activity ~ variable, mean)

# write tidy meanData to 'tidy.txt'
write.table(meanData, "tidy.txt", row.names = FALSE, quote = FALSE)
