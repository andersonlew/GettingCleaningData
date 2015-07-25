######################################
## Lew Anderson
## Coursera Getting and Cleaning Data 
## Final Project
## July 2015
######################################

## Set the Working Directory
## The Zip file from  
setwd("~/Documents/ROnlineCourse/GettingCleaningData")

##Creates a 'data' file if it doesn't exist
if (!file.exists("data")){
  dir.create("data")
}

## Create a temporary file for the 'Untidy' data
temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
## This download takes a minute
download.file(fileURL, temp, method = "curl")
## FileList has all the files from the zipped folder and places it in the 'data' folder
FileList <- unzip(temp, list=F, exdir = "./data")
list.files("./data")
list.files("./data/UCI HAR Dataset")

setwd("./data/UCI HAR Dataset")

#######################################
## Combine the files in the test group
#######################################

fileList <- list.files("./test")

## The ID vector contains the patients ID (1:30)
ID <- read.table("./test/subject_test.txt")  
dim(ID)
## Name the vector 'ID'
names(ID) <- c("ID")

## The TestLabels Vector contains the label information (1:6 <- WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
TestLabels <- read.table("./test/y_test.txt") 
dim(TestLabels)
## Name the vector 'TestLabels'
names(TestLabels) <- c("Labels")

## The Variables table contains the variable information (561 Variables)
## However, we only want to keep Mean and Std, which are always the first 1:6 
## of a new variable.  
tVariables <- read.table("./test/X_test.txt") 
dim(tVariables)

## Load the 561 Variable Names:  
tdataNames <- read.table("./features.txt")
## Make the second column a vector of names
tdataNames <- as.character(tdataNames$V2)
## Make 'dataNames' my Variable names
names(tVariables) <- tdataNames

## Only want to keep 'mean' and 'std'
tVariables <- tVariables[, grep('mean|std', names(tVariables))]

## Clean up the column names
names(tVariables) <- gsub("-mean", "Mean", names(tVariables))
names(tVariables) <- gsub("-std", "Std", names(tVariables))
names(tVariables) <- gsub("\\(", "", names(tVariables))
names(tVariables) <- gsub("\\)", "", names(tVariables))
names(tVariables) <- gsub("-", "", names(tVariables))
names(tVariables) <- gsub("Body", "", names(tVariables))

## Create a 'Group' category so we know which rows are from the test group
category <- data.frame(rep("test", nrow(tVariables)))
names(category) <- c("Group")

## Combine 'ID', 'TestLabels', and the Variables data frame.  
testData <- cbind(ID, category, TestLabels, tVariables)

########################################
## Combine the files in the train group
########################################

fileList <- list.files("./train")

## The ID vector contains the patients ID (1:30)
ID <- read.table("./train/subject_train.txt")  
dim(ID)
## Name the vector 'ID'
names(ID) <- c("ID")

## The TestLabels Vector contains the label information (1:6 <- WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
TrainLabels <- read.table("./train/y_train.txt") 
dim(TrainLabels)
## Name the vector 'TestLabels'
names(TrainLabels) <- c("Labels")

trVariables <- read.table("./train/X_train.txt") 
dim(trVariables)

## Make 'dataNames' my Variable names
names(trVariables) <- tdataNames

## Only want to keep 'mean' and 'std'
trVariables <- trVariables[, grep('mean|std', names(trVariables))]

## Clean up the column names
names(trVariables) <- gsub("-mean", "Mean", names(trVariables))
names(trVariables) <- gsub("-std", "Std", names(trVariables))
names(trVariables) <- gsub("\\(", "", names(trVariables))
names(trVariables) <- gsub("\\)", "", names(trVariables))
names(trVariables) <- gsub("-", "", names(trVariables))
names(trVariables) <- gsub("Body", "", names(trVariables))

## Create a 'Group' category so we know which rows are from the training group
category <- data.frame(rep("train", nrow(trVariables)))
names(category) <- c("Group")

trData <- cbind(ID, category, TrainLabels, trVariables)

UCIdata  <- rbind(testData, trData)

write.table(UCIdata, file = "./UCIdata.txt", col.names=TRUE, row.names=FALSE)


