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

## Matrix 'all_pm'has 3 columns, 'year': Year of observation, 'pm2.5': sum of PM2.5 for the subset and
## 'type': observation type
all_pm <- matrix(nrow = 16, ncol = 3)
colnames(all_pm) <- c("year","pm2.5", "type")
all_pm[1:4, 1] <- 1999
all_pm[5:8, 1] <- 2002
all_pm[9:12, 1] <- 2005
all_pm[13:16, 1] <- 2008
all_pm[1:16, 3] <- rep(c("POINT", "NONPOINT", "ONROAD", "NONROAD"), 4)
all_pm[1,2] <- sum((NEI1999$Emissions & NEI1999$type == "POINT"), na.rm = T)
all_pm[2,2] <- sum((NEI1999$Emissions & NEI1999$type == "NONPOINT"), na.rm = T)
all_pm[3,2] <- sum((NEI1999$Emissions & NEI1999$type == "ONROAD"), na.rm = T)
all_pm[4,2] <- sum((NEI1999$Emissions & NEI1999$type == "NONROAD"), na.rm = T)
all_pm[5,2] <- sum((NEI2002$Emissions & NEI2002$type == "POINT"), na.rm = T)
all_pm[6,2] <- sum((NEI2002$Emissions & NEI2002$type == "NONPOINT"), na.rm = T)
all_pm[7,2] <- sum((NEI2002$Emissions & NEI2002$type == "ONROAD"), na.rm = T)
all_pm[8,2] <- sum((NEI2002$Emissions & NEI2002$type == "NONROAD"), na.rm = T)
all_pm[9,2] <- sum((NEI2005$Emissions & NEI2005$type == "POINT"), na.rm = T)
all_pm[10,2] <- sum((NEI2005$Emissions & NEI2005$type == "NONPOINT"), na.rm = T)
all_pm[11,2] <- sum((NEI2005$Emissions & NEI2005$type == "ONROAD"), na.rm = T)
all_pm[12,2] <- sum((NEI2005$Emissions & NEI2005$type == "NONROAD"), na.rm = T)
all_pm[13,2] <- sum((NEI2008$Emissions & NEI2008$type == "POINT"), na.rm = T)
all_pm[14,2] <- sum((NEI2008$Emissions & NEI2008$type == "POINT"), na.rm = T)
all_pm[15,2] <- sum((NEI2008$Emissions & NEI2008$type == "POINT"), na.rm = T)
all_pm[16,2] <- sum((NEI2008$Emissions & NEI2008$type == "POINT"), na.rm = T)

## Convert 'all_pm' to dataframe
all_pm <- as.data.frame(all_pm)

## Plotting data on screen
qplot(year, pm2.5, data = all_pm, facets = .~type) + geom_line(aes(group = 1))

## Openning .png file to save the plot in working directory, file 'plot3.png' at 640 x 480 pixel resolution
png(filename = "plot3.png", width = 640, height = 480, units = "px")
qplot(year, pm2.5, data = all_pm, facets = .~type) + geom_line(aes(group = 1))
dev.off()

