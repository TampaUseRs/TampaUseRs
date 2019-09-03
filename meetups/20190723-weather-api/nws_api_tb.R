
##########################################################################################
# next up - should have functions that generates a raster layer from the forecast or current
# conditions tibbles?

#Weather conditions and predictions for Tampa, FL
#27.9947144,-82.59471
#get metadata info for TB area
tampa.meta.info <- weather.meta(27.9947144, -82.59471)
tampa.meta.info %>% write_csv("tampa.meta.csv")

#get forecast
tampa.forecast <- forecast.periodic(tampa.meta.info)
tampa.forecast$meta %>% write_csv("tampa.forecast.meta.csv")
tampa.forecast$periods %>% write_csv("tampa.forecast.periods.csv")

#get hourly forecast
tampa.hourly.forecast <- forecast.hourly(tampa.meta.info)
tampa.hourly.forecast$meta %>% write_csv("tampa.hourly.forecast.meta.csv")
tampa.hourly.forecast$periods %>% write_csv("tampa.hourly.forecast.periods.csv")

#get hourly forecast of grid points
tampa.gridpoints.forecast <- forecast.gridpoints(tampa.meta.info)
tampa.gridpoints.forecast$meta %>% write_csv("tampa.hourly.gridpoint.meta.quantities.csv")
tampa.gridpoints.forecast$periods %>% write_csv("tampa.hourly.gridpoint.periods.csv")

#stations for forecast
tampa.forecast.stations <- forecast.stations(tampa.meta.info)

#latest observations at each of those stations
tampa.current.conditions <- current.conditions(tampa.forecast.stations$stations)

tampa.current.conditions %>% write_csv("tampa.current.conditions.csv")

#Weather conditions and predictions for Clearwater, FL
#27.9927343,-82.8176106
#get metadata info for TB area
clearwater.meta.info <- weather.meta(27.9927343, -82.8176106)
#tb.forecast.zone <- forecast.zone(tb.meta.info)
clearwater.meta.info %>% write_csv("clearwater.meta.csv")

#get forecast
clearwater.forecast <- forecast.periodic(clearwater.meta.info)
clearwater.forecast$meta %>% write_csv("clearwater.forecast.meta.csv")
clearwater.forecast$periods %>% write_csv("clearwater.forecast.periods.csv")

#get hourly forecast
clearwater.hourly.forecast <- forecast.hourly(clearwater.meta.info)
clearwater.hourly.forecast$meta %>% write_csv("clearwater.hourly.forecast.meta.csv")
clearwater.hourly.forecast$periods %>% write_csv("clearwater.hourly.forecast.periods.csv")

#get hourly forecast of grid points
clearwater.gridpoints.forecast <- forecast.gridpoints(clearwater.meta.info)
clearwater.gridpoints.forecast$meta %>% write_csv("clearwater.hourly.gridpoint.meta.quantities.csv")
clearwater.gridpoints.forecast$periods %>% write_csv("clearwater.hourly.gridpoint.periods.csv")

#stations for forecast
clearwater.forecast.stations <- forecast.stations(clearwater.meta.info)

#latest observations at each of those stations
clearwater.current.conditions <- current.conditions(clearwater.forecast.stations$stations)

clearwater.current.conditions %>% write_csv("clearwater.current.conditions.csv")

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

#get hourly forecast
lutz.hourly.forecast <- forecast.hourly(lutz.meta.info)
lutz.hourly.forecast$meta %>% write_csv("lutz.hourly.forecast.meta.csv")
lutz.hourly.forecast$periods %>% write_csv("lutz.hourly.forecast.periods.csv")

#get hourly forecast of grid points
lutz.gridpoints.forecast <- forecast.gridpoints(lutz.meta.info)
lutz.gridpoints.forecast$meta %>% write_csv("lutz.hourly.gridpoint.meta.quantities.csv")
lutz.gridpoints.forecast$periods %>% write_csv("lutz.hourly.gridpoint.periods.csv")

#stations for forecast
lutz.forecast.stations <- forecast.stations(clearwater.meta.info)

#latest observations at each of those stations
lutz.current.conditions <- current.conditions(lutz.forecast.stations$stations)

lutz.current.conditions %>% write_csv("lutz.current.conditions.csv")

#hmm.  we might think about passing in a list of start.time / end.time / period.number
#tuples so we can tag the conditions with which forecast period they belong to. this
#would make it easier to merge the forecasts with 
#### tb.all.KZPH.conditions <- all.conditions.for.station("KZPH")
#### tb.all.KLAL.conditions <- all.conditions.for.station("KLAL")
#### tb.all.KGIF.conditions <- all.conditions.for.station("KGIF")
#### tb.all.KBOW.conditions <- all.conditions.for.station("KBOW")

#at this point we've got the raw data for displaying stuff on a map
#now we need to show how to generate raster layers from the forecast and current
#we can take the tb.gridpoints.forecast$columns$<name> and use the start.time
#and end.time values to map the period.number onto the conditions list for the
#same quantity
#merge.conditions.and.forecast(conditions, grid.forecast)