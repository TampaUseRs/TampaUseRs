#Weather conditions and predictions for Tampa, FL
#27.9947144,-82.59471
#get metadata info for TB area
tampa.meta.info <- weather.meta(27.9947144, -82.59471)
tampa.meta.info %>% write_csv("tampa.meta.csv")

#get forecast
tampa.forecast <- forecast.periodic(tampa.meta.info)
tampa.forecast$meta %>% write_csv("tampa.forecast.meta.csv")
tampa.forecast$periods %>% write_csv("tampa.forecast.periods.csv")
tampa.forecast$area %>% write_csv("tampa.forecast.area.csv")

#get hourly forecast
tampa.hourly.forecast <- forecast.hourly(tampa.meta.info)
tampa.hourly.forecast$meta %>% write_csv("tampa.hourly.forecast.meta.csv")
tampa.hourly.forecast$periods %>% write_csv("tampa.hourly.forecast.periods.csv")
tampa.hourly.forecast$area %>% write_csv("tampa.hourly.forecast.area.csv")

#get hourly forecast of grid points
tampa.gridpoints.forecast <- forecast.gridpoints(tampa.meta.info)
tampa.gridpoints.forecast$meta %>% write_csv("tampa.hourly.gridpoint.meta.quantities.csv")
tampa.gridpoints.forecast$periods %>% write_csv("tampa.hourly.gridpoint.periods.csv")

#stations for forecast
tampa.forecast.stations <- forecast.stations(tampa.meta.info)
tampa.forecast.stations$stations %>% write_csv("tampa.forecast.stations.csv")

#Weather conditions and predictions for Clearwater, FL
#27.9927343,-82.8176106
clearwater.meta.info <- weather.meta(27.9927343, -82.8176106)
clearwater.meta.info %>% write_csv("clearwater.meta.csv")

#get forecast
clearwater.forecast <- forecast.periodic(clearwater.meta.info)
clearwater.forecast$meta %>% write_csv("clearwater.forecast.meta.csv")
clearwater.forecast$periods %>% write_csv("clearwater.forecast.periods.csv")
clearwater.forecast$area %>% write_csv("clearwater.forecast.area.csv")

#get hourly forecast
clearwater.hourly.forecast <- forecast.hourly(clearwater.meta.info)
clearwater.hourly.forecast$meta %>% write_csv("clearwater.hourly.forecast.meta.csv")
clearwater.hourly.forecast$periods %>% write_csv("clearwater.hourly.forecast.periods.csv")
clearwater.hourly.forecast$area %>% write_csv("clearwater.hourly.forecast.area.csv")

#get hourly forecast of grid points
clearwater.gridpoints.forecast <- forecast.gridpoints(clearwater.meta.info)
clearwater.gridpoints.forecast$meta %>% write_csv("clearwater.hourly.gridpoint.meta.quantities.csv")
clearwater.gridpoints.forecast$periods %>% write_csv("clearwater.hourly.gridpoint.periods.csv")

#stations for forecast
clearwater.forecast.stations <- forecast.stations(clearwater.meta.info)
clearwater.forecast.stations$stations %>% write_csv("clearwater.forecast.stations.csv")

#Reddington Beach, FL

#Weather conditions and predictions for Lutz, FL
#28.1434843,-82.4834024
#get metadata info for TB area
lutz.meta.info <- weather.meta(28.1434843, -82.4834024)
#tb.forecast.zone <- forecast.zone(tb.meta.info)
lutz.meta.info %>% write_csv("lutz.meta.csv")

#get forecast
lutz.forecast <- forecast.periodic(lutz.meta.info)
lutz.forecast$meta %>% write_csv("lutz.forecast.meta.csv")
lutz.forecast$periods %>% write_csv("lutz.forecast.periods.csv")
lutz.forecast$area %>% write_csv("lutz.forecast.area.csv")

#get hourly forecast
lutz.hourly.forecast <- forecast.hourly(lutz.meta.info)
lutz.hourly.forecast$meta %>% write_csv("lutz.hourly.forecast.meta.csv")
lutz.hourly.forecast$periods %>% write_csv("lutz.hourly.forecast.periods.csv")
lutz.hourly.forecast$area %>% write_csv("lutz.hourly.forecast.area.csv")

#get hourly forecast of grid points
lutz.gridpoints.forecast <- forecast.gridpoints(lutz.meta.info)
lutz.gridpoints.forecast$meta %>% write_csv("lutz.hourly.gridpoint.meta.quantities.csv")
lutz.gridpoints.forecast$periods %>% write_csv("lutz.hourly.gridpoint.periods.csv")

#stations for forecast
lutz.forecast.stations <- forecast.stations(lutz.meta.info)
lutz.forecast.stations$stations %>% write_csv("lutz.forecast.stations.csv")

#Pensacola, FL - 30.4368551,-87.2629561
pensacola.meta.info <- weather.meta(30.4368551, -87.2629561)
pensacola.meta.info %>% write_csv("pensacola.meta.csv")

pensacola.forecast <- forecast.periodic(pensacola.meta.info)
pensacola.forecast$meta %>% write_csv("pensacola.forecast.meta.csv")
pensacola.forecast$periods %>% write_csv("pensacola.forecast.periods.csv")
pensacola.forecast$area %>% write_csv("pensacola.forecast.area.csv")

#get hourly forecast
pensacola.hourly.forecast <- forecast.hourly(pensacola.meta.info)
pensacola.hourly.forecast$meta %>% write_csv("pensacola.hourly.forecast.meta.csv")
pensacola.hourly.forecast$periods %>% write_csv("pensacola.hourly.forecast.periods.csv")
pensacola.hourly.forecast$area %>% write_csv("pensacola.hourly.forecast.area.csv")

#get hourly forecast of grid points
pensacola.gridpoints.forecast <- forecast.gridpoints(pensacola.meta.info)
pensacola.gridpoints.forecast$meta %>% write_csv("pensacola.hourly.gridpoint.meta.quantities.csv")
pensacola.gridpoints.forecast$periods %>% write_csv("pensacola.hourly.gridpoint.periods.csv")

#stations for forecast
pensacola.forecast.stations <- forecast.stations(pensacola.meta.info)
pensacola.forecast.stations$stations %>% write_csv("pensacola.forecast.stations.csv")

#Key West, FL - 24.564638,-81.7981806
key.west.meta.info <- weather.meta(24.564638, -81.7981806)
key.west.meta.info %>% write_csv("key.west.meta.csv")

key.west.forecast <- forecast.periodic(key.west.meta.info)
key.west.forecast$meta %>% write_csv("key.west.forecast.meta.csv")
key.west.forecast$periods %>% write_csv("key.west.forecast.periods.csv")
key.west.forecast$area %>% write_csv("key.west.forecast.area.csv")

#get hourly forecast
key.west.hourly.forecast <- forecast.hourly(key.west.meta.info)
key.west.hourly.forecast$meta %>% write_csv("key.west.hourly.forecast.meta.csv")
key.west.hourly.forecast$periods %>% write_csv("key.west.hourly.forecast.periods.csv")
key.west.hourly.forecast$area %>% write_csv("key.west.hourly.forecast.area.csv")

#get hourly forecast of grid points
key.west.gridpoints.forecast <- forecast.gridpoints(key.west.meta.info)
key.west.gridpoints.forecast$meta %>% write_csv("key.west.hourly.gridpoint.meta.quantities.csv")
key.west.gridpoints.forecast$periods %>% write_csv("key.west.hourly.gridpoint.periods.csv")

#stations for forecast
key.west.forecast.stations <- forecast.stations(key.west.meta.info)
key.west.forecast.stations$stations %>% write_csv("key.west.forecast.stations.csv")
