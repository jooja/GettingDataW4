# Getting and Cleaning Data Course Project

'run_analysis.R' script works if following manner. Prior to running the script, set working directory (setwd) before running the script (downloads files to wd)

1. Downloads and unzips data (if it doesn't exists already). Source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Loads activity labels and features.
3. Only the measurements on the mean and standard deviation willbe extracted.
4. Column names are modified to be more readable.
5. Loads the 'train' and 'test' data; activity and subject columns are merged to the data.
6. 'Train' and 'test' data are merged.
