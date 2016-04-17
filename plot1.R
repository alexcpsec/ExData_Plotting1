## Coursera - Exploratory Data Analysis - Plotting Assignment 2
##
## plot1.R - generates plot1.png

# Using data.table to make summaries easier
library(data.table)

## First of all, we make sure we have the downloaded data available, we will
## put it in a file in the local working directory
filename = "exdata_plotting2.zip"
if (!file.exists(filename)) {
  retval = download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                         destfile = filename,
                         method = "curl")
}

## Unzipping the files to the working dir.
unzip(filename, exdir=getwd())

## Reading the emissions data from the contents of the zipped file
NEI = data.table(readRDS("summarySCC_PM25.rds"))
SCC = data.table(readRDS("Source_Classification_Code.rds"))

# Aggregating year by year data
agg.year = NEI[, sum(Emissions, na.rm=T), by="year"]

png(filename="plot1.png", width=480, height=480)
plot(agg.year$year, agg.year$V1, type="l", col="blue", lwd=2,
     xaxp  = c(1999, 2008, 3),
     main="Total PM2.5 Emission from all sources over the years",
     xlab="Year", ylab="Total PM2.5 Emissions")
grid()
dev.off()
