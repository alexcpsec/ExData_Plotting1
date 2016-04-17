## Coursera - Exploratory Data Analysis - Plotting Assignment 2
##
## plot4.R - generates plot4.png

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

## Finding the SCC entries that have to do with Coal and Comb (combustion)
SCC.coal.index = grep("Coal", SCC$Short.Name, ignore.case=T, value=F)
SCC.comb.index = grep("Comb", SCC$Short.Name, ignore.case=T, value=F)
SCC.index = intersect(SCC.coal.index, SCC.comb.index)

## Filtering the NEI dataset by coal combustion
SCC.filtered = as.character(SCC[SCC.index, SCC])
NEI.filtered = NEI[SCC %chin% SCC.filtered]

# Aggregating year by year data
agg.year = NEI.filtered[, sum(Emissions, na.rm=T), by="year"]

png(filename="plot4.png", width=480, height=480)
plot(agg.year$year, agg.year$V1, type="l", col="blue", lwd=2,
     xaxp  = c(1999, 2008, 3),
     main="Total PM2.5 Emission from Coal Combustion per Year",
     xlab="Year", ylab="Total PM2.5 Emissions")
grid()
dev.off()
