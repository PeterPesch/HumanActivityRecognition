#####################################
##  Step 0 - Reading the datasets  ##
#####################################

print("Step 0 - Reading the datasets")

## Read the names of the activities
label.activity      <- read.table("UCI HAR Dataset/activity_labels.txt")
names(label.activity) <- c("label", "activity")

## Read the column names of the observation sets
names.raw           <- read.table("UCI HAR Dataset/features.txt",
                                  stringsAsFactors=FALSE)

print("    (Reading the training set might take some time ...)")
## Read the data from the training phase (third file might take some time)
train.subject       <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.label         <- read.table("UCI HAR Dataset/train/y_train.txt")
train.observation   <- read.table("UCI HAR Dataset/train/X_train.txt")  ## ...

## Compose the training data set
train.combined      <- cbind(
    source="train",
    train.subject,
    train.label,
    train.observation)
rm("train.subject")
rm("train.label")
rm("train.observation")

combined.names      <- c(
    "source",
    "subject",
    "label",
    names.raw[,2])
names(train.combined) <- combined.names
rm("names.raw")

print("    (Reading the test set might also take some time ...)")

## Read the data from the test phase (third file might take some time)
tst.subject         <- read.table("UCI HAR Dataset/test/subject_test.txt")
tst.label           <- read.table("UCI HAR Dataset/test/y_test.txt")
tst.observation     <- read.table("UCI HAR Dataset/test/X_test.txt")    ## ...

## Compose the test data set
tst.combined        <- cbind(
    source="test",
    tst.subject,
    tst.label,
    tst.observation)
rm("tst.subject")
rm("tst.label")
rm("tst.observation")

names(tst.combined) <- combined.names
rm("combined.names")

##  At this point, our environment contains 3 objects:
##  - train.combined: dataset with observations from the training phase
##  - tst.combined: dataset with observations from the testing phase
##  - label.activity: translates 'label' to the name of the 'activity'

############################################################################
##  Step 1                                                                ##
##  Merge the training and test sets to create one data set               ##
##  with all observations from the Human Activity Recognition experiment  ##
############################################################################

print("Step 1 - Merging the training and test sets")

## Create a data set which contains each observation from both sets.
har.combined <- rbind(train.combined, tst.combined)
rm("train.combined")
rm("tst.combined")

##  At this point, our environment contains 2 objects:
##  - har.combined: dataset with all observations from the HAR experiment
##  - label.activity: translates 'label' to the name of the 'activity'

##############################################################################
##  Step 2                                                                  ##
##  Extract only the measurements on the mean and standard deviation.       ##
##############################################################################

print("Step 2 - Extract only mean and standard deviation")

##  Find Means and Standard Deviations
har.is.mean <- grepl("-mean\\(\\)", names(har.combined))
har.is.std <- grepl("-std\\(\\)", names(har.combined))

##  Base columns for tidy data set
har.temp <- data.frame(
    source=har.combined$source,
    subject=har.combined$subject,
    label=har.combined$label
)

##  Add all columns with means or standard deviations
har.temp <- cbind(
    har.temp,
    har.combined[,har.is.mean | har.is.std]
)
rm("har.combined")
rm("har.is.mean")
rm("har.is.std")

##  At this point, our environment contains 2 objects:
##  - har.temp: dataset with all mean and std variables from the HAR experiment
##  - label.activity: translates 'label' to the name of the 'activity'


##############################################################################
##  Step 3                                                                  ##
##  Use descriptive activity names to name the activities in the data set.  ##
##############################################################################

print("Step 3 - Use descriptive activity names.")

##  Add descriptive activity names
har.temp <- merge(har.temp, label.activity, by="label")
rm("label.activity")

## Find all column names except source, subject, label, activity
other.names <- names(har.temp)[
    !(names(har.temp) %in% (c("source", "subject", "label", "activity")))]

## Now move those 4 columns to the front
har.temp <- har.temp[, c("source","subject","label","activity", other.names)]
rm("other.names")

##  At this point, our environment contains 1 object:
##  - har.temp: dataset with all mean and std variables from the HAR experiment
##              including the names of the activity


##############################################################################
##  Step 4                                                                  ##
##  Appropriately labels the data set with descriptive variable names.      ##
##############################################################################

print("Step 4 - Use descriptive variable names.")

##  Remove the ()'s from the column names.
names(har.temp) <- gsub("\\(\\)", "", names(har.temp))

##  Replace '-' by '.'
names(har.temp) <- gsub("-", ".", names(har.temp))

##  Rename the tidy data set
har.tidy <- har.temp
rm(har.temp)

if(!file.exists("./Tidy Dataset")){dir.create("./Tidy Dataset")}
write.table(har.tidy, "Tidy Dataset/HAR_tidy_data.txt")

##  At this point, our environment contains 1 object:
##  - har.tidy: tidy dataset with all mean and std variables
##              from the HAR experiment


######################################################################
##  Step 5                                                          ##
##  Create a second tidy dataset                                    ##
##  with the average of each variable for each activity and subset  ##
######################################################################

print("Step 5 - Create a second tidy dataset.")

## Split the tidy data set on activity and subject,
## leaving out the first 4 columns (so we keep only the measurement columns)
s <- split(har.tidy[, -(1:4)], paste(har.tidy$activity, har.tidy$subject, sep="-"))
rm("har.tidy")

count_and_means <- function(x) {
    c(
        count=nrow(x),      ## number of observations in this data set
        sapply(x, mean)     ## average value for each column
    )
}

## For each part of s, we compute the count and means,
## we simplify the result in order to get a matrix (outer sapply),
## and we transpose the matrix to get the variables in the columns (t).
avg_untidy <- t(sapply(s, count_and_means))
rm("count_and_means")
rm("s")

## We convert the result into a data frame,
## and change the names of the columns so signify that they contain averages.
df <- data.frame(avg_untidy)
names(df)[2:ncol(df)] <- paste("avg", names(df)[2:ncol(df)], sep=".")
rm("avg_untidy")

## Finaly we create a tidy data set by adding activity and subject columns.
average.tidy <- data.frame(
    activity=sub("-.*", "", rownames(df)),
    subject=sub(".*-", "", rownames(df)),
    df
)
rm("df")

## At this point column subject contains a factor representing integers
## This could lead to misinterpretations, so we convert to integer
average.tidy$subject <- as.integer(as.character(average.tidy$subject))
average.tidy <- average.tidy[order(average.tidy$activity, average.tidy$subject),]

## At this point the rownames are no longer necessary
rownames(average.tidy) <- NULL

## Now we have a tidy dataset.
## For every activity, for every subject
##   we have the average value for each of the variables form the tidy dataset.

if(!file.exists("./Tidy Dataset")){dir.create("./Tidy Dataset")}
write.table(average.tidy, "Tidy Dataset/HAR_averages_tidy_data.txt")

##  At this point, our environment contains 1 object:
##  - average.tidy: tidy dataset with for each activity and subject
##                      the number of observations
##                      and the averages of all mean and std variables
##                  from the HAR experiment

