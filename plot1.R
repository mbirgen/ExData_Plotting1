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

Data1 <- house_power %>%
  select(Global_active_power, DateTime, Date)
##################################################
# Creating Plot 1 - histogram of Global Active Power
##################################################
Data1 <- house_power %>%
  select(Global_active_power, Date, Time) 
png(filename = "plot1.png")
hist(Data1$Global_active_power, col="red", 
     main = paste("Global Active Power"), 
     xlab = "Global Active Power (kilowats)", 
     ylab = "Frequency")
dev.off()