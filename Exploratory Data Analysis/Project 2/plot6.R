plot6 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot6.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to
  
  # because screw data frames, those are for kids; don't forget ggplot2
  library(data.table)
  library(ggplot2)
  
  # load in both datasets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # let's look for things that might be motor vehicle related and save them for later
  levelone <- c("Internal Combustion Engines", "Mobile Sources")
  leveltwo <- scc[SCC.Level.Two %like% "Motor|Vehicle|Engine", unique(SCC.Level.Two)]
  levelthree <- scc[SCC.Level.Three %like% "Vehicle|Motor", unique(SCC.Level.Three)]
  levelfour  <- scc[SCC.Level.Four %like% "Vehicle|Motor", unique(SCC.Level.Four)]
  
  # still not a huge merge as we get a subset of data for only BC and LA counties
  # filter for motor vehicle sources that we found earlier, sum up emissions, slice by year and fips id
  bcla <- merge(scc, nei[fips %in% c("24510", "06037")], by = "SCC")
  p6data <- bcla[SCC.Level.One %in% levelone | SCC.Level.Two %in% leveltwo | SCC.Level.Three %in% levelthree | SCC.Level.Four %in% levelfour, 
                 list(total_emissions = sum(Emissions)), keyby = c("year", "fips")]
  # let's get human readable and translate those fips ids to English county labels
  # make the plot and write it out
  p6data[, county := factor(fips, labels = c("Los Angeles", "Baltimore"))]
  plot6 <- qplot(year, total_emissions, color = county, data = p6data, geom = "line", xlab = "Year", ylab = "Total Emissions (tons)", main = "Motor Vehicle PM2.5 Emissions in Baltimore and LA")

  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot6