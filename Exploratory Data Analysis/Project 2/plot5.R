plot5 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot5.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to
  
  # because screw data frames, those are for kids
  library(data.table)
  
  # load in both datasets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # let's look for things that might be motor vehicle related and save them for later
  levelone <- c("Internal Combustion Engines", "Mobile Sources")
  leveltwo <- scc[SCC.Level.Two %like% "Motor|Vehicle|Engine", unique(SCC.Level.Two)]
  levelthree <- scc[SCC.Level.Three %like% "Vehicle|Motor", unique(SCC.Level.Three)]
  levelfour  <- scc[SCC.Level.Four %like% "Vehicle|Motor", unique(SCC.Level.Four)]

  # not as big as a merge this time since we can subset to only BC data
  # bring back motor vehicle items and filter for only those sources, sum up the emissions and slice it up by year
  bc <- merge(scc, nei[fips == "24510"], by = "SCC")
  p5data <- bc[SCC.Level.One %in% levelone | SCC.Level.Two %in% leveltwo | SCC.Level.Three %in% levelthree | SCC.Level.Four %in% levelfour, 
               list(total_emissions = sum(Emissions)), keyby = year]
  # make the plot and write it out
  plot5 <- plot(x= p5data[, year], y = p5data[, total_emissions], type="l", ylab = "Total Emissions (tons)", xlab = "Year", main = "Motor Vehicle PM2.5 Emissions in Baltimore City")

  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot5