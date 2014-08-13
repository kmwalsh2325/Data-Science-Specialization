plot3 <- function(neifilepath = "~/Exploratory Data Analysis//Project 2//exdata-data-NEI_data/summarySCC_PM25.rds",
                  sccfilepath = "~/Exploratory Data Analysis/Project 2/exdata-data-NEI_data/Source_Classification_Code.rds",
                  outputfile  = "~/Exploratory Data Analysis/Project 2/plot3.png") {
  # neifilepath: a file path to point to the nei dataset
  # sccfilepath: a file path to point to the scc code table
  # outputfile: a file path to write the png file to
  
  # because screw data frames, those are for kids; don't forget ggplot2 for this one
  library(data.table)
  library(ggplot2)
  
  # load in both data sets
  nei <- as.data.table(readRDS(neifilepath))
  scc <- as.data.table(readRDS(sccfilepath))
  
  # we only care about BC, so filter for the BC fips id, sum up emissions, index by year and type
  # make the plot and write it out
  p3data <- nei[fips == "24510", list(total_emissions = sum(Emissions)), by = c("year", "type")]
  plot3 <- qplot(year, total_emissions, color = type, data = p3data, geom = "line", xlab = "Year", ylab = "Total Emissions (tons)", main = "Total PM2.5 Emissions by Type in Baltimore City")

  dev.copy(png, file = outputfile)
  dev.off()
  
} # end plot3