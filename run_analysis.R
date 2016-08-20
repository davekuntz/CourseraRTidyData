#Set directory to where UCI HAR Dataset is located if outside working directory
dr <- ''

#Get feature names/names of activities
feature_names <- read.table(file.path(dr, "features.txt"))

#Get training set data
subject_train <- read.table(file.path(dr, "train/subject_train.txt"))
x_train <- read.table(file.path(dr, "train/x_train.txt"))
y_train <- read.table(file.path(dr, "train/y_train.txt"))

#Get testing set data
subject_test <- read.table(file.path(dr, "test/subject_test.txt"))
x_test <- read.table(file.path(dr, "test/x_test.txt"))
y_test <- read.table(file.path(dr, "test/y_test.txt"))

#Combine tables
subject <- rbind(subject_train,subject_test)
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)

#Extract names of activities
names(x) <- feature_names$V2

#Rename subject and activity columns
names(subject)[names(subject)=="V1"] <- "subject.number"
names(y)[names(y)=="V1"] <- "activity"

#Replace activity numbers with names
y$activity <- gsub('1', 'walking', y$activity)
y$activity <- gsub('2', 'walking.upstairs', y$activity)
y$activity <- gsub('3', 'walking.downstairs', y$activity)
y$activity <- gsub('4', 'sitting', y$activity)
y$activity <- gsub('5', 'standing', y$activity)
y$activity <- gsub('6', 'laying', y$activity)


#Get columns with means and standard deviations.  I decided that the "meaningful" mean and 
#std columns were the ones that ended with mean() or std() and did not have X Y or Z as these
#values are already included in the total means/stds

x_means <- x[,grep('mean\\(\\)$',names(x))]
x_stds <- x[,grep('std\\(\\)$',names(x))]

#Combine into tidy data set
tidy_data <- cbind(subject,y,x_means,x_stds)

#Rename variables into more understandable names.  In R format, '.' represents a space
names(tidy_data)[names(tidy_data)=="tBodyAccMag-mean()"] <- "mean.tBodyAccMag"
names(tidy_data)[names(tidy_data)=="tGravityAccMag-mean()"] <- "mean.tGravityAccMag"
names(tidy_data)[names(tidy_data)=="tBodyAccJerkMag-mean()"] <- "mean.tBodyAccJerkMag"
names(tidy_data)[names(tidy_data)=="tBodyGyroMag-mean()"] <- "mean.tBodyGyroMag"
names(tidy_data)[names(tidy_data)=="tBodyGyroJerkMag-mean()"] <- "mean.tBodyGyroJerkMag"
names(tidy_data)[names(tidy_data)=="fBodyAccMag-mean()"] <- "mean.fBodyAccMag"
names(tidy_data)[names(tidy_data)=="fBodyBodyAccJerkMag-mean()"] <- "mean.fBodyBodyAccJerkMag"
names(tidy_data)[names(tidy_data)=="fBodyBodyGyroMag-mean()"] <- "mean.fBodyBodyGyroMag"
names(tidy_data)[names(tidy_data)=="fBodyBodyGyroJerkMag-mean()"] <- "mean.fBodyBodyGyroJerkMag"
names(tidy_data)[names(tidy_data)=="tBodyAccMag-std()"] <- "std.tBodyAccMag-std()"
names(tidy_data)[names(tidy_data)=="tGravityAccMag-std()"] <- "std.tGravityAccMag"
names(tidy_data)[names(tidy_data)=="tBodyAccJerkMag-std()"] <- "std.tBodyAccJerkMag"
names(tidy_data)[names(tidy_data)=="tBodyGyroMag-std()"] <- "std.tBodyGyroMag"
names(tidy_data)[names(tidy_data)=="tBodyGyroJerkMag-std()"] <- "std.tBodyGyroJerkMag"
names(tidy_data)[names(tidy_data)=="fBodyAccMag-std()"] <- "std.fBodyAccMag-std"
names(tidy_data)[names(tidy_data)=="fBodyBodyAccJerkMag-std()"] <- "std.fBodyBodyAccJerkMag"
names(tidy_data)[names(tidy_data)=="fBodyBodyGyroMag-std()"] <- "std.fBodyBodyGyroMag"
names(tidy_data)[names(tidy_data)=="fBodyBodyGyroJerkMag-std()"] <- "std.fBodyBodyGyroJerkMag"

#Aggregate to get averages of means and standard deviations
tidy_data_means <- aggregate(tidy_data[,-c(1,2)], by=list(tidy_data$subject.number,tidy_data$activity), FUN=mean)
#Rename group ids to more descriptive variable names
names(tidy_data_means)[names(tidy_data_means)=="Group.1"] <- "subject.number"
names(tidy_data_means)[names(tidy_data_means)=="Group.2"] <- "activity"

#Write tidy_data_means to text file
write.table(tidy_data_means, file=file.path(dr,"tidy_data_means.txt"), row.name=FALSE)


