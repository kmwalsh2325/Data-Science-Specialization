plot4 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot4.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to
  
  # because screw data frames, those are for kids
  library(data.table)
  
  # load in both datasets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # we only care about coal emissions so look for things with "coal" in the SCC levels
  levelone <- scc[SCC.Level.One %like% "[cC]oal", unique(SCC.Level.One)]
  leveltwo <- scc[SCC.Level.Two %like% "[cC]oal", unique(SCC.Level.Two)]
  levelthree <- scc[SCC.Level.Three %like% "[cC]oal", unique(SCC.Level.Three)]
  levelfour <- scc[SCC.Level.Four %like% "[cC]oal", unique(SCC.Level.Four)]

  # unfortunately this is a big merge, buckle in
  coal <- merge(scc, nei, by = "SCC")
  
  # filter for the things that match for "coal", sum up the emissions, index up by year
  # make the plot and write it out
  p4data <- coal[SCC.Level.One %in% levelone | SCC.Level.Two %in% leveltwo |
                   SCC.Level.Three %in% levelthree | SCC.Level.Four %in% levelfour, list(total_emissions = sum(Emissions)), by = year]
  plot4 <- plot(x= p4data[, year], y = p4data[, total_emissions], type="l", ylab = "Total Emissions (tons)", xlab = "Year", main = "Coal PM2.5 Emissions in the US")
  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot4