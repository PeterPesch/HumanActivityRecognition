---
title: "CodeBook.md"
author: "Peter Pesch"
date: "28 november 2016"
---

---

## 0. Introduction

This document consists of 4 parts:

1. Origin of the data - Describes how the raw was obtained
2. Study Design - Describes how the tidy data sets were constructed from the raw data
3. Code Book - The actual code book, which describes the data sets and the variables
4. References - References

---

## 1. Origin of the data

The raw data was obtained from the Human Activity Recognition Using Smartphones Dataset [1], and can be found in subdirectory "UCI HAR Dataset".

The experiment has been carried out by 30 volunteers: 21 for generating the training data and 9 for generating the test data.
Each volunteer performed 6 activities.

The UCI HAR Dataset contains:

* Dcumentation - in the main folder
* Raw data from the training phase - in subfolder "train/Inertial Signals"
* Resulting dataset from the training phase - in subfolder "train"
* Raw data from the test phase - in subfolder "test/Inertial Signals"
* Resulting data from the test phase - in subfolder "test"

---

## 2. Study Design

Our raw data consists of the resulting data from the UCI HAR experiments [1].

Although the experiments dealt with data in standard gravity units 'g' and data in unit 'rad/s', the data in the publication [1] has been normalized and bounded within [-1. 1] [see 2].
This means that our raw data consits of unitless numbers, and not of data in g and rad/s.

Out of these raw data, I have constructed 2 tidy data sets:

* HAR_tidy_data.txt
* HAR_averages_tidy_data.txt

This construction can be repeated in R 
by setting the working directory to the main folder of this repository
and performing the command:

    source("run_analysis.R")

### 2.1 Selection of the subset of variables from the raw data
The experiment dealt with 17 3-dimensional or 1 -dimensional signals, giving a total of 33 signals [see 3].
On each of these signals, up to 17 transformations were performed, giving a total of 554 variables.
Furthermore, 7 additional variables were added, giving a total of 561 variables in their resulting datasets (= our raw data).

Out of those 17 transformations, I selected the mean() and the std() (Mean value and Standard deviation, [see 3]), giving a total of 66 variables from the raw data variables. The 7 additional variables were left out, as they resulted from some unspecified signal window sample (see [3]).

### 2.2 Identification of the observations in the subset
For each record from the train and test dataset, we collected the label (signifying the acticity) and the subject (signifying the volunteer), as per the instructions in [2].
I added a variable "source", signifying whether the record came from the train dataset or the test dataset.
I added a variable "activity", giving a readable form of the activity (in addition to the integer form "label").

### 2.3 Column names for the tidy data sets.
As a non-native english speaker, I needed a word separator to keep the column names readable for myself. I opted for the "." as separator.

Furthermore, I left the (central parts of the) signal names intact, as I do not have the physical background to properly rename them without inadvertedly changing their meaning. Therefore the column names will contain non-standardised parts like "tBodyGyroJerkMag" or "tGravityAccMag".

For the code book, I used phrases from the first 3 alineas of [3] to describe the central (signal) part of the name.

### 2.4 Resulting dataset: HAR_tidy_data.txt
The records from the abovementioned subsets from the train dataset and the test dataset were combined in HAR_tidy_data.txt.

The file can be found in subdirectory "Tidy Dataset".

It can be loaded into R 
by setting the working directory to the main folder of this repository
and performing the command:

    har.tidy <- read.table("Tidy Dataset/HAR_tidy_data.txt", header=TRUE)

### 2.5 Transformations on HAR_tidy_data
I split up the tidy data by activity and subject (=volunteer).
For each of the 66 measure variables I computed the mean value (average).

I added a variable "count", signiying the number of records (observations) on which the mean was based.
This makes it possible to use the resulting tidy data set to compute the (weighted) average per activity or per subject.

### 2.6 Resulting dataset: HAR_averages_tidy_data
The resulting records were combined in HAR_averages_tidy_data.txt.

The file can be found in subdirectory "Tidy Dataset".

It can be loaded into R 
by setting the working directory to the main folder of this repository
and performing the command:

    average.tidy <- read.table("Tidy Dataset/HAR_averages_tidy_data.txt", header=TRUE)

---

## 3. Code Book

The data base consists of 2 files, which can be found in subdirectory "Tidy Dataset".

### 3.1. HAR_averages_tidy_data.txt

A tidy data set, which contains averages per activity and subject
of the mean and standard deviation variables
from the original result data sets of the HAR experiment [1]

| Variable                      | Unit                                | Description                                                                                                                                                   |
| ------- | --------------- | -------------------------------------------------------------------------------- |
| activity                      | varchar(18)                         | Describes the activity the person was performing                                                                                                                      |
| subject                       | integer                             | Identifies the person who performed the activities                                                                                                                    |
| count                         | integer                             | number of original observations that were used to compute the average. You will need this as a weight factor whenever you want to combine the averages.               |
| avg.tBodyAcc.mean.X           | normalised number between -1 and 1) | Average mean of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                               |
| avg.tBodyAcc.mean.Y           | normalised number between -1 and 1) | Average mean of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                               |
| avg.tBodyAcc.mean.Z           | normalised number between -1 and 1) | Average mean of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                               |
| avg.tBodyAcc.std.X            | normalised number between -1 and 1) | Average standard deviation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                 |
| avg.tBodyAcc.std.Y            | normalised number between -1 and 1) | Average standard deviation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                 |
| avg.tBodyAcc.std.Z            | normalised number between -1 and 1) | Average standard deviation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                 |
| avg.tGravityAcc.mean.X        | normalised number between -1 and 1) | Average mean of the gravity in the X direction, normalized and bounded within [-1,1].                                                                                 |
| avg.tGravityAcc.mean.Y        | normalised number between -1 and 1) | Average mean of the gravity in the Y direction, normalized and bounded within [-1,1].                                                                                 |
| avg.tGravityAcc.mean.Z        | normalised number between -1 and 1) | Average mean of the gravity in the Z direction, normalized and bounded within [-1,1].                                                                                 |
| avg.tGravityAcc.std.X         | normalised number between -1 and 1) | Average standard deviation of the gravity in the X direction, normalized and bounded within [-1,1].                                                                   |
| avg.tGravityAcc.std.Y         | normalised number between -1 and 1) | Average standard deviation of the gravity in the Y direction, normalized and bounded within [-1,1].                                                                   |
| avg.tGravityAcc.std.Z         | normalised number between -1 and 1) | Average standard deviation of the gravity in the Z direction, normalized and bounded within [-1,1].                                                                   |
| avg.tBodyAccJerk.mean.X       | normalised number between -1 and 1) | Average mean of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                   |
| avg.tBodyAccJerk.mean.Y       | normalised number between -1 and 1) | Average mean of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                   |
| avg.tBodyAccJerk.mean.Z       | normalised number between -1 and 1) | Average mean of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                   |
| avg.tBodyAccJerk.std.X        | normalised number between -1 and 1) | Average standard deviation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                     |
| avg.tBodyAccJerk.std.Y        | normalised number between -1 and 1) | Average standard deviation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                     |
| avg.tBodyAccJerk.std.Z        | normalised number between -1 and 1) | Average standard deviation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                     |
| avg.tBodyGyro.mean.X          | normalised number between -1 and 1) | Average mean of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                                            |
| avg.tBodyGyro.mean.Y          | normalised number between -1 and 1) | Average mean of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                                            |
| avg.tBodyGyro.mean.Z          | normalised number between -1 and 1) | Average mean of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                                            |
| avg.tBodyGyro.std.X           | normalised number between -1 and 1) | Average standard deviation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                              |
| avg.tBodyGyro.std.Y           | normalised number between -1 and 1) | Average standard deviation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                              |
| avg.tBodyGyro.std.Z           | normalised number between -1 and 1) | Average standard deviation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                              |
| avg.tBodyGyroJerk.mean.X      | normalised number between -1 and 1) | Average mean of the jerk of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                                |
| avg.tBodyGyroJerk.mean.Y      | normalised number between -1 and 1) | Average mean of the jerk of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                                |
| avg.tBodyGyroJerk.mean.Z      | normalised number between -1 and 1) | Average mean of the jerk of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                                |
| avg.tBodyGyroJerk.std.X       | normalised number between -1 and 1) | Average standard deviation of the jerk of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                  |
| avg.tBodyGyroJerk.std.Y       | normalised number between -1 and 1) | Average standard deviation of the jerk of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                  |
| avg.tBodyGyroJerk.std.Z       | normalised number between -1 and 1) | Average standard deviation of the jerk of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                  |
| avg.tBodyAccMag.mean          | normalised number between -1 and 1) | Average mean of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                                                                 |
| avg.tBodyAccMag.std           | normalised number between -1 and 1) | Average standard deviation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                                                   |
| avg.tGravityAccMag.mean       | normalised number between -1 and 1) | Average mean of the magnitude of the gravity, normalized and bounded within [-1,1].                                                                                   |
| avg.tGravityAccMag.std        | normalised number between -1 and 1) | Average standard deviation of the magnitude of the gravity, normalized and bounded within [-1,1].                                                                     |
| avg.tBodyAccJerkMag.mean      | normalised number between -1 and 1) | Average mean of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                                                     |
| avg.tBodyAccJerkMag.std       | normalised number between -1 and 1) | Average standard deviation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                                       |
| avg.tBodyGyroMag.mean         | normalised number between -1 and 1) | Average mean of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                                                              |
| avg.tBodyGyroMag.std          | normalised number between -1 and 1) | Average standard deviation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                                                |
| avg.tBodyGyroJerkMag.mean     | normalised number between -1 and 1) | Average mean of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].                                                  |
| avg.tBodyGyroJerkMag.std      | normalised number between -1 and 1) | Average standard deviation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].                                    |
| avg.fBodyAcc.mean.X           | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                            |
| avg.fBodyAcc.mean.Y           | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                            |
| avg.fBodyAcc.mean.Z           | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                            |
| avg.fBodyAcc.std.X            | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].              |
| avg.fBodyAcc.std.Y            | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].              |
| avg.fBodyAcc.std.Z            | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].              |
| avg.fBodyAccJerk.mean.X       | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                |
| avg.fBodyAccJerk.mean.Y       | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                |
| avg.fBodyAccJerk.mean.Z       | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                |
| avg.fBodyAccJerk.std.X        | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].  |
| avg.fBodyAccJerk.std.Y        | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].  |
| avg.fBodyAccJerk.std.Z        | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].  |
| avg.fBodyGyro.mean.X          | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                         |
| avg.fBodyGyro.mean.Y          | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                         |
| avg.fBodyGyro.mean.Z          | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                         |
| avg.fBodyGyro.std.X           | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].           |
| avg.fBodyGyro.std.Y           | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].           |
| avg.fBodyGyro.std.Z           | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].           |
| avg.fBodyAccMag.mean          | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                              |
| avg.fBodyAccMag.std           | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                |
| avg.fBodyBodyAccJerkMag.mean  | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                  |
| avg.fBodyBodyAccJerkMag.std   | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].    |
| avg.fBodyBodyGyroMag.mean     | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                           |
| avg.fBodyBodyGyroMag.std      | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].             |
| avg.fBodyBodyGyroJerkMag.mean | normalised number between -1 and 1) | Average mean of the fast Fourier transformation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].               |
| avg.fBodyBodyGyroJerkMag.std  | normalised number between -1 and 1) | Average standard deviation of the fast Fourier transformation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1]. |


### 3.2. HAR_tidy_data.txt

A tidy data set, which contains the mean and standard deviation variables
from the original result data sets of the HAR experiment [1]


| Variable                  | Unit                                | Description                                                                                                                                                   |
| ------- | --------------- | -------------------------------------------------------------------------------- |
| source                    | "train" or "test"                   | Describes whether this observation was made during the Training phase or during the Test phase                                                                |
| subject                   | integer                             | Identifies the person who performed the activities                                                                                                            |
| label                     | integer                             | Identified the activity the person was performing                                                                                                             |
| activity                  | varchar(18)                         | Describes the activity the person was performing                                                                                                              |
| tBodyAcc.mean.X           | normalised number between -1 and 1) | Mean of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                               |
| tBodyAcc.mean.Y           | normalised number between -1 and 1) | Mean of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                               |
| tBodyAcc.mean.Z           | normalised number between -1 and 1) | Mean of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                               |
| tBodyAcc.std.X            | normalised number between -1 and 1) | Standard deviation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                 |
| tBodyAcc.std.Y            | normalised number between -1 and 1) | Standard deviation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                 |
| tBodyAcc.std.Z            | normalised number between -1 and 1) | Standard deviation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                 |
| tGravityAcc.mean.X        | normalised number between -1 and 1) | Mean of the gravity in the X direction, normalized and bounded within [-1,1].                                                                                 |
| tGravityAcc.mean.Y        | normalised number between -1 and 1) | Mean of the gravity in the Y direction, normalized and bounded within [-1,1].                                                                                 |
| tGravityAcc.mean.Z        | normalised number between -1 and 1) | Mean of the gravity in the Z direction, normalized and bounded within [-1,1].                                                                                 |
| tGravityAcc.std.X         | normalised number between -1 and 1) | Standard deviation of the gravity in the X direction, normalized and bounded within [-1,1].                                                                   |
| tGravityAcc.std.Y         | normalised number between -1 and 1) | Standard deviation of the gravity in the Y direction, normalized and bounded within [-1,1].                                                                   |
| tGravityAcc.std.Z         | normalised number between -1 and 1) | Standard deviation of the gravity in the Z direction, normalized and bounded within [-1,1].                                                                   |
| tBodyAccJerk.mean.X       | normalised number between -1 and 1) | Mean of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                                   |
| tBodyAccJerk.mean.Y       | normalised number between -1 and 1) | Mean of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                                   |
| tBodyAccJerk.mean.Z       | normalised number between -1 and 1) | Mean of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                                   |
| tBodyAccJerk.std.X        | normalised number between -1 and 1) | Standard deviation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                                     |
| tBodyAccJerk.std.Y        | normalised number between -1 and 1) | Standard deviation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                                     |
| tBodyAccJerk.std.Z        | normalised number between -1 and 1) | Standard deviation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                                     |
| tBodyGyro.mean.X          | normalised number between -1 and 1) | Mean of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                                            |
| tBodyGyro.mean.Y          | normalised number between -1 and 1) | Mean of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                                            |
| tBodyGyro.mean.Z          | normalised number between -1 and 1) | Mean of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                                            |
| tBodyGyro.std.X           | normalised number between -1 and 1) | Standard deviation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                              |
| tBodyGyro.std.Y           | normalised number between -1 and 1) | Standard deviation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                              |
| tBodyGyro.std.Z           | normalised number between -1 and 1) | Standard deviation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                              |
| tBodyGyroJerk.mean.X      | normalised number between -1 and 1) | Mean of the jerk of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                                |
| tBodyGyroJerk.mean.Y      | normalised number between -1 and 1) | Mean of the jerk of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                                |
| tBodyGyroJerk.mean.Z      | normalised number between -1 and 1) | Mean of the jerk of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                                |
| tBodyGyroJerk.std.X       | normalised number between -1 and 1) | Standard deviation of the jerk of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                                  |
| tBodyGyroJerk.std.Y       | normalised number between -1 and 1) | Standard deviation of the jerk of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                                  |
| tBodyGyroJerk.std.Z       | normalised number between -1 and 1) | Standard deviation of the jerk of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                                  |
| tBodyAccMag.mean          | normalised number between -1 and 1) | Mean of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                                                                 |
| tBodyAccMag.std           | normalised number between -1 and 1) | Standard deviation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                                                   |
| tGravityAccMag.mean       | normalised number between -1 and 1) | Mean of the magnitude of the gravity, normalized and bounded within [-1,1].                                                                                   |
| tGravityAccMag.std        | normalised number between -1 and 1) | Standard deviation of the magnitude of the gravity, normalized and bounded within [-1,1].                                                                     |
| tBodyAccJerkMag.mean      | normalised number between -1 and 1) | Mean of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                                                     |
| tBodyAccJerkMag.std       | normalised number between -1 and 1) | Standard deviation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                                       |
| tBodyGyroMag.mean         | normalised number between -1 and 1) | Mean of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                                                              |
| tBodyGyroMag.std          | normalised number between -1 and 1) | Standard deviation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                                                |
| tBodyGyroJerkMag.mean     | normalised number between -1 and 1) | Mean of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].                                                  |
| tBodyGyroJerkMag.std      | normalised number between -1 and 1) | Standard deviation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].                                    |
| fBodyAcc.mean.X           | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                            |
| fBodyAcc.mean.Y           | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                            |
| fBodyAcc.mean.Z           | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                            |
| fBodyAcc.std.X            | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the accelleration of the body in the X direction, normalized and bounded within [-1,1].              |
| fBodyAcc.std.Y            | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].              |
| fBodyAcc.std.Z            | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].              |
| fBodyAccJerk.mean.X       | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].                |
| fBodyAccJerk.mean.Y       | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].                |
| fBodyAccJerk.mean.Z       | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].                |
| fBodyAccJerk.std.X        | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the X direction, normalized and bounded within [-1,1].  |
| fBodyAccJerk.std.Y        | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the Y direction, normalized and bounded within [-1,1].  |
| fBodyAccJerk.std.Z        | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the jerk of the accelleration of the body in the Z direction, normalized and bounded within [-1,1].  |
| fBodyGyro.mean.X          | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].                         |
| fBodyGyro.mean.Y          | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].                         |
| fBodyGyro.mean.Z          | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].                         |
| fBodyGyro.std.X           | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the angular velocity of the body in the X direction, normalized and bounded within [-1,1].           |
| fBodyGyro.std.Y           | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the angular velocity of the body in the Y direction, normalized and bounded within [-1,1].           |
| fBodyGyro.std.Z           | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the angular velocity of the body in the Z direction, normalized and bounded within [-1,1].           |
| fBodyAccMag.mean          | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                              |
| fBodyAccMag.std           | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the magnitude of the accelleration of the body, normalized and bounded within [-1,1].                |
| fBodyBodyAccJerkMag.mean  | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].                  |
| fBodyBodyAccJerkMag.std   | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the magnitude of the jerk of the accelleration of the body, normalized and bounded within [-1,1].    |
| fBodyBodyGyroMag.mean     | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].                           |
| fBodyBodyGyroMag.std      | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the magnitude of the angular velocity of the body, normalized and bounded within [-1,1].             |
| fBodyBodyGyroJerkMag.mean | normalised number between -1 and 1) | Mean of the fast Fourier transformation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1].               |
| fBodyBodyGyroJerkMag.std  | normalised number between -1 and 1) | Standard deviation of the fast Fourier transformation of the magnitude of the jerk of the angular velocity of the body, normalized and bounded within [-1,1]. |

---

## 4. References

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

[2] See section "Notes:" in "UCI HAR Dataset/README.txt", part of [1]

[3] See "UCI HAR Dataset/features_info.txt", part of [1]

