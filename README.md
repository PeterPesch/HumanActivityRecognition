---
title: "README.md"
author: "Peter Pesch"
date: "28 november 2016"
---

## 0. Introduction

This document consists of 3 parts:

1. Contents of the repository - Describes the main folders of this repository.
2. The script: run_analysis.R - Explains the script that created the tidy data sets.
3. References - External and internal references

---

## 1. Contents of the repository

The repository contains 2 subfolders:

* UCI HAR Dataset - The raw dataset (including its documentation), as produced by the Human Activity Recognition experiments [1].
* Tidy Dataset - The 2 tidy datasets that were produced for the assignment.

The main folder contains:

* run_analysis.R - The script which produced the tidy datasets.
* CodeBook.md - Describes the tidy datasets, gives some info about the raw data, and describes the process of getting to the tidy data.
* README.md - This file.

The second tidy dataset (the dataset with the averages) can be loaded into R 
by setting the working directory to the main folder of this repository
and performing the command:

    average.tidy <- read.table("Tidy Dataset/HAR_averages_tidy_data.txt", header=TRUE)

---

## 2. The script: run_analysis.R

This is the script which has produced the tidy data sets.

The reasoning and the decisions that have lead to this script have been described in chapter 2 of the Code Book [3].

In this file I will restrict myself to explaining the actual script.

In step 0 (Reading the data sets) I am reading the raw data into R. 
The origin of the raw data have been described in chapter 1 of the Code Book.

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

    # Compose the training data set
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

The train data set has been devided over 3 files, see [2].
We add three identifying variables in front of the 561 measure variables:

* source - describes whether the observation comes from the train set or from the test set.
* subject - identifies the volunteer who performed the activity
* label - identifies the activity that was performed by the volunteer

Now we repeat the same process for the test data set:
    
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

In step 1 (merging the training and test sets) we collect all records (observations)
from both dataset into one big dataset.
    
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

In step 2 (Extract only mean and standard deviation) we collect 66 out of the 561 variables.
Section 2.1 of the Code Book [3] describes why I have chosen exactly those columns.

I select the mean variables by doing a grep on "mean()".
As the grep command considers parentheses as special characters, I have to escape them by to backslashes.

I select the standard deviation variables by doing a grep on "std()".

Just like in stap 1, I make sure that the 66 measurement variables are preceded by the
identifying variables source, subject and label.
    
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
    
Up until now, the records only had an integer (label) signifying the activity.
Step 3 adds a character version (activity) describing the activity,
by merging the dataset with label.activity.

Unfortunately, the activity column appears at the end.

So we rearrange the order of the columns, in order to get the 4 identifying variables
(source, subject, label and activity) in front of the 66 measurement variables.
    
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
    
Now all we have to do to get a tidy dataset, is to make the variable names more tidy.

As I explained in section 2.3 of the Code Book [3], I left the central part of the names
(the names of the signals) intact, and I used the "." as the word separator.
So I deleted the parentheses, and I replaced the dashes by dots.

I consider the resulting names to be as tidy as I can make them.
    
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
    
At this point, we have made our first tidy data set: HAR_tidy_data.
I have described this data set in more detail in section 3.2 of the Code Book [3].

---

Now we have to make a second tidy data set.

This dataset will contain the average of each of the 66 measurement variables
per activity per subject.

This time we will need 2 identifying variables: activity and subject.

Because of the nature of these experiments (see [1]), some readers will probably
be more interested in the averages per activity.
(And some readers might even be interested in the averages per subject).

However, I noticed that some of the resulting records were computed on more than 90 observations,
whereas other resulting records were based on less than 40 observations.
This means that I will have to add the number of observations (count) as an extra variable.

* First I split up the data set by activity and subject
* Then I made a (temporary) function which computes the number of observations and the average of each measurement variable
* And finally I applied that function to the split dataset.

Unfortunately, I ended up with a matrix with measurement variables in the rows in stead of in the columns.
Therefore, I transposed the matrix by means of t().

Now we only have to convert to data frame, change the variable names to signify that they now contain
average values, and add the 2 identifying variables in front.
    
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

At this point, we have made our second tidy data set: HAR_averages_tidy_data.
I have described this data set in more detail in section 3.1 of the Code Book [3].
    
---

## 3. References

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2] See "UCI HAR Dataset/README.txt", part of [1]

[3] CodeBook.md, in the main folder of this repository.