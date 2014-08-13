plot2 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot2.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to
  
  # because screw data frames, those are for kids
  library(data.table)
  
  # load in both sets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # filter for the BC fips id, sum up those emissions index by year
  # produce the plot and write out the png file
  p2data <- nei[fips == "24510", list(total_emissions = sum(Emissions)), by = year]
  plot2 <- plot(x= p2data[, year], y = p2data[, total_emissions], type="l", ylab = "Total Emissions (tons)", xlab = "Year", main = "Total PM2.5 Emissions in Baltimore City, MD")
  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot2