################################################
## Download, unzip and read data into memory into a data table called house_power.

  if(!file.exists("./powerconsumption.zip")){
    download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                  "powerconsumption.zip")}
  file_name <- "household_power_consumption.txt"
  if(!file.exists(file_name)){
    unzip("powerconsumption.zip")}
  
  house_power <- read.table(file_name, 
                            sep=";", na.strings = "?", skip=1,
                            stringsAsFactors = FALSE, col.names = 
                              # colnames(read.table(file_name,sep=";", 
                              #     nrow = 1, header = TRUE))
  )
  
  colnames(house_power) <- c("Date", "Time", "Global_active_power",
                             "Global_reactive_power", "Voltage",
                             "Global_intensity", "Sub_metering_1",
                             "Sub_metering_2", "Sub_metering_3")

library(dplyr)


################################################
# Select only data for Feb. 1 and Feb 2, 2007
##################################################
first_date <- "1/2/2007" ; second_date <- "2/2/2007"
house_power <- house_power %>%
  filter(Date == first_date | Date == second_date)
rm(first_date, second_date)
house_power <- house_power %>%
  mutate(DateTime = dmy_hms(paste(Date,Time, sep =", ")))

##################################################
# Create plots
##################################################

plot1 <- function(data) {
  with(data, plot(DateTime, 
              Global_active_power, type="l", 
              ylab = "Global Active Power (kilowats)", 
              xlab = ""))
}

plot2 <- function(data){
  with(data, plot(DateTime, Sub_metering_1, type = "l", 
                   col= "black", xlab = "", 
                   ylab = "Entergy sub metering"))
  with(data, lines(DateTime, Sub_metering_2, type = "l", 
                    col = "red"))
  with(data, lines(DateTime, Sub_metering_3, type = "l", 
                    col = "blue"))
  legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", 
                              "Sub_metering_3"), col = c("black", 
                              "red", "blue"))
}

plot3 <- function(data){
  with(data, plot(DateTime, Voltage, type="l"))
}

plot4 <- function(data){
  with(data, plot(DateTime, Global_reactive_power, 
                         type="l"))
}

png(filename = "plot4.png")
par(mfcol=c(2,2))
plot1(house_power)
plot2(house_power)
plot3(house_power)
plot4(house_power)
dev.off()