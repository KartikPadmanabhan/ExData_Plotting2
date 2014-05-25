library(plyr)
library(ggplot2)
#Read the rds data for PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
#Read the rds data for Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")
#Total Emission for Baltimore (fips=24510) indicated by its sources between 1999-2008
totData <- ddply(NEI[NEI$fips == "24510",], c("year", "type"), 
                      function(df)sum(df$Emissions, na.rm=TRUE))
#Open graphics device
png(filename="figure/plot3.png", width=480, height=480)
#Plot final data to see which of the 4 sources have seen decreased emissions
ggplot(data=totData, aes(x=year, y=V1, group=type, colour=type)) +
        geom_line() +
        xlab("Year") +
        ylab("PM2.5 (tons)") +
        ggtitle("Total PM2.5 Emissions (tons) Per Year by Source Type")
#shutdown device
dev.off()

