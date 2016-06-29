library(reshape2)

#read training dataset
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

#read test dataset
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#read activity labels
activitylabels <- read.table("activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])

#read features
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement
features_required <- grep(".*mean.*|.*std.*", features[,2])
features_required_names <- features[features_required,2]
x_train<-x_train[features_required]
x_test<-x_test[features_required]

alldata<-rbind(cbind(subject_train,y_train,x_train),cbind(subject_test,y_test,x_test))

#3. Uses descriptive activity names to name the activities in the data set
alldata$activity <- factor(alldata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
alldata$subject <- as.factor(alldata$subject)

#4. Appropriately labels the data set with descriptive variable names.
colnames(alldata) <- c("subject", "activity", features_required_names)


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
alldata_melted <- melt(alldata, id = c("subject", "activity"))
alldata_mean <- dcast(alldata_melted, subject + activity ~ variable, mean)

write.table(alldata_mean, "alldata_mean.txt", row.name=FALSE)

