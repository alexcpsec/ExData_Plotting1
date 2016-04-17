## Coursera - Exploratory Data Analysis - Plotting Assignment 2
##
## plot3.R - generates plot3.png

# Using data.table to make summaries easier
library(data.table)
library(ggplot2)

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

NEI.balt = NEI[fips == "24510"]
# Aggregating first by type and then by year
agg.NEI = NEI.balt[, sum(Emissions, na.rm=T), by=c("type", "year")]

NEI.plot = qplot(year, V1, data=agg.NEI, facets=type~., col=I("blue"), geom=c("line"),
                 main="Total PM2.5 Emissions on Baltimore City by type",
                 xlab="Year", ylab="Total PM2.5 Emissions")
ggsave(filename="plot3.png", plot=NEI.plot)
