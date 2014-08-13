plot1 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot1.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to 
  
  # because screw data frames, those are for kids
  library(data.table)
  
  # load in both sets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # sum up all emissions and slice by year
  # produce a base plot with Total Emissions v Year
  # write the png file
  p1data <- nei[, list(total_emissions = sum(Emissions)), by = year]
  plot1 <- plot(x= p1data[, year], y = p1data[, total_emissions], type="l", ylab = "Total Emissions (tons)", xlab = "Year", main = "Total US PM2.5 Emissions")
  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot1