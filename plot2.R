library(plyr)
#Read the rds data for PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
#Read the rds data for Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")
#We are doing aggregate w/ filter with ddply(plyr). Baltimore is fips code 24510
aggDataPerYear <- ddply(NEI[NEI$fips == "24510",], c("year"), 
                      function(df)sum(df$Emissions, na.rm=TRUE))
#Open graphics device
png(filename="figure/plot2.png", width=480, height=480)
#Plot the final aggregate data for Baltimore city from 1999-2008 to see if emission decreased
plot(aggDataPerYear$year, totalPerYear$V1, type="l", xlab="Year", 
     ylab="PM2.5 (tons)", main="PM2.5 Generated between years 1999-2008 in Baltimore City, MD")
#shutdown graphic device
dev.off()