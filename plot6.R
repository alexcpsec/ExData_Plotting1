## Coursera - Exploratory Data Analysis - Plotting Assignment 2
##
## plot6.R - generates plot6.png

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

## Filtering for Baltimore City and Los Angeles County
NEI.balt.la = NEI[(fips == "24510" | fips == "06037")]

## Finding the SCC entries that have to do with Vehicles
SCC.index = grep("Vehicles", SCC$SCC.Level.Two, ignore.case=T, value=F)

## Filtering the NEI dataset by coal combustion
SCC.filtered = as.character(SCC[SCC.index, SCC])
NEI.filtered = NEI.balt.la[SCC %chin% SCC.filtered]

# Aggregating by year and location data
agg.year = NEI.filtered[, sum(Emissions, na.rm=T), by=c("fips", "year")]

# Replacing the location IDs for something more readable
agg.year[fips == "24510", fips := "Baltimore City"]
agg.year[fips == "06037", fips := "Los Angeles County"]

NEI.plot = qplot(year, V1, data=agg.year, facets=fips~., col=I("blue"), geom=c("line"),
                 main="Total PM2.5 Emissions by Motor Vehicles by City",
                 xlab="Year", ylab="Total PM2.5 Emissions")
ggsave(filename="plot6.png", plot=NEI.plot)
