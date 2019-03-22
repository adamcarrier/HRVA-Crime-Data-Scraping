## Dependencies
install.packages(c("rvest","dplyr"))

runDataCollection <- function(workingDirectory,dataSetDirectory="./data/") {
    require("rvest")
    require("dplyr")
    
    # set working directory so I know where the .zip file will be located
    setwd(workingDirectory)
    
    # create data set directory if it doesn't exist
    dir.create(dataSetDirectory, showWarnings = FALSE)
    
    # download a .zip file of the repository
    # from the "Clone or download - Download ZIP" button
    # on the GitHub repository of interest
    download.file(url = "https://github.com/Code4HR/HRVA-Crime-Data/archive/master.zip"
                  , destfile = "crime-data.zip")
    
    # unzip the .zip file
    unzip(zipfile = "crime-data.zip", exdir = dataSetDirectory)
    
    # set the working directory
    # to be inside the newly unzipped 
    # GitHub repository of interest
    setwd(paste0(dataSetDirectory,"HRVA-Crime-Data-master/data/newportnews/"))
    
    # Get a list of data files from the directory
    webpages <- list.files()
    
    # combined data frame
    crime_data <- data.frame(stringsAsFactors = FALSE)
    
    # for each file in the directory...
    for (i in webpages) {
        # read the file into a var
        webpage <- read_html(i)
    
        # extract the tables
        tbls <- html_nodes(webpage, "table")
    
        # read the table data into an array of data frames
        tbls_ls <- webpage %>%
            html_nodes("table") %>%
            .[1:3] %>%
            html_table(fill = TRUE)
        
        # for each table... (for now, we're assuming there's only three)
            # append it into a new combined data frame
            tables <- rbind(tbls_ls[[1]],tbls_ls[[2]],tbls_ls[[3]])
            
            # convert DATE column to Date type for later sorting
            tables$DATE <- as.Date(tables$DATE, tryFormats = c("%m/%d/%Y"))
            
            # arrange and sort by DATE column
            tables <- tables %>%
                arrange(DATE) %>%
                select(DATE, everything())
            
            # convert date column back to characters
            tables$DATE <- as.character(tables$DATE)
            
            # add data frame to the entire data set
            crime_data <- rbind(crime_data,tables,stringsAsFactors=FALSE)
    }
    
    # arrange and sort by DATE column
    crime_data <- crime_data %>%
        arrange(DATE)
}

saveDataCollection <- function(workingDirectory,report_name="crime-data.csv",dataSetDirectory="./data/") {
    # set working directory so I know where the .zip file will be located
    setwd(workingDirectory)
    
    # create data set directory if it doesn't exist
    dir.create(dataSetDirectory, showWarnings = FALSE)
    
    data_set <- runDataCollection(workingDirectory)
    write.csv(data_set,file=paste0(dataSetDirectory,report_name),row.names=FALSE)
}