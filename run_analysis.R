## My R program script for the Course Project in
## the Getting and Cleaning Data course -- April, 2015


# --- set the working directory
if(!file.exists("c:/WD")){dir.create("C:/WD")}
setwd("C:/WD")

# --- get the working directory to verify it is set correctly
getwd()

# --- create original_Downloaded_Data directory to keep original data if it doesn't exist
if(!file.exists("original_Downloaded_Data")){dir.create("original_Downloaded_Data")}

# --- Set the data source URL name
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# --- download the data files
download.file(fileUrl, dest="./original_Downloaded_Data/dataset.zip", mode="wb")

# --- unzip the files ---
unzip("./original_Downloaded_Data/dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, unzip = "internal", setTimes = FALSE)

# --- reads the files into R
dataTest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = TRUE)
dataTestY <- read.table("./UCI HAR Dataset/test/y_test.txt", header = TRUE)
dataTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = TRUE)
dataTrainY <- read.table("./UCI HAR Dataset/train/y_train.txt", header = TRUE)
# View(dataTest)
# View(dataTrain)
# intersect(names(dataTest), names(dataTestY))
# intersect(names(dataTrain), names(dataTrainY))
# intersect(names(dataTest), names(dataTrain))

# --- Add a new column named ID to serve and primary key in the merge
dataTest$ID <- 1:2946
dataTestY$ID <- 1:2946
dataTrain$ID <- 2947:10297  # 1:7351
dataTrainY$ID <- 2947:10297 # 1:7351

# --- replace activity codes with descriptive vairable names
dataTrainY$X5[which(dataTrainY$X5=="1")]<-"walking"
dataTrainY$X5[which(dataTrainY$X5=="2")]<-"walkingUpstair"
dataTrainY$X5[which(dataTrainY$X5=="3")]<-"walkingDownstair"
dataTrainY$X5[which(dataTrainY$X5=="4")]<-"sitting"
dataTrainY$X5[which(dataTrainY$X5=="5")]<-"standing"
dataTrainY$X5[which(dataTrainY$X5=="6")]<-"laying"
dataTestY$X5[which(dataTestY$X5=="1")]<-"walking"
dataTestY$X5[which(dataTestY$X5=="2")]<-"walkingUpstair"
dataTestY$X5[which(dataTestY$X5=="3")]<-"walkingDownstair"
dataTestY$X5[which(dataTestY$X5=="4")]<-"sitting"
dataTestY$X5[which(dataTestY$X5=="5")]<-"standing"
dataTestY$X5[which(dataTestY$X5=="6")]<-"laying"

# --- write unzipped data out to cvs files as restart point 1 (if needed)
write.csv(dataTest, file = "dataTest.csv")
write.csv(dataTestY, file = "dataTestY.csv")
write.csv(dataTrain, file = "dataTrain.csv")
write.csv(dataTrainY, file = "dataTrainY.csv")

# --- restart point 1 -- after running above steps, skip previous steps and start here 
# dataTest <- read.csv("./dataTest.csv", header=T, sep=",")
# dataTestY <- read.csv("./dataTestY.csv", header=T, sep=",")
# dataTrain <- read.csv("./dataTrain.csv", header=T, sep=",")
# dataTrainY <- read.csv("./dataTrainY.csv", header=T, sep=",")

# --- merge the files together
dataMergeTest <- merge(dataTestY, dataTest,by=c("ID"))
dataMergeTrain <- merge(dataTrainY, dataTrain,by=c("ID"))
dataCombined <-merge(dataMergeTest, dataMergeTrain, all.x=TRUE, all.y=TRUE) # gives 10297 obs  1115 var
# head(dataCombined, 1)

# --- write the combined data out to a csv file as restart point 2 (if needed)
write.csv(dataCombined, file = "dataCombined.csv")

# --- restart point 2 -- after running above steps, skip previous steps and start here 
# dataCombined <- read.csv("./dataCombined.csv", header=T, sep=",")

# --- extract mean and standard deviation fields for each measurement
extracts <- dataCombined[,c("X5",    # activity
                      # start with fields originally from Test                       
                     "X2.5717778e.001", "X.2.3285230e.002","X.1.4653762e.002",
                     "X.9.3840400e.001","X.9.2009078e.001", "X.6.6768331e.001",
                     "X9.3648925e.001", "X.2.8271916e.001", "X1.1528825e.001",
                     "X.9.2542727e.001", "X.9.3701413e.001", "X.5.6428842e.001",
                     "X7.2046007e.002", "X4.5754401e.002", "X.1.0604266e.001",
                     "X.9.0668276e.001", "X.9.3801639e.001", "X.9.3593583e.001",
                     "X1.1997616e.001", "X.9.1792335e.002", "X1.8962854e.001",
                     "X.8.8308911e.001", "X.8.1616360e.001", "X.9.4088123e.001",
                     "X.2.0489621e.001", "X.1.7448771e.001", "X.9.3389340e.002",
                     "X.9.0122415e.001", "X.9.1086005e.001", "X.9.3925042e.001",
                     "X.8.6692938e.001", "X.7.0519112e.001",      # 201 202
                     "X.8.6692938e.001.2", "X.7.0519112e.001.1",  # 214 215
                     "X.9.2976655e.001", "X.8.9599425e.001",      # 227 228
                     "X.7.9554393e.001", "X.7.6207322e.001",      # 240 241
                     "X.9.2519489e.001", "X.8.9434361e.001",      # 253 254
                     "X.9.1850969e.001", "X.9.1821319e.001", "X.7.8909145e.001",   # 266
                     "X.9.4829035e.001", "X.9.2513687e.001", "X.6.3631674e.001",
                     "X.8.9963316e.001", "X.9.3748500e.001", "X.9.2355140e.001",   # 345
                     "X.9.2442913e.001", "X.9.4321038e.001", "X.9.4789152e.001",
                     "X.8.2355788e.001", "X.8.0791598e.001", "X.9.1791256e.001",   # 424
                     "X.9.0326274e.001", "X.8.2267700e.001", "X.9.5616508e.001", 
                     "X.7.9094643e.001", "X.7.1107400e.001",  # 503  504
                     "X.8.9506118e.001", "X.8.9635958e.001",  # 516  517
                     "X.7.7061000e.001", "X.7.9711285e.001",  # 529  530
                     "X.8.9016545e.001", "X.9.0730756e.001",  # 542  543
                      # start fields originally from Train
                      "X2.8858451e.001", "X.2.0294171e.002", "X.1.3290514e.001",
                      "X.9.9527860e.001", "X.9.8311061e.001", "X.9.1352645e.001",
                      "X9.6339614e.001", "X.1.4083968e.001", "X1.1537494e.001",    # 41 43
                      "X.9.8524969e.001", "X.9.8170843e.001", "X.8.7762497e.001",  # 44 46
                      "X7.7996345e.002", "X5.0008031e.003", "X.6.7830808e.002",    # 81 83
                      "X.9.9351906e.001", "X.9.8835999e.001", "X.9.9357497e.001",  # 84 86
                      "X.6.1008489e.003", "X.3.1364791e.002", "X1.0772540e.001",   # 121 123
                      "X.9.8531027e.001", "X.9.7662344e.001", "X.9.9220528e.001",  # 124 126
                      "X.9.9167400e.002", "X.5.5517369e.002", "X.6.1985797e.002",  # 161 163
                      "X.9.9211067e.001", "X.9.9251927e.001", "X.9.9205528e.001",  # 164 166
                      "X.9.5943388e.001", "X.9.5055150e.001",      # 201 202
                      "X.9.5943388e.001.2", "X.9.5055150e.001.1",  # 214 215
                      "X.9.9330586e.001", "X.9.9433641e.001",      # 227 228
                      "X.9.6895908e.001", "X.9.6433518e.001",      # 240 241
                      "X.9.9424782e.001", "X.9.9136761e.001",      # 253 254
                      "X.9.9478319e.001", "X.9.8298410e.001", "X.9.3926865e.001",  # 266 268
                      "X.9.9542175e.001", "X.9.8313297e.001", "X.9.0616498e.001",  # 269 271
                      "X.9.9233245e.001", "X.9.8716991e.001", "X.9.8969609e.001",  # 345
                      "X.9.9582068e.001", "X.9.9093631e.001", "X.9.9705167e.001",  # 348
                      "X.9.8657442e.001", "X.9.8176153e.001", "X.9.8951478e.001",  # 424
                      "X.9.8503264e.001", "X.9.7388607e.001", "X.9.9403493e.001",  # 427
                      "X.9.5215466e.001", "X.9.5613397e.001",  # 503 504
                      "X.9.9372565e.001", "X.9.9375495e.001",  # 516  517
                      "X.9.8013485e.001", "X.9.6130944e.001",  # 529 530
                      "X.9.9199044e.001", "X.9.9069746e.001"   # 542 543
                    )]                                                      

# --- rename the columns with descriptive names starting with the ones from Test
colnames(extracts)[1] <- "activity"
colnames(extracts)[2] <- "BodyAccTestMeanTimeXAxial"
colnames(extracts)[3] <- "BodyAccTestMeanTimeYAxial"
colnames(extracts)[4] <- "BodyAccTestMeanTimeZAxial"
colnames(extracts)[5] <- "BodyAccTestStdTimeXAxial"
colnames(extracts)[6] <- "BodyAccTestStdTimeYAxial"
colnames(extracts)[7] <- "BodyAccTestStdTimeZAxial"
colnames(extracts)[8] <- "GravityAccTestMeanTimeXAxial"
colnames(extracts)[9] <- "GravityAccTestMeanTimeYAxial"
colnames(extracts)[10] <- "GravityAccTestMeanTimeZAxial"
colnames(extracts)[11] <- "GravityAccTestStdTimeXAxial"
colnames(extracts)[12] <- "GravityAccTestStdTimeYAxial"
colnames(extracts)[13] <- "GravityAccTestStdTimeZAxial"
colnames(extracts)[14] <- "BodyAccJerkTestMeanTimeXAxial"
colnames(extracts)[15] <- "BodyAccJerkTestMeanTimeYAxial"
colnames(extracts)[16] <- "BodyAccJerkTestMeanTimeZAxial"
colnames(extracts)[17] <- "BodyAccJerkTestStdTimeXAxial"
colnames(extracts)[18] <- "BodyAccJerkTestStdTimeYAxial"
colnames(extracts)[19] <- "BodyAccJerkTestStdTimeZAxial"
colnames(extracts)[20] <- "BodyGyroTestMeanTimeXAxial"
colnames(extracts)[21] <- "BodyGyroTestMeanTimeYAxial"
colnames(extracts)[22] <- "BodyGyroTestMeanTimeZAxial"
colnames(extracts)[23] <- "BodyGyroTestStdTimeXAxial"
colnames(extracts)[24] <- "BodyGyroTestStdTimeYAxial"
colnames(extracts)[25] <- "BodyGyroTestStdTimeZAxial"
colnames(extracts)[26] <- "BodyGyroJerkTestMeanTimeXAxial"
colnames(extracts)[27] <- "BodyGyroJerkTestMmeanTimeYAxial"
colnames(extracts)[28] <- "BodyGyroJerkTestMeanTimeZAxial"
colnames(extracts)[29] <- "BodyGyroJerkTestStdTimeXAxial"
colnames(extracts)[30] <- "BodyGyroJerkTestStdTimeYAxial"
colnames(extracts)[31] <- "BodyGyroJerkTestStdTimeZAxial"
colnames(extracts)[32] <- "BodyAccMagTestMeanTime"
colnames(extracts)[33] <- "BodyAccMagTestStdTime"
colnames(extracts)[34] <- "GravityAccMagTestMeanTime"
colnames(extracts)[35] <- "GravityAccMagTestStdTime"
colnames(extracts)[36] <- "BodyAccJerkMagTestMeanTime"
colnames(extracts)[37] <- "BodyAccJerkMagTestStdTime"
colnames(extracts)[38] <- "BodyGyroMagTestMeanTime"
colnames(extracts)[39] <- "BodyGyroMagTestStdTime"
colnames(extracts)[40] <- "BodyGyroJerkMagTestMeanTime"
colnames(extracts)[41] <- "BodyGyroJerkMagTestStdTime"
colnames(extracts)[42] <- "BodyAccTestMeanFrequencyDomainSignalXAxial"
colnames(extracts)[43] <- "BodyAccTestMeanFrequencyDomainSignalYAxial"
colnames(extracts)[44] <- "BodyAccTestMeanFrequencyDomainSignalZAxial"
colnames(extracts)[45] <- "BodyAccTestStdFrequencyDomainSignalXAxial"
colnames(extracts)[46] <- "BodyAccTestStdFrequencyDomainSignalYAxial"
colnames(extracts)[47] <- "BodyAccTestStdFrequencyDomainSignalZAxial"
colnames(extracts)[48] <- "BodyAccJerkTestMeanFrequencyDomainSignalXAxial"
colnames(extracts)[49] <- "BodyAccJerkTestMeanFrequencyDomainSignalYAxial"
colnames(extracts)[50] <- "BodyAccJerkTestMeanFrequencyDomainSignalZAxial"
colnames(extracts)[51] <- "BodyAccJerkTestStdFrequencyDomainSignalXAxial"
colnames(extracts)[52] <- "BodyAccJerkTestStdFrequencyDomainSignalYAxial"
colnames(extracts)[53] <- "BodyAccJerkTestStdFrequencyDomainSignalZAaxial"
colnames(extracts)[54] <- "BodyGyroTestMeanFrequencyDomainSignalXAxial"
colnames(extracts)[55] <- "BodyGyroTestMeanFrequencyDomainSignalYAxial"
colnames(extracts)[56] <- "BodyGyroTestMeanFrequencyDomainSignalZAxial"
colnames(extracts)[57] <- "BodyGyroTestStdFrequencyDomainSignalXAxial"
colnames(extracts)[58] <- "BodyGyroTestStdFrequencyDomainSignalYAxial"
colnames(extracts)[59] <- "BodyGyroTestStdFrequencyDomainSignalZAxial"
colnames(extracts)[60] <- "BodyAccMagTestMeanFrequencyDomainSignal"
colnames(extracts)[61] <- "BodyAccMagTestStdFrequencyDomainSignal"
colnames(extracts)[62] <- "BodyBodyAccJerkMagTestMeanFrequencyDomainSignal"
colnames(extracts)[63] <- "BodyBodyAccJerkMagTestStdFrequencyDomainSignal"
colnames(extracts)[64] <- "BodyBodyGyroMagTestMeanFrequencyDomainSignal"
colnames(extracts)[65] <- "BodyBodyGyroMagTestStdFrequencyDomainSignal"
colnames(extracts)[66] <- "BodyBodyGyroJerkMagTestMeanFrequencyDomainSignal"
colnames(extracts)[67] <- "BodyBodyGyroJerkMagTestStdFrequencyDomainSignal"
# --- rename the Train columns
colnames(extracts)[68] <- "BodyAccTrainMeanTimeXAxial"
colnames(extracts)[69] <- "BodyAccTrainMeanTimeYAxial"
colnames(extracts)[70] <- "BodyAccTrainMeanTimeZAxial"
colnames(extracts)[71] <- "BodyAccTrainStdTimeXAxial"
colnames(extracts)[72] <- "BodyAccTrainStdTimeYAxial"
colnames(extracts)[73] <- "BodyAccTrainStdTimeZAxial"
colnames(extracts)[74] <- "GravityAccTrainMeanTimeXAxial"
colnames(extracts)[75] <- "GravityAccTrainMeanTimeYAxial"
colnames(extracts)[76] <- "GravityAccTrainMeanTimeZAxial"
colnames(extracts)[77] <- "GravityAccTrainStdTimeXAxial"
colnames(extracts)[78] <- "GravityAccTrainStdTimeYAxial"
colnames(extracts)[79] <- "GravityAccTrainStdTimeZAxial"
colnames(extracts)[80] <- "BodyAccJerkTrainMeanTimeXAxial"
colnames(extracts)[81] <- "BodyAccJerkTrainMeanTimeYAxial"
colnames(extracts)[82] <- "BodyAccJerkTrainMeanTimeZAxial"
colnames(extracts)[83] <- "BodyAccJerkTrainStdTimeXAxial"
colnames(extracts)[84] <- "BodyAccJerkTrainStdTimeYAxial"
colnames(extracts)[85] <- "BodyAccJerkTrainStdTimeZAxial"
colnames(extracts)[86] <- "BodyGyroTrainMeanTimeXAxial"
colnames(extracts)[87] <- "BodyGyroTrainMeanTimeYAxial"
colnames(extracts)[88] <- "BodyGyroTrainMeanTimeZAxial"
colnames(extracts)[89] <- "BodyGyroTrainStdTimeXAxial"
colnames(extracts)[90] <- "BodyGyroTrainStdTimeYAxial"
colnames(extracts)[91] <- "BodyGyroTrainStdTimeZAxial"
colnames(extracts)[92] <- "BodyGyroJerkTrainMeanTimeXAxial"
colnames(extracts)[93] <- "BodyGyroJerkTrainMmeanTimeYAxial"
colnames(extracts)[94] <- "BodyGyroJerkTrainMeanTimeZAxial"
colnames(extracts)[95] <- "BodyGyroJerkTrainStdTimeXAxial"
colnames(extracts)[96] <- "BodyGyroJerkTrainStdTimeYAxial"
colnames(extracts)[97] <- "BodyGyroJerkTrainStdTimeZAxial"
colnames(extracts)[98] <- "BodyAccMagTrainMeanTime"
colnames(extracts)[99] <- "BodyAccMagTrainStdTime"
colnames(extracts)[100] <- "GravityAccMagTrainMeanTime"
colnames(extracts)[101] <- "GravityAccMagTrainStdTime"
colnames(extracts)[102] <- "BodyAccJerkMagTrainMeanTime"
colnames(extracts)[103] <- "BodyAccJerkMagTrainStdTime"
colnames(extracts)[104] <- "BodyGyroMagTrainMeanTime"
colnames(extracts)[105] <- "BodyGyroMagTrainStdTime"
colnames(extracts)[106] <- "BodyGyroJerkMagTrainMeanTime"
colnames(extracts)[107] <- "BodyGyroJerkMagTrainStdTime"
colnames(extracts)[108] <- "BodyAccTrainMeanFrequencyDomainSignalXAxial"
colnames(extracts)[109] <- "BodyAccTrainMeanFrequencyDomainSignalYAxial"
colnames(extracts)[110] <- "BodyAccTrainMeanFrequencyDomainSignalZAxial"
colnames(extracts)[111] <- "BodyAccTrainStdFrequencyDomainSignalXAxial"
colnames(extracts)[112] <- "BodyAccTrainStdFrequencyDomainSignalYAxial"
colnames(extracts)[113] <- "BodyAccTrainStdFrequencyDomainSignalZAxial"
colnames(extracts)[114] <- "BodyAccJerkTrainMeanFrequencyDomainSignalXAxial"
colnames(extracts)[115] <- "BodyAccJerkTrainMeanFrequencyDomainSignalYAxial"
colnames(extracts)[116] <- "BodyAccJerkTrainMeanFrequencyDomainSignalZAxial"
colnames(extracts)[117] <- "BodyAccJerkTrainStdFrequencyDomainSignalXAxial"
colnames(extracts)[118] <- "BodyAccJerkTrainStdFrequencyDomainSignalYAxial"
colnames(extracts)[119] <- "BodyAccJerkTrainStdFrequencyDomainSignalZAaxial"
colnames(extracts)[120] <- "BodyGyroTrainMeanFrequencyDomainSignalXAxial"
colnames(extracts)[121] <- "BodyGyroTrainMeanFrequencyDomainSignalYAxial"
colnames(extracts)[122] <- "BodyGyroTrainMeanFrequencyDomainSignalZAxial"
colnames(extracts)[123] <- "BodyGyroTrainStdFrequencyDomainSignalXAxial"
colnames(extracts)[124] <- "BodyGyroTrainStdFrequencyDomainSignalYAxial"
colnames(extracts)[125] <- "BodyGyroTrainStdFrequencyDomainSignalZAxial"
colnames(extracts)[126] <- "BodyAccMagTrainMeanFrequencyDomainSignal"
colnames(extracts)[127] <- "BodyAccMagTrainStdFrequencyDomainSignal"
colnames(extracts)[128] <- "BodyBodyAccJerkMagTrainMeanFrequencyDomainSignal"
colnames(extracts)[129] <- "BodyBodyAccJerkMagTrainStdFrequencyDomainSignal"
colnames(extracts)[130] <- "BodyBodyGyroMagTrainMeanFrequencyDomainSignal"
colnames(extracts)[131] <- "BodyBodyGyroMagTrainStdFrequencyDomainSignal"
colnames(extracts)[132] <- "BodyBodyGyroJerkMagTrainMeanFrequencyDomainSignal"
colnames(extracts)[133] <- "BodyBodyGyroJerkMagTrainStdFrequencyDomainSignal"

# --- check the final results
# dim(extracts)
# names(extracts)
# head(extracts, 3)
# View(extracts)

# --- write the tidy data set to disk
# write.csv(extracts, file = "tidyDataSet.csv")
write.table(extracts, file = "tidyDataSet.txt", row.name=FALSE)

# --- read the file to check it
z <- read.table("./tidyDataSet.txt", header=TRUE)

# Step 5: From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity
# and each subject.

library(dplyr)

FinalStep <- group_by(extracts, activity) %>% summarise(
  BodyAccTestMeanTimeXAxial=mean(BodyAccTestMeanTimeXAxial ,na.rm=TRUE ), 
  BodyAccTestMeanTimeYAxial=mean(BodyAccTestMeanTimeYAxial ,na.rm=TRUE ), 
  BodyAccTestMeanTimeZAxial=mean(BodyAccTestMeanTimeZAxial ,na.rm=TRUE ), 
  BodyAccTestStdTimeXAxial=mean(BodyAccTestStdTimeXAxial ,na.rm=TRUE ), 
  BodyAccTestStdTimeYAxial=mean(BodyAccTestStdTimeYAxial ,na.rm=TRUE ), 
  BodyAccTestStdTimeZAxial=mean(BodyAccTestStdTimeZAxial ,na.rm=TRUE ), 
  GravityAccTestMeanTimeXAxial=mean(GravityAccTestMeanTimeXAxial ,na.rm=TRUE ), 
  GravityAccTestMeanTimeYAxial=mean(GravityAccTestMeanTimeYAxial ,na.rm=TRUE ), 
  GravityAccTestMeanTimeZAxial=mean(GravityAccTestMeanTimeZAxial ,na.rm=TRUE ), 
  GravityAccTestStdTimeXAxial=mean(GravityAccTestStdTimeXAxial ,na.rm=TRUE ), 
  GravityAccTestStdTimeYAxial=mean(GravityAccTestStdTimeYAxial ,na.rm=TRUE ), 
  GravityAccTestStdTimeZAxial=mean(GravityAccTestStdTimeZAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanTimeXAxial=mean(BodyAccJerkTestMeanTimeXAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanTimeYAxial=mean(BodyAccJerkTestMeanTimeYAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanTimeZAxial=mean(BodyAccJerkTestMeanTimeZAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdTimeXAxial=mean(BodyAccJerkTestStdTimeXAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdTimeYAxial=mean(BodyAccJerkTestStdTimeYAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdTimeZAxial=mean(BodyAccJerkTestStdTimeZAxial ,na.rm=TRUE ), 
  BodyGyroTestMeanTimeXAxial=mean(BodyGyroTestMeanTimeXAxial ,na.rm=TRUE ), 
  BodyGyroTestMeanTimeYAxial=mean(BodyGyroTestMeanTimeYAxial ,na.rm=TRUE ), 
  BodyGyroTestMeanTimeZAxial=mean(BodyGyroTestMeanTimeZAxial ,na.rm=TRUE ), 
  BodyGyroTestStdTimeXAxial=mean(BodyGyroTestStdTimeXAxial ,na.rm=TRUE ), 
  BodyGyroTestStdTimeYAxial=mean(BodyGyroTestStdTimeYAxial ,na.rm=TRUE ), 
  BodyGyroTestStdTimeZAxial=mean(BodyGyroTestStdTimeZAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestMeanTimeXAxial=mean(BodyGyroJerkTestMeanTimeXAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestMmeanTimeYAxial=mean(BodyGyroJerkTestMmeanTimeYAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestMeanTimeZAxial=mean(BodyGyroJerkTestMeanTimeZAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestStdTimeXAxial=mean(BodyGyroJerkTestStdTimeXAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestStdTimeYAxial=mean(BodyGyroJerkTestStdTimeYAxial ,na.rm=TRUE ), 
  BodyGyroJerkTestStdTimeZAxial=mean(BodyGyroJerkTestStdTimeZAxial ,na.rm=TRUE ), 
  BodyAccMagTestMeanTime=mean(BodyAccMagTestMeanTime ,na.rm=TRUE ), 
  BodyAccMagTestStdTime=mean(BodyAccMagTestStdTime ,na.rm=TRUE ), 
  GravityAccMagTestMeanTime=mean(GravityAccMagTestMeanTime ,na.rm=TRUE ), 
  GravityAccMagTestStdTime=mean(GravityAccMagTestStdTime ,na.rm=TRUE ), 
  BodyAccJerkMagTestMeanTime=mean(BodyAccJerkMagTestMeanTime ,na.rm=TRUE ), 
  BodyAccJerkMagTestStdTime=mean(BodyAccJerkMagTestStdTime ,na.rm=TRUE ), 
  BodyGyroMagTestMeanTime=mean(BodyGyroMagTestMeanTime ,na.rm=TRUE ), 
  BodyGyroMagTestStdTime=mean(BodyGyroMagTestStdTime ,na.rm=TRUE ), 
  BodyGyroJerkMagTestMeanTime=mean(BodyGyroJerkMagTestMeanTime ,na.rm=TRUE ), 
  BodyGyroJerkMagTestStdTime=mean(BodyGyroJerkMagTestStdTime ,na.rm=TRUE ), 
  BodyAccTestMeanFrequencyDomainSignalXAxial=mean(BodyAccTestMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccTestMeanFrequencyDomainSignalYAxial=mean(BodyAccTestMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccTestMeanFrequencyDomainSignalZAxial=mean(BodyAccTestMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccTestStdFrequencyDomainSignalXAxial=mean(BodyAccTestStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccTestStdFrequencyDomainSignalYAxial=mean(BodyAccTestStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccTestStdFrequencyDomainSignalZAxial=mean(BodyAccTestStdFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanFrequencyDomainSignalXAxial=mean(BodyAccJerkTestMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanFrequencyDomainSignalYAxial=mean(BodyAccJerkTestMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccJerkTestMeanFrequencyDomainSignalZAxial=mean(BodyAccJerkTestMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdFrequencyDomainSignalXAxial=mean(BodyAccJerkTestStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdFrequencyDomainSignalYAxial=mean(BodyAccJerkTestStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccJerkTestStdFrequencyDomainSignalZAaxial=mean(BodyAccJerkTestStdFrequencyDomainSignalZAaxial ,na.rm=TRUE ), 
  BodyGyroTestMeanFrequencyDomainSignalXAxial=mean(BodyGyroTestMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyGyroTestMeanFrequencyDomainSignalYAxial=mean(BodyGyroTestMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyGyroTestMeanFrequencyDomainSignalZAxial=mean(BodyGyroTestMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyGyroTestStdFrequencyDomainSignalXAxial=mean(BodyGyroTestStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyGyroTestStdFrequencyDomainSignalYAxial=mean(BodyGyroTestStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyGyroTestStdFrequencyDomainSignalZAxial=mean(BodyGyroTestStdFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccMagTestMeanFrequencyDomainSignal=mean(BodyAccMagTestMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyAccMagTestStdFrequencyDomainSignal=mean(BodyAccMagTestStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyAccJerkMagTestMeanFrequencyDomainSignal=mean(BodyBodyAccJerkMagTestMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyAccJerkMagTestStdFrequencyDomainSignal=mean(BodyBodyAccJerkMagTestStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroMagTestMeanFrequencyDomainSignal=mean(BodyBodyGyroMagTestMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroMagTestStdFrequencyDomainSignal=mean(BodyBodyGyroMagTestStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroJerkMagTestMeanFrequencyDomainSignal=mean(BodyBodyGyroJerkMagTestMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroJerkMagTestStdFrequencyDomainSignal=mean(BodyBodyGyroJerkMagTestStdFrequencyDomainSignal ,na.rm=TRUE ), 
#
  BodyAccTrainMeanTimeXAxial=mean(BodyAccTrainMeanTimeXAxial ,na.rm=TRUE ), 
  BodyAccTrainMeanTimeYAxial=mean(BodyAccTrainMeanTimeYAxial ,na.rm=TRUE ), 
  BodyAccTrainMeanTimeZAxial=mean(BodyAccTrainMeanTimeZAxial ,na.rm=TRUE ), 
  BodyAccTrainStdTimeXAxial=mean(BodyAccTrainStdTimeXAxial ,na.rm=TRUE ), 
  BodyAccTrainStdTimeYAxial=mean(BodyAccTrainStdTimeYAxial ,na.rm=TRUE ), 
  BodyAccTrainStdTimeZAxial=mean(BodyAccTrainStdTimeZAxial ,na.rm=TRUE ), 
  GravityAccTrainMeanTimeXAxial=mean(GravityAccTrainMeanTimeXAxial ,na.rm=TRUE ), 
  GravityAccTrainMeanTimeYAxial=mean(GravityAccTrainMeanTimeYAxial ,na.rm=TRUE ), 
  GravityAccTrainMeanTimeZAxial=mean(GravityAccTrainMeanTimeZAxial ,na.rm=TRUE ), 
  GravityAccTrainStdTimeXAxial=mean(GravityAccTrainStdTimeXAxial ,na.rm=TRUE ), 
  GravityAccTrainStdTimeYAxial=mean(GravityAccTrainStdTimeYAxial ,na.rm=TRUE ), 
  GravityAccTrainStdTimeZAxial=mean(GravityAccTrainStdTimeZAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanTimeXAxial=mean(BodyAccJerkTrainMeanTimeXAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanTimeYAxial=mean(BodyAccJerkTrainMeanTimeYAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanTimeZAxial=mean(BodyAccJerkTrainMeanTimeZAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdTimeXAxial=mean(BodyAccJerkTrainStdTimeXAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdTimeYAxial=mean(BodyAccJerkTrainStdTimeYAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdTimeZAxial=mean(BodyAccJerkTrainStdTimeZAxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanTimeXAxial=mean(BodyGyroTrainMeanTimeXAxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanTimeYAxial=mean(BodyGyroTrainMeanTimeYAxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanTimeZAxial=mean(BodyGyroTrainMeanTimeZAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdTimeXAxial=mean(BodyGyroTrainStdTimeXAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdTimeYAxial=mean(BodyGyroTrainStdTimeYAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdTimeZAxial=mean(BodyGyroTrainStdTimeZAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainMeanTimeXAxial=mean(BodyGyroJerkTrainMeanTimeXAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainMmeanTimeYAxial=mean(BodyGyroJerkTrainMmeanTimeYAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainMeanTimeZAxial=mean(BodyGyroJerkTrainMeanTimeZAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainStdTimeXAxial=mean(BodyGyroJerkTrainStdTimeXAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainStdTimeYAxial=mean(BodyGyroJerkTrainStdTimeYAxial ,na.rm=TRUE ), 
  BodyGyroJerkTrainStdTimeZAxial=mean(BodyGyroJerkTrainStdTimeZAxial ,na.rm=TRUE ), 
  BodyAccMagTrainMeanTime=mean(BodyAccMagTrainMeanTime ,na.rm=TRUE ), 
  BodyAccMagTrainStdTime=mean(BodyAccMagTrainStdTime ,na.rm=TRUE ), 
  GravityAccMagTrainMeanTime=mean(GravityAccMagTrainMeanTime ,na.rm=TRUE ), 
  GravityAccMagTrainStdTime=mean(GravityAccMagTrainStdTime ,na.rm=TRUE ), 
  BodyAccJerkMagTrainMeanTime=mean(BodyAccJerkMagTrainMeanTime ,na.rm=TRUE ), 
  BodyAccJerkMagTrainStdTime=mean(BodyAccJerkMagTrainStdTime ,na.rm=TRUE ), 
  BodyGyroMagTrainMeanTime=mean(BodyGyroMagTrainMeanTime ,na.rm=TRUE ), 
  BodyGyroMagTrainStdTime=mean(BodyGyroMagTrainStdTime ,na.rm=TRUE ), 
  BodyGyroJerkMagTrainMeanTime=mean(BodyGyroJerkMagTrainMeanTime ,na.rm=TRUE ), 
  BodyGyroJerkMagTrainStdTime=mean(BodyGyroJerkMagTrainStdTime ,na.rm=TRUE ), 
  BodyAccTrainMeanFrequencyDomainSignalXAxial=mean(BodyAccTrainMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccTrainMeanFrequencyDomainSignalYAxial=mean(BodyAccTrainMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccTrainMeanFrequencyDomainSignalZAxial=mean(BodyAccTrainMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccTrainStdFrequencyDomainSignalXAxial=mean(BodyAccTrainStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccTrainStdFrequencyDomainSignalYAxial=mean(BodyAccTrainStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccTrainStdFrequencyDomainSignalZAxial=mean(BodyAccTrainStdFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanFrequencyDomainSignalXAxial=mean(BodyAccJerkTrainMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanFrequencyDomainSignalYAxial=mean(BodyAccJerkTrainMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainMeanFrequencyDomainSignalZAxial=mean(BodyAccJerkTrainMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdFrequencyDomainSignalXAxial=mean(BodyAccJerkTrainStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdFrequencyDomainSignalYAxial=mean(BodyAccJerkTrainStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyAccJerkTrainStdFrequencyDomainSignalZAaxial=mean(BodyAccJerkTrainStdFrequencyDomainSignalZAaxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanFrequencyDomainSignalXAxial=mean(BodyGyroTrainMeanFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanFrequencyDomainSignalYAxial=mean(BodyGyroTrainMeanFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyGyroTrainMeanFrequencyDomainSignalZAxial=mean(BodyGyroTrainMeanFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdFrequencyDomainSignalXAxial=mean(BodyGyroTrainStdFrequencyDomainSignalXAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdFrequencyDomainSignalYAxial=mean(BodyGyroTrainStdFrequencyDomainSignalYAxial ,na.rm=TRUE ), 
  BodyGyroTrainStdFrequencyDomainSignalZAxial=mean(BodyGyroTrainStdFrequencyDomainSignalZAxial ,na.rm=TRUE ), 
  BodyAccMagTrainMeanFrequencyDomainSignal=mean(BodyAccMagTrainMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyAccMagTrainStdFrequencyDomainSignal=mean(BodyAccMagTrainStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyAccJerkMagTrainMeanFrequencyDomainSignal=mean(BodyBodyAccJerkMagTrainMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyAccJerkMagTrainStdFrequencyDomainSignal=mean(BodyBodyAccJerkMagTrainStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroMagTrainMeanFrequencyDomainSignal=mean(BodyBodyGyroMagTrainMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroMagTrainStdFrequencyDomainSignal=mean(BodyBodyGyroMagTrainStdFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroJerkMagTrainMeanFrequencyDomainSignal=mean(BodyBodyGyroJerkMagTrainMeanFrequencyDomainSignal ,na.rm=TRUE ), 
  BodyBodyGyroJerkMagTrainStdFrequencyDomainSignal=mean(BodyBodyGyroJerkMagTrainStdFrequencyDomainSignal ,na.rm=TRUE ) ) 

# --- write the final file to disk
write.table(FinalStep, file = "FinalTidyDataSet.txt", row.name=FALSE)

# --- read the file to check it
ftds <- read.table("./FinalTidyDataSet.txt", header=TRUE)

# --- end of script - 04-22-2015 ---