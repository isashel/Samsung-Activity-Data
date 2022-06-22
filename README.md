# Samsung-Activity-Data
Tidying process for data collected from the accelerometers from the Samsung Galaxy S II smartphone

## Analysis file run_analysis.R does the following:
1. Downloads and unzips the data 
2. Matches the training and test datasets with the respective subject and activity
3. Combines test and training datasets to form a complete dataset 
4. Renames the activity variable with informative test names 
5. Creates a new dataframe containg only variables describing a mean or standard deviation
6. From the dataframe in 5, creates a new dataframe containing the average of each variable for each subject and activity
