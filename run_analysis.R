## Data Cleanup Project ##
# Date: 23 Aug 2015

# NOTE: The following script loads several datasets, merges them, and produces
# a second dataset of cleanedup data (i.e. tidy dataset)

library(dplyr)

## Response Variables Cleanup ##
testY<-read.table("~/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
trainY<-read.table("~/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
yData<-rbind(testY,trainY)
names(yData)<-"Y_activity"
yData$full_activity[yData$Y_activity==1]<-"walking"
yData$full_activity[yData$Y_activity==2]<-"walking_upstairs"
yData$full_activity[yData$Y_activity==3]<-"walking_downstairs"
yData$full_activity[yData$Y_activity==4]<-"sitting"
yData$full_activity[yData$Y_activity==5]<-"standing"
yData$full_activity[yData$Y_activity==6]<-"laying"
rm(testY, trainY) # Cleanup

## Test/Training Subject Cleanup ##
trainSub<-read.table("~/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
testSub<-read.table("~/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
subData<-rbind(testSub,trainSub)
names(subData)<-"Subject"
rm(testSub, trainSub)

## Explanatory Variable Cleanup ##
testX<-read.table("~/UCI HAR Dataset/test/x_test.txt", quote="\"", comment.char="")
trainX<-read.table("~/UCI HAR Dataset/train/x_train.txt", quote="\"", comment.char="")
xData<-rbind(testX,trainX)
rm(testX,trainX) # Cleanup
XLab<-read.table("~/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
names(xData)<-XLab[,2] # Rename columns using data labels in features.txt
colSub<-grep("mean|std",XLab[,2],value=TRUE)
xData<-subset(xData, select=colSub)
rm(XLab,colSub) # Cleanup

## Merge Subject, Response and Explanatory Variables ##
fullData<-cbind(subData,yData,xData)
rm(yData,xData,subData) # Cleanup

fullData$Subject <- as.factor(fullData$Subject)

## Create Second Tidy Dataset and Export ##
gData <- group_by(fullData, Subject, full_activity)
newData<-summarise_each(gData,funs(mean))
write.table(newData,"~/UCI HAR Dataset/new_tidy_dataSet.txt", row.names=FALSE, sep="")
