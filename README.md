# TidyDataSet
This is a project for the Getting and Cleaning Data course.  The course was offered in April, 2015.

The assignment is to extract and summarize the mean and standard deviation data from the "Human Activity Recognition Using
 Smartphones Dataset".  The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The original source data and documentation can be found at:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

For this project, the mean and standard deviation data for each observation was extracted to produce a tidy data set.   This tidy dataset was then analysed to produce a second dataset of the average (mean) for each variable for each activity and each subject.

------------------------------------------
The following files are included: 
------------------------------------------
-- README.md  --        Describes how the R script works

-- run_analysis.R --    The R script that runs the analysis

-- CodeBook.md  --      The code book that describes the variables

------------------------------------------------
How to run the run_analysis.R script
------------------------------------------------
All steps necessary to perform the analyis are coded in my R script named "run_analysis.R".   
There are no additional manual steps required.

----------------------
Run Instructions:
----------------------
1.  Download the "run_analysis.R" script from Github to your computer.
2.  Open R Studio and open the "run.analysys.R" file that you downloaded. 
3.  Run the script.

The results and all project files will be found in the working directory "C:/WD".

The final results are in the file named "FinalTidyDataSet.txt".  This is best viewed in R Studio.

-------------------------------------------------------------------------------
My script includes following automated steps (in this order):
-------------------------------------------------------------------------------
 --- set the working directory
 
 --- get the working directory to verify it is set correctly
 
 --- create original_Downloaded_Data directory to keep original data
 
 --- Set the data source URL name
 
 --- downloads the data files
 
 --- unzip the files ---
 
 --- reads the files into R
 
 --- Add a new column named ID to serve and primary key in the merge
 
 --- replace activity codes with descriptive vairable names
 
 --- write unzipped data out to cvs files as restart point 1 (if needed)
 
 --- restart point 1 
 
 --- merge the files together
 
 --- write the combined data out to a csv file as restart point 2
 
 --- restart point 2 
 
 --- extract mean and standard deviation fields for each measurement
 
 --- rename the columns with descriptive names starting with the ones from Test
 
 --- check the final results
 
 --- write the tidy data set to disk
 
 --- read the file to check it
 
 --- Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 
 --- write the final file to disk
 
 --- read the file to check it
 
 --- end of script - 04-21-2015 ---

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
 
