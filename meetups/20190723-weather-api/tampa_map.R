library(leaflet)

#markers
weatherStationIcon <- makeIcon(
  iconUrl = "weather-station.png",
  iconWidth = 32, iconHeight = 31,
  iconAnchorX = 16, iconAnchorY = 15
)

format.station.popup <- function(temp, wind.spd, rel.humid) {
    paste("Temp: <b>", temp, "C", "</b><br/>", 
          "Wind: <i>", wind.spd, "m/s", "</i><br/>",
          "Humid: <i>", rel.humid, "%", "</i>", sep = "")
}

#popup for weather station - temp/unit, wind speed, 
stations <- tampa.forecast.stations$stations %>% select( station.id, station.name)
augmented.conditions <- full_join( tampa.current.conditions, stations, by = c("station.ids" = "station.id")) %>%
  mutate(popup.html = format.station.popup(temperature.values, wind.speed.values, relative.humidity.values))

tampa.area <- tampa.forecast$area
tampa.area
m.tampa <- leaflet(data = augmented.conditions) %>% 
  setView(lng = tampa.forecast$meta$forecast.longitude, lat = tampa.forecast$meta$forecast.latitude, zoom = 10) %>% 
  addTiles() %>%
  addPolygons(data = tampa.area, lng = ~area.longitudes, lat = ~area.latitudes) %>%
  addMarkers( lng = ~longitudes, lat = ~latitudes, 
              label = ~station.name, 
              popup = ~popup.html, 
              icon = weatherStationIcon) %>%
  addMarkers( data = tampa.forecast$meta, lng = ~forecast.longitude, lat = ~forecast.latitude, label = "Tampa, FL")
m.tampa
