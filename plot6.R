library(ggplot2)
#Read the rds data for PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
#Read the rds data for Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

#Subsetting on baltimore city (fips=24510) and LA (fips=06037) with "on-road" Type
NEIonRoad <- NEI[(NEI$fips %in% c("24510","06037")) & (NEI$type=="ON-ROAD"), ]

#Filter out from all emissions on above criteria and calculate aggregate
aggData <- aggregate(NEIonRoad$Emissions, list(Year=NEIonRoad$year, 
           Location=as.factor(NEIonRoad$fips)), sum)

# To calculate which city has has seen greater changes over time in motor vehicle emissions
# I am using a geometric-mean trick (taking differences of logs and then exponentiating) 
totData <- ddply(aggData,"Location",transform, Growth=c(0,(exp(diff(log(x)))-1)*100))
#Substitute the fips code back to respective cities to make sense in graph
totData<-as.data.frame(sapply(totData,gsub,pattern="06037",replacement="Los Angeles"))
totData<-as.data.frame(sapply(totData,gsub,pattern="24510",replacement="Baltimore"))


#Open graphics device
png(filename="figure/plot6.png", width=480, height=480)
# Plotting The growth on 2 cities with ggplot
ggplot(totData, aes(Year, Growth, fill = Location)) + 
        geom_bar(position = "dodge", stat="identity") + 
        labs(y="Variation (in %)") + 
        ggtitle(expression(atop(" variation of emission of PM2.5", 
                                atop(italic("from motor vehicle sources"), ""))))
#shutting down the device
dev.off()