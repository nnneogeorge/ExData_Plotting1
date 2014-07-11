#data_input
# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (in kilowatt)
# Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
# Voltage: minute-averaged voltage (in volt)
# Global_intensity: household global minute-averaged current intensity (in ampere)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
# It corresponds to the kitchen, containing mainly a dishwasher, an oven and a 
# microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
# It corresponds to the laundry room, containing a washing-machine, a tumble-drier, 
# a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
# It corresponds to an electric water-heater and an air-conditioner.

#while parsing the data, NAs should be considered.
dataImport1 <- read.csv("/home/george/Downloads/household_power_consumption.txt",sep = ";", na.strings="?", 
                        colClasses = c("character", "character","numeric","numeric","numeric","numeric","numeric","numeric")) 

dataImport<-dataImport1
#That works for the date , but not for time. 
dataImport$Date<-as.Date(dataImport$Date, format = '%d/%m/%Y')
#The strptime would automatically take the current time, so I created this work wround. 
#practically making one column out Date_Time , out of the two separate ones.
x<-paste(dataImport$Date, dataImport$Time)
dataImport$Time <- as.POSIXct(x, format=" %Y-%m-%d %H:%M:%S", tz="UTC")
#correct the name since now its not only "Time"
colnames(dataImport)[[2]] <- "Date_Time"

#and then drop the dublicated information

#dataImport$Date <- NULL
#checking if everything is fine
str(dataImport)
#keep data from the dates 2007-02-01 and 2007-02-02
day1<- as.Date("2007-02-01 ")
day2<- as.Date("2007-02-02 ")
dataImport.sub <- with(dataImport, subset(dataImport, ((dataImport$Date >= day1 ) &
                                                         (dataImport$Date <= day2))))

#=============================================================================
#plot3
plot(dataImport.sub$Date_Time, dataImport.sub$Sub_metering_1, type='n', xlab = "", ylab = "Energy sub metering")
lines(dataImport.sub$Date_Time, dataImport.sub$Sub_metering_1)
lines(dataImport.sub$Date_Time, dataImport.sub$Sub_metering_2, col = "red")
lines(dataImport.sub$Date_Time, dataImport.sub$Sub_metering_3, col = "blue")
legend("topright", lwd=0.5,  col = c("black","red", "blue"), 
       legend = c("Sub_Metering_1","Sub_Metering_2", "Sub_Metering_3"), bty="n", ,inset =c(0.051,0))
dev.copy(png, file = "plot3.png",width=480,height=480)
dev.off()
