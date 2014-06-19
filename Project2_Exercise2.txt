## Check if the Project's .zip file exists in the Working Directory
## If not, then download from the Project's url
## Assuming the filename is the same provided in class: "exdata_data_NEI_data.zip"
if(!file.exists("exdata_data_NEI_data.zip") | !file.exists("exdata_data_NEI_data")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  dwnld <- download.file(fileurl, destfile = "exdata_data_NEI_data.zip", method = "curl", mode = "w") 
}

## If the .zip file exists, then check if unzipped directory also exists
## as in the original .zip file: "exdata_data_NEI_data"
## If not, then unzip the files in that directory
if(!file.exists("exdata_data_NEI_data")) {
  unzip("exdata_data_NEI_data.zip", exdir = "./exdata_data_NEI_data", unzip = "internal")
}

## Check if the Project's required files exist in the subdirectory "exdata_data_NEI_data" on WD
## Required files are: "Source_Classification_Code.rds" and "summarySCC_PM25.rds"
## If not, issue an error message
if(!file.exists("./exdata_data_NEI_data/Source_Classification_Code.rds") & 
     !file.exists("./exdata_data_NEI_data/summarySCC_PM25.rds")) {
  stop(paste("Required files are not available, check the download and unzip"))
}

## Load files
NEI <- readRDS("./exdata_data_NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata_data_NEI_data/Source_Classification_Code.rds")

## Subset NEI dataframe by year and by FIPS (Baltimore City = 24510)
NEI1999 <- NEI[(NEI$year == 1999 & NEI$fips == "24510"), ]
NEI2002 <- NEI[(NEI$year == 2002 & NEI$fips == "24510"), ]
NEI2005 <- NEI[(NEI$year == 2005 & NEI$fips == "24510"), ]
NEI2008 <- NEI[(NEI$year == 2008 & NEI$fips == "24510"), ]

## Sum PM2.5 from all sources for each year
## Matrix 'all_pm' has one row (sum of all emissions) and 10 columns (years from 1999 to 2008)
all_pm <- matrix(nrow = 1, ncol = 10)
colnames(all_pm) <- c(1999:2008)
rownames(all_pm) <- "sum_pm25"
all_pm[1,1] <- sum(NEI1999$Emissions, na.rm = T)
all_pm[1,4] <- sum(NEI2002$Emissions, na.rm = T)
all_pm[1,7] <- sum(NEI2005$Emissions, na.rm = T)
all_pm[1,10] <- sum(NEI2008$Emissions, na.rm = T)

## Plotting data on screen
plot(c(1999:2008), all_pm, xlab = "Year", ylab = "Total PM2.5")

## Openning .png file to save the plot in working directory, file 'plot1.png' at 480 x 480 pixel resolution
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(c(1999:2008), all_pm, xlab = "Year", ylab = "Total PM2.5")
dev.off()

