#HRVA-Crime-Data Scraping#

Some R functions for scraping and compiling Hampton Roads crime data from the [HRVA-Crime-Data repo](https://github.com/Code4HR/HRVA-Crime-Data). Currently, only Newport News crime data is available.

The `runDataCollection` function returns a data frame containing all the crime data pulled from the repo, sorted by date. You can then repurpose this data frame however you want.

The `saveDataCollection` function is a utility for collecting the crime data and saving it to a `.CSV` file for use as a complete data set.