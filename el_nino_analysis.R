library(ggplot2)
library(maps)
#Read compressed data
el_nino <- read.table(
  gzfile("tao-all2.dat.gz"),
  header = FALSE,
  sep = "",
  stringsAsFactors = FALSE
)

#Read column names from the col. file
col_names <- trimws(readLines("tao-all2.col"))
col_names <- col_names[col_names != ""]

#Create unique column name
names(el_nino) <- make.names(col_names, unique = TRUE)

dim(el_nino)
head(el_nino)
str(el_nino)

#Clean missing values and replace "." with NA
el_nino[el_nino == "."] <- NA

#Convert measurements values to numeric
cols_to_numeric <- c("zon.winds", "mer.winds", "humidity", "air.temp.", "s.s.temp.")
el_nino[cols_to_numeric] <- lapply(el_nino[cols_to_numeric], as.numeric)

#Create a Date column
el_nino$date <- as.Date(paste(1900 + el_nino$year, el_nino$month, el_nino$day, sep = "-"))
str(el_nino$date)

#Find the buoy locations using a map plot
#convert buoy longitude to 0-360
el_nino$lon360 <- ifelse(el_nino$longitude < 0, el_nino$longitude + 360, el_nino$longitude)

#Unique buoy location using longitude and latitude
buoys <- unique(el_nino[, c("lon360", "latitude")])
colnames(buoys) <- c("longitude", "latitude")

#Convert world map to 0-360
world <- map_data("world")
world$long_360 <- (world$long + 360) %% 360

# 1. Plot the buoy location on a world map
ggplot() + geom_point(data = world, 
                        aes(x = long_360, y = lat, group = group), fill = NA, color = "maroon", size = 0.5) + 
  geom_point(
    data = buoys, aes(x = longitude, y = latitude),col = "darkblue", alpha = 0.6, size = 1.8) + 
  coord_cartesian(xlim = c(0, 360), ylim = c(-60, 70)) +
  labs(title = "Position of TAO Buoys In the Ocean",x = "Longitude (0-360)", y = "Latitude") + theme_minimal()

#2. Show variation in air temperature by latitude faceted by longitude bands
#Create latitude bands 
el_nino$lat_band <- ifelse(el_nino$latitude < -2, "South",
  ifelse(el_nino$latitude > 2, "North", "Equatorial"))
#factorize the latitude bands
el_nino$lat_band <- factor(el_nino$lat_band, levels = c("South", "Equatorial", "North"))

#Create longitude bands
el_nino$long_band <- ifelse(el_nino$lon360 < 180, "Western Pacific", 
                            ifelse(el_nino$lon360 < 240, "Central Pacific", "Eastern Pacific"))
#Factorize the longitude bands
el_nino$long_band <- factor(el_nino$long_band, levels = c("Western Pacific", "Central Pacific", "Eastern Pacific"))
#Boxplot using bands
ggplot(el_nino, aes(x = lat_band, y = air.temp., fill = lat_band)) + geom_boxplot(na.rm = TRUE) + facet_wrap(~ long_band) + 
      labs(title = "Air Temperature Variation by Latitude and Longitude Bands", x = "Latitude Bands",
           y = "Air Temperature (°C)") + theme_minimal()

# 3. Plot a variation of SST by latitude and longitude bands
#Mean SST by latitude and longitude bands
mean_sst_band <- aggregate(s.s.temp. ~ lat_band + long_band, data = el_nino, FUN = mean, na.rm = TRUE)

ggplot(mean_sst_band, aes(x = long_band, y = lat_band, fill = s.s.temp.)) + geom_tile(color = "white") + 
  geom_text(aes(label = sprintf("%.2f °C", s.s.temp.)), size = 4, color = "white") +
  scale_fill_gradient(low = "blue", high = "red") + labs(title = "Mean Sea Surface Temperature by Longitude and Latitude Bands", 
                                                         x = "Longitude Region", y = "Latitude Region", fill = "Mean SST") + 
  theme_minimal()

# 4. Seasonal cycle of buoys based on air and sea surface temperature 
#Filter to El nino 3.4 regions
nino34 <- el_nino[el_nino$latitude >= -5 & el_nino$latitude <= 5 & el_nino$lon360 >= 180 & el_nino$lon360 <= 240,]

#Climate change by calendar months
month_sst <- tapply(nino34$s.s.temp., nino34$month, mean, na.rm = TRUE)
month_air <- tapply(nino34$air.temp., nino34$month, mean, na.rm = TRUE)

monthly_clim <- data.frame(month = 1:12, mean_sst = as.numeric(month_sst[as.character(1:12)]),
                           mean_air = as.numeric(month_air[as.character(1:12)]))

monthly_long <- rbind(data.frame(month = monthly_clim$month, Variable = "Sea Surface Temperature", Temperature = monthly_clim$mean_sst),
                      data.frame(month = monthly_clim$month, Variable = "Air Temperature", Temperature = monthly_clim$mean_air))

#Plot seasonal cycle
ggplot(monthly_long, aes(x = month, y = Temperature, color = Variable, linetype = Variable)) + 
  geom_line(linewidth = 1.1, na.rm = TRUE) + 
  geom_point(size = 2.5, na.rm = TRUE) + 
  scale_x_continuous(breaks = 1:12, labels = month.abb) + labs(title = "Seasonal cycle in the El Nino 3.4 Region", 
                                                               subtitle = "Monthly means of Sea Surface and Air Temperature",
                                                               x = "Month", y = "Mean Temperature (°C)", color = "", linetype = "") + 
  theme_minimal() + theme(legend.position = "bottom")

# 5. Plot for Average SST each year in the Equatorial Pacific region
el_nino$year_full <- 1900 + el_nino$year
region_data <- el_nino[el_nino$lat_band == "Equatorial" & el_nino$long_band == "Central Pacific",]

#Yearly mean SST
yearly_mean_sst <- aggregate(s.s.temp. ~ year_full, data = region_data, FUN = mean, na.rm = TRUE)

ggplot(yearly_mean_sst, aes(x = year_full, y = s.s.temp.)) + geom_line(color = "steelblue") + 
  geom_point(color = "steelblue", size = 2) + labs(title = "Mean Sea Surface Temperature Over Time",
                                                   subtitle = "Buoys in the Equatorial Central Pacific Region",
                                                   x = "Year", y = "Mean SST (°C)") + theme_minimal()
