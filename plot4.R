library(ggplot2)
#Read the rds data for PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
#Read the rds data for Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")
#Filter out all Coal related source names from SCC Table
coalSources <- SCC[grep("^Coal ", SCC$Short.Name, ignore.case=F),"SCC"]
#Now filter out all related emission sources for all the above Coal Sources
aggData <- ddply(NEI[NEI$SCC %in% coalSources,], c("year"), 
                      function(df)sum(df$Emissions, na.rm=TRUE))
#Change column names for this aggregated data to something meaningful
names(aggData) <- c('Year', 'Emissions')
#Open graphics device
png(filename="figure/plot4.png", width=480, height=480)
#Plot final data to plot which of the 4 sources have seen decreased emissions
ggplot(aggData, aes(x=Year,y=Emissions))+
        geom_line()+
        xlab('Year')+
        ylab('Total PM2.5 Emissions (tons)')+
        ggtitle('Total Emissions Trend from Coal Combustion-related sources')
#shutdown device
dev.off()