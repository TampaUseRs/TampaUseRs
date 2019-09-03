library(tidyverse)
library(tibble)
library(httr)
library(stringr)
library(lubridate)
library(jsonlite)

##########################################################################################
## Get metadata for a forecast
##########################################################################################
weather.meta <- function(lat, lon) {
  points.url <- paste("https://api.weather.gov/points/", lat, ",", lon, sep = "")
  
  resp <- httr::GET(points.url)
  status_cd <- status_code((resp))
  if(200 != status_cd) {
    return
  }
  
  #parse the content body and get back list -> list -> (turtles all the way down)
  body <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")
  coordinates <- unlist(body$geometry$coordinates)
  
  #build metadata tibble so we can write it out to a CSV file
  meta.tbl <- tibble( 
    http_status = 200,
    cwa = body$properties$cwa,
    gridX = body$properties$gridX,
    gridY = body$properties$gridY,
    longitude <- coordinates[1],
    latitude = coordinates[2],
    forecast.office.url = body$properties$forecastOffice,
    forecast.url = body$properties$forecast,
    forecast.hourly.url = body$properties$forecastHourly,
    forecast.grid.data.url = body$properties$forecastGridData,
    forecast.grid.stations.url = body$properties$observationStations,
    forecast.zone.url = body$properties$forecastZone,
    county = body$properties$county,
    fire.zone = body$properties$fireWeatherZone,
    time.zone = body$properties$timeZone,
    radar.station = body$properties$radarStation
  )
  attr(meta.tbl, 'info.type') <- 'nws.meta'
  meta.tbl
}

##########################################################################################
## Get periodic forecast (e.g. "Today", "Tonight")
##########################################################################################

forecast.periodic <- function(meta) {
  
  if("nws.meta" != attr(meta, "info.type")) {
    print("BLEAH")
  }
  
  print(meta$forecast.url)
  
  resp <- httr::GET(meta$forecast.url)
  status_cd <- status_code((resp))
  if(200 != status_cd) {
    return
  }
  
  body <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")

  geom1 <- body$geometry$geometries[1]
  geom1.unlist <- unlist(geom1)

  forecast.longitude <- as.numeric(geom1.unlist[2])
  forecast.latitude <- as.numeric(geom1.unlist[3])
  
  #body$geometry$gemoetries[2]$coordinates is forecast area boundary
  
  area.latitudes <- vector(mode = "numeric")
  area.longitudes <- vector(mode = "numeric")
  geom2 <- body$geometry$geometries[2]
  
  for( geom in geom2 ) {
    coords <- unlist(geom$coordinates)
    num.coords <- length(coords)
    longitude.indices <- seq.int(from = 1, to = num.coords) %% 2 == 1
    latitude.indices <- seq.int(from = 1, to = num.coords) %% 2 == 0
    area.latitudes <- c(area.latitudes, coords[latitude.indices])
    area.longitudes <- c(area.longitudes, coords[longitude.indices])
  }

  num_periods <- length(body$periods)
  
  #generate empty vectors
  period.number <- vector(mode = "numeric", length = num_periods)
  period.name <- vector(mode = "character", length = num_periods)
  
  period.start.time <- vector(mode = "numeric", length = num_periods)
  class(period.start.time) <- "POSIXct"
  
  period.end.time <- vector(mode = "numeric", length = num_periods)
  class(period.end.time) <- "POSIXct"
  
  period.is.daytime <- vector(mode = "logical", length = num_periods)
  period.temperature <- vector(mode = "numeric", length = num_periods)
  period.temperature.unit <- vector(mode = "character", length = num_periods)
  period.wind.speed <- vector(mode = "character", length = num_periods)
  period.wind.direction <- vector(mode = "character", length = num_periods)
  period.short.forecast <- vector(mode = "character", length = num_periods)
  period.detailed.forecast <- vector(mode = "character", length = num_periods)
  
  for( period in body$properties$periods ) {
    period.number[period$number] = period$number
    period.name[period$number] = period$name
    period.start.time[period$number] = ymd_hms(period$startTime)
    period.end.time[period$number] = ymd_hms(period$endTime)
    if(period$isDaytime == 1)  {
      period.is.daytime[period$number] = T
    }
    else {
      period.is.daytime[period$number] = F
    }
    period.temperature[period$number] = period$temperature
    period.temperature.unit[period$number] = period$temperatureUnit
    period.wind.speed[period$number] = ifelse(is.null(period$windSpeed), NA, period$windSpeed)
    period.wind.direction[period$number] = ifelse(is.null(period$windDirection), NA, period$windDirection)
    period.short.forecast[period$number] = period$shortForecast
    period.detailed.forecast[period$number] = period$detailedForecast
  }
  
  time.boundary = parse.valid.times(body$properties$validTimes)
  
  area.tbl <- tibble(
    area.longitudes, area.latitudes
  )
  
  #make a tibble of metadata - one row
  meta.tbl <- tibble(
    forecast.longitude = forecast.longitude,
    forecast.latitude = forecast.latitude,
    last.updated = body$properties$updated,
    units = body$properties$units,
    generator = body$properties$forecastGenerator,
    generated = body$properties$generatedAt,
    update.time = body$properties$updateTime,
    valid.start = time.boundary$start.time,
    valid.end = time.boundary$end.time,
    elevation = body$properties$elevation$value,
    unit.code = body$properties$elevation$unitCode,
    num.periods = length(body$properties$periods)
  )
  
  #make a tibble for forecast periods - one row per period
  periods.tbl <- tibble(
    period.number = period.number,
    period.name = period.name,
    period.start.time = period.start.time,
    period.end.time = period.end.time,
    period.is.daytime = period.is.daytime,
    period.temperature = period.temperature,
    period.temperature.unit = period.temperature.unit,
    period.wind.speed = period.wind.speed,
    period.wind.direction = period.wind.direction,
    period.short.forecast = period.short.forecast,
    period.detailed.forecast = period.detailed.forecast
  )
  
  #return a list with two tibbles in it
  result.list <- list(
    meta = meta.tbl, periods = periods.tbl, area = area.tbl
  )
  
  attr(result.list, "info.type", "nws.forecast")
  result.list
}

##########################################################################################
## Fetch hourly forecast
##########################################################################################

forecast.hourly <- function(meta) {
  
  if("nws.meta" != attr(meta, "info.type")) {
    print("BLEAH")
  }
  
  resp <- httr::GET(meta$forecast.hourly.url)
  status_cd <- status_code((resp))
  if(200 != status_cd) {
    return
  }
  print(meta$forecast.hourly.url)
  body <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")

  area.latitudes <- vector(mode = "numeric")
  area.longitudes <- vector(mode = "numeric")
  geom2 <- body$geometry$geometries[2]
  for( geom in geom2 ) {
    coords <- unlist(geom$coordinates)
    num.coords <- length(coords)
    longitude.indices <- seq.int(from = 1, to = num.coords) %% 2 == 1
    latitude.indices <- seq.int(from = 1, to = num.coords) %% 2 == 0
    area.latitudes <- c(area.latitudes, coords[latitude.indices])
    area.longitudes <- c(area.longitudes, coords[longitude.indices])
  }
  
  num_periods <- length(body$periods)
  
  #generate empty vectors
  period.number <- vector(mode = "numeric", length = num_periods)
  period.name <- vector(mode = "character", length = num_periods)
  
  period.start.time <- vector(mode = "numeric", length = num_periods)
  class(period.start.time) <- "POSIXct"
  
  period.end.time <- vector(mode = "numeric", length = num_periods)
  class(period.end.time) <- "POSIXct"
  
  period.is.daytime <- vector(mode = "logical", length = num_periods)
  period.temperature <- vector(mode = "numeric", length = num_periods)
  period.temperature.unit <- vector(mode = "character", length = num_periods)
  period.wind.speed <- vector(mode = "character", length = num_periods)
  period.wind.direction <- vector(mode = "character", length = num_periods)
  period.short.forecast <- vector(mode = "character", length = num_periods)
  period.detailed.forecast <- vector(mode = "character", length = num_periods)
  
  for( period in body$properties$periods ) {
    period.number[period$number] = period$number
    period.name[period$number] = period$name
    period.start.time[period$number] = ymd_hms(period$startTime)
    period.end.time[period$number] = ymd_hms(period$endTime)
    if(period$isDaytime == 1)  {
      period.is.daytime[period$number] = T
    }
    else {
      period.is.daytime[period$number] = F
    }
    period.temperature[period$number] = period$temperature
    period.temperature.unit[period$number] = period$temperatureUnit
    period.wind.speed[period$number] = ifelse(is.null(period$windSpeed), NA, period$windSpeed)
    period.wind.direction[period$number] = ifelse(is.null(period$windDirection), NA, period$windDirection)
    period.short.forecast[period$number] = period$shortForecast
    period.detailed.forecast[period$number] = period$detailedForecast
  }
  
  time.boundary = parse.valid.times(body$properties$validTimes)
  
  area.tbl <- tibble(
    area.longitudes, area.latitudes
  )

  meta.tbl <- tibble(
    #    point = body$geometry$geometries[1],
    #    polygon = body$geometry$geometries[2],
    last.updated = body$properties$updated,
    units = body$properties$units,
    generator = body$properties$forecastGenerator,
    generated = body$properties$generatedAt,
    update.time = body$properties$updateTime,
    valid.start = time.boundary$start.time,
    valid.end = time.boundary$end.time,
    elevation = body$properties$elevation$value,
    unit.code = body$properties$elevation$unitCode,
    num.periods = length(body$properties$periods)
  )
  
  periods.tbl <- tibble(
    period.number = period.number,
    period.name = period.name,
    period.start.time = period.start.time,
    period.end.time = period.end.time,
    period.is.daytime = period.is.daytime,
    period.temperature = period.temperature,
    period.temperature.unit = period.temperature.unit,
    period.wind.speed = period.wind.speed,
    period.wind.direction = period.wind.direction,
    period.short.forecast = period.short.forecast,
    period.detailed.forecast = period.detailed.forecast
  )
  
  result.list <- list(
    meta = meta.tbl, periods = periods.tbl, area = area.tbl
  )
  
  attr(result.list, "info.type", "nws.hourly.forecast")
  
  result.list
}

##########################################################################################
## Fetch detailed (and voluminous) quantities for forecast
##########################################################################################
forecast.gridpoints <- function(meta) {
  if("nws.meta" != attr(meta, "info.type")) {
    print("BLEAH")
    return
  }
  
  resp <- httr::GET(meta$forecast.grid.data.url)
  status_cd <- status_code((resp))
  if(200 != status_cd) {
    return
  }
  
  body <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")

  numeric.times <- unlist(parse.valid.times(body$properties$validTime))
  class(numeric.times) <- "POSIXct"
  hours.in.forecast <- as.numeric((numeric.times[2] - numeric.times[1])/3600)
  
  #by expanding the grid points we've hopefully put them on the same timestamp schedule
  #so we *should* only need to capture it once and after that just capture the value columns
  temperatures <- expand.numeric.grid.series(body$properties$temperature$values, numeric.times[1], numeric.times[2])
  timestamps <- temperatures$time.stamps
  temperature.uom <- body$properties$temperature$uom
  temperature.values <- temperatures$values
  
  precip.probs <- expand.numeric.grid.series(body$properties$probabilityOfPrecipitation$values, numeric.times[1], numeric.times[2])
  precip.prob.values <- precip.probs$values
  
  precip.prob.uom <- body$properties$probabilityOfPrecipitation$uom
  
  precip.qtys <- expand.numeric.grid.series(body$properties$quantitativePrecipitation$values, numeric.times[1], numeric.times[2])
  precip.qty.values <- precip.qtys$values
  
  precip.qty.uom <- body$properties$quantitativePrecipitation$uom
  
  meta.tbl <- tibble(
    update.time = body$properties$updateTime,
    start.time = numeric.times[1],
    end.time = numeric.times[2],
    gridId = body$properties$gridId,
    gridX = body$properties$gridX,
    gridY = body$properties$gridY,
    forecast.office = body$properties$forecastOffice,
    temperature.units = temperature.uom,
    prob.precip.units = precip.prob.uom, 
    qty.precip.units = precip.qty.uom
  )  
  
  periods.tbl <- tibble(
    time.stamps = timestamps,
    temperature = temperature.values, 
    prob.precip = precip.prob.values,
    qty.precip = precip.qty.values
  )
  
  results.lst <- list(
    meta = meta.tbl, periods = periods.tbl
  )
  
  results.lst 
}

####################################################################################
## expand.numeric.grid.series - this takes a compressed value series of grid points
## (consisting of a timestamp and duration, called a "valid time") and expands it
## to generate values for all collected grid series on a common set of time slots.
## since there are some data anomalies (predicted values beyond the valid times for
## the grid forecast as a whole) values that go beyond valid.end.time are dropped.
## return value is a list of timestamp and value list and this is only for numeric
## values.  it can be generalized to cover strings or arrays like cloud cover.
####################################################################################

expand.numeric.grid.series <- function(series, valid.start.time, valid.end.time) {
  
  row <- 1
  total.spans <- as.numeric((valid.end.time - valid.start.time) / 3600)
  
  time.stamps <- vector(mode = "numeric", length = total.spans)
  class(time.stamps) <- "POSIXct"
  
  values <- vector(mode = "numeric", length = total.spans)
  
  for( element in series ) {
    numeric.times <- unlist(parse.valid.times(element$validTime))
    start.time <- numeric.times[1]
    end.time <- numeric.times[2]
    nspan <- as.numeric(end.time - start.time) / 3600
    #do a for loop to go from 1:nspan; compute time.stamp and include value
    for( hr in 1:nspan ) {
      ts <- start.time + (hr-1) * 3600
      to.end.of.forecast <- as.numeric(valid.end.time - ts)
      if(to.end.of.forecast < 3600) {
        break
      }
      time.stamp <- lubridate::as_datetime(ts)
      names(time.stamp) <- c()
      time.stamps[row] <- time.stamp
      values[row] <- element$value
      row <- row + 1
    }
  }
  
  list( time.stamps = time.stamps, values = values )
}

##########################################################################################
## gets all weather stations contributing to the forecast
## and returns them in a tibble contained in a list
##########################################################################################
forecast.stations <- function(meta) {
  
  if("nws.meta" != attr(meta, "info.type")) {
    print("BLEAH")
    return
  }
  
  print(meta$forecast.grid.stations.url)
  
  resp <- httr::GET(meta$forecast.grid.stations.url)
  status_cd <- status_code((resp))
  if(200 != status_cd) {
    return
  }
  
  station.id = character()
  station.type = character()
  station.url = character()
  station.latitude = numeric()
  station.longitude = numeric()
  station.elevation = numeric()
  elevation.units = character()
  station.name = character()
  station.timezone = character()
  
  if(200 == status_cd) {
    row <- 1
    body <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")
    for( feature in body$features ) {
      
      url <- feature$id
      coords <- unlist(feature$geometry$coordinates)
      lon <- unlist(coords[1])
      lat <- unlist(coords[2])
      type <- feature$properties$`@type`
      elevation <- feature$properties$elevation$value
      unitCode <- feature$properties$elevation$unitCode
      stationId <- feature$properties$stationIdentifier
      stationName <- feature$properties$name
      stationTimezone <- feature$properties$timeZone
      
      station.id[row] <- stationId
      station.name[row] <- stationName
      station.type[row] <- type
      station.url[row] <- url
      station.latitude[row] <- lat
      station.longitude[row] <- lon
      station.elevation[row] <- elevation
      elevation.units[row] <- unitCode
      station.name[row] <- stationName
      station.timezone[row] <- stationTimezone
      
      row <- row + 1
    }
  }
  
  stations.tbl <- tibble( 
    station.id, 
    station.name, 
    station.type, 
    station.url,
    station.longitude,
    station.latitude,
    station.elevation,
    elevation.units,
    station.timezone
  )
  
  attr(stations.tbl, "info.type") <- "weather.stations"
  
  list(status_code = status_cd, stations = stations.tbl)
}

##########################################################################################
## gets current conditions (latest observations) at all weather stations contributing 
## to the forecast and returns them in a tibble
##########################################################################################
current.conditions <- function(stations) {
  
  if("weather.stations" != attr(stations, "info.type")) {
    print("BLEAH")
    return
  }
  
  #stations should be a tibble, so we loop through and generate
  #urls as /stations/{stationId}/observations/latest
  
  station.ids <- vector()
  latitudes <- numeric()
  longitudes <- numeric()
  
  #todo: add station.gridX and station.gridY so they can be matched up
  # with grid forecast points
  
  timestamps <- numeric()
  class(timestamps) <- "POSIXct"
  
  text.descriptions <- character()
  
  temperature.values <- numeric()
  temperature.unit.codes <- character()
  temperature.quality.controls <- character()
  
  dewpoint.values <- numeric()
  dewpoint.unit.codes <- character()
  dewpoint.quality.controls <- character()
  
  wind.direction.values <- numeric()
  wind.direction.unit.codes <- character()
  wind.direction.quality.controls <- character()
  
  wind.speed.values <- numeric()
  wind.speed.unit.codes <- character()
  wind.speed.quality.controls <- character()
  
  wind.gust.values <- numeric()
  wind.gust.unit.codes <- character()
  wind.gust.quality.controls <- character()
  
  barometric.pressure.values <- numeric()
  barometric.pressure.unit.codes <- character()
  barometric.pressure.quality.controls <- character()
  
  sea.level.pressure.values <- numeric()
  sea.level.pressure.unit.codes <- character()
  sea.level.pressure.quality.controls <- character()
  
  visibility.values <- numeric()
  visibility.unit.codes <- character()
  visibility.quality.controls <- character()
  
  relative.humidity.values <- numeric()
  relative.humidity.unit.codes <- character()
  relative.humidity.quality.controls <- character()
  
  wind.chill.values <- numeric()
  wind.chill.unit.codes <- character()
  wind.chill.quality.controls <- character()
  
  heat.index.values <- numeric()
  heat.index.unit.codes <- character()
  heat.index.quality.controls <- character()
  
  for( row in 1:nrow(stations)) {
    
    conditions.url <- paste("https://api.weather.gov/stations/", stations[row, "station.id"], "/observations/latest", sep = "")
    print(conditions.url)
    resp <- httr::GET(conditions.url)
    status_cd <- status_code(resp)
    conditions <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")

    station.ids[row] <- unlist(stations[row, "station.id"])
    latitudes[row] <- unlist(stations[row, "station.latitude"])
    longitudes[row] <- unlist(stations[row, "station.longitude"])
    timestamps[row] <- ymd_hms(conditions$properties$timestamp)

    text.descriptions[row] <- conditions$properties$textDescription
    
    if(is.null(conditions$properties$temperature$value)) {
      temperature.values[row] <- NA
    }
    else {
      temperature.values[row] <- conditions$properties$temperature$value
    }
    temperature.unit.codes[row] <- conditions$properties$temperature$unitCode
    temperature.quality.controls[row] <- conditions$properties$temperature$qualityControl
    
    if(is.null(conditions$properties$dewpoint$value)) {
      dewpoint.values[row] <- NA
    }
    else {
      dewpoint.values[row] <- conditions$properties$dewpoint$value
    }
    dewpoint.unit.codes[row] <- conditions$properties$dewpoint$unitCode
    dewpoint.quality.controls[row] <- conditions$properties$dewpoint$qualityControl
    
    if(is.null(conditions$properties$windDirection$value)) {
      wind.direction.values[row] <- NA
    }
    else {
      wind.direction.values[row] <- conditions$properties$windDirection$value
    }
    wind.direction.unit.codes[row] <- conditions$properties$windDirection$unitCode
    wind.direction.quality.controls[row] <- conditions$properties$windDirection$qualityControl
    
    if(is.null(conditions$properties$windSpeed$value)) {
      wind.speed.values[row] <- NA
    }
    else {
      wind.speed.values[row] <- conditions$properties$windSpeed$value
    }
    wind.speed.unit.codes[row] <- conditions$properties$windSpeed$unitCode
    wind.speed.quality.controls[row] <- conditions$properties$windSpeed$qualityControl
    
    if(is.null(conditions$properties$windGust$value)) {
      wind.gust.values[row] = NA
    }
    else {
      wind.gust.values[row] <- conditions$properties$windGust$value
    }
    wind.gust.unit.codes[row] <- conditions$properties$windGust$unitCode
    wind.gust.quality.controls[row] <- conditions$properties$windGust$qualityControl
    
    if(is.null(conditions$properties$barometricPressure$value)) {
      barometric.pressure.values[row] <- NA
    }
    else {
      barometric.pressure.values[row] <- conditions$properties$barometricPressure$unitCode
    }
    barometric.pressure.unit.codes[row] <- conditions$properties$barometricPressure$unitCode
    barometric.pressure.quality.controls[row] <- conditions$properties$barometricPressure$qualityControl
    
    if(is.null(conditions$properties$seaLevelPressure$value)) {
      sea.level.pressure.values[row] <- NA
    }
    else {
      sea.level.pressure.values[row] <- conditions$properties$seaLevelPressure$value
    }
    sea.level.pressure.unit.codes[row] <- conditions$properties$seaLevelPressure$unitCode
    sea.level.pressure.quality.controls[row] <- conditions$properties$seaLevelPressure$qualityControl
    
    if(is.null(conditions$properties$visibility$value)) {
      visibility.values[row] <- NA
    }
    else {
      visibility.values[row] <- conditions$properties$visibility$value
    }
    visibility.unit.codes[row] <- conditions$properties$visibility$unitCode
    visibility.quality.controls[row] <- conditions$properties$visibility$qualityControl
    
    if(is.null(conditions$properties$relativeHumidity$value)) {
      relative.humidity.values[row] <- NA
    }
    else {
      relative.humidity.values[row] <- conditions$properties$relativeHumidity$value
    }
    relative.humidity.unit.codes[row] <- conditions$properties$relativeHumidity$unitCode
    relative.humidity.quality.controls[row] <- conditions$properties$relativeHumidity$qualityControl
    
    if(is.null(conditions$properties$windChill$value)) {
      wind.chill.values[row] <- NA
    }
    else {
      wind.chill.values[row] <- conditions$properties$windChill$value
    }
    wind.chill.unit.codes[row] <- conditions$properties$windChill$unitCode
    wind.chill.quality.controls[row] <- conditions$properties$windChill$qualityControl
    
    if(is.null(conditions$properties$heatIndex$value)) {
      heat.index.values[row] <- NA
    }
    else {
      heat.index.values[row] <- conditions$properties$heatIndex$value
    }
    heat.index.unit.codes[row] <- conditions$properties$heatIndex$unitCode
    heat.index.quality.controls[row] <- conditions$properties$heatIndex$qualityControl
  }
  
  conditions.tbl <- tibble(
    station.ids = station.ids,
    time.stamps = timestamps,
    latitudes, longitudes,
    temperature.values, temperature.unit.codes, temperature.quality.controls,
    dewpoint.values, dewpoint.unit.codes, dewpoint.quality.controls,
    wind.speed.values, wind.speed.unit.codes, wind.speed.quality.controls,
    wind.direction.values, wind.direction.unit.codes, wind.direction.quality.controls,
    wind.gust.values, wind.gust.unit.codes, wind.gust.quality.controls,
    wind.chill.values, wind.chill.unit.codes, wind.chill.quality.controls,
    barometric.pressure.values, barometric.pressure.unit.codes, barometric.pressure.quality.controls,
    sea.level.pressure.values, sea.level.pressure.unit.codes, sea.level.pressure.quality.controls,
    relative.humidity.values, relative.humidity.unit.codes, relative.humidity.quality.controls,
    visibility.values, visibility.unit.codes, visibility.quality.controls,
    heat.index.values, heat.index.unit.codes, heat.index.quality.controls
  )
  
  attr(conditions.tbl, "info.type") <- "current.conditions"
  
  conditions.tbl
}


##########################################################################################
## all observations for a specific weather station
##########################################################################################
all.conditions.for.stations <- function(stationIds) {
  
  timestamps <- numeric()
  class(timestamps) <- "POSIXct"
  
  formatted.timestamps <- character()
  
  text.descriptions <- character()
  
  temperature.values <- numeric()
  temperature.unit.codes <- character()
  temperature.quality.controls <- character()
  
  dewpoint.values <- numeric()
  dewpoint.unit.codes <- character()
  dewpoint.quality.controls <- character()
  
  wind.direction.values <- numeric()
  wind.direction.unit.codes <- character()
  wind.direction.quality.controls <- character()
  
  wind.speed.values <- numeric()
  wind.speed.unit.codes <- character()
  wind.speed.quality.controls <- character()
  
  wind.gust.values <- numeric()
  wind.gust.unit.codes <- character()
  wind.gust.quality.controls <- character()
  
  barometric.pressure.values <- numeric()
  barometric.pressure.unit.codes <- character()
  barometric.pressure.quality.controls <- character()
  
  sea.level.pressure.values <- numeric()
  sea.level.pressure.unit.codes <- character()
  sea.level.pressure.quality.controls <- character()
  
  visibility.values <- numeric()
  visibility.unit.codes <- character()
  visibility.quality.controls <- character()
  
  relative.humidity.values <- numeric()
  relative.humidity.unit.codes <- character()
  relative.humidity.quality.controls <- character()
  
  wind.chill.values <- numeric()
  wind.chill.unit.codes <- character()
  wind.chill.quality.controls <- character()
  
  heat.index.values <- numeric()
  heat.index.unit.codes <- character()
  heat.index.quality.controls <- character()
  
  row <- 1
  
  for( stationId in stationIds ) {
    
    #urls as /stations/{stationId}/observations
    station.observations.url <- paste("https://api.weather.gov/stations/", stationId, "/observations", sep = "")
  
    print(paste("QUERYING", station.observations.url))
    resp <- httr::GET(station.observations.url)
    status_cd <- status_code(resp)
    observations <- content(resp, "parsed", encoding = "UTF-8", type = "application/json")
  
    for(conditions in observations$features) {
    
      yms_timestamp <- ymd_hms(conditions$properties$timestamp) 
      timestamps[row] <- yms_timestamp
      formatted.timestamp <- format(yms_timestamp, format="%Y-%m-%d %H:%M:%S")
      formatted.timestamps[row] <- formatted.timestamp
      text.descriptions[row] <- conditions$properties$textDescription
    
      if(is.null(conditions$properties$temperature$value)) {
        temperature.values[row] <- NA
      }
      else {
        temperature.values[row] <- conditions$properties$temperature$value
      }
      temperature.unit.codes[row] <- conditions$properties$temperature$unitCode
      temperature.quality.controls[row] <- conditions$properties$temperature$qualityControl
    
      if(is.null(conditions$properties$dewpoint$value)) {
        dewpoint.values[row] <- NA
      }
      else {
        dewpoint.values[row] <- conditions$properties$dewpoint$value
      }
      dewpoint.unit.codes[row] <- conditions$properties$dewpoint$unitCode
      dewpoint.quality.controls[row] <- conditions$properties$dewpoint$qualityControl
    
      if(is.null(conditions$properties$windDirection$value)) {
        wind.direction.values[row] <- NA
      }
      else {
        wind.direction.values[row] <- conditions$properties$windDirection$value
      }
      wind.direction.unit.codes[row] <- conditions$properties$windDirection$unitCode
      wind.direction.quality.controls[row] <- conditions$properties$windDirection$qualityControl
    
      if(is.null(conditions$properties$windSpeed$value)) {
        wind.speed.values[row] <- NA
      }
      else {
        wind.speed.values[row] <- conditions$properties$windSpeed$value
      }
      wind.speed.unit.codes[row] <- conditions$properties$windSpeed$unitCode
      wind.speed.quality.controls[row] <- conditions$properties$windSpeed$qualityControl
    
      if(is.null(conditions$properties$windGust$value)) {
        wind.gust.values[row] = NA
      }
      else {
        wind.gust.values[row] <- conditions$properties$windGust$value
      }
      wind.gust.unit.codes[row] <- conditions$properties$windGust$unitCode
      wind.gust.quality.controls[row] <- conditions$properties$windGust$qualityControl
    
      if(is.null(conditions$properties$barometricPressure$value)) {
        barometric.pressure.values[row] <- NA
      }
      else {
        barometric.pressure.values[row] <- conditions$properties$barometricPressure$unitCode
      }
      barometric.pressure.unit.codes[row] <- conditions$properties$barometricPressure$unitCode
      barometric.pressure.quality.controls[row] <- conditions$properties$barometricPressure$qualityControl
    
      if(is.null(conditions$properties$seaLevelPressure$value)) {
        sea.level.pressure.values[row] <- NA
      }
      else {
        sea.level.pressure.values[row] <- conditions$properties$seaLevelPressure$value
      }
      sea.level.pressure.unit.codes[row] <- conditions$properties$seaLevelPressure$unitCode
      sea.level.pressure.quality.controls[row] <- conditions$properties$seaLevelPressure$qualityControl
    
      if(is.null(conditions$properties$visibility$value)) {
        visibility.values[row] <- NA
      }
      else {
        visibility.values[row] <- conditions$properties$visibility$value
      }
      visibility.unit.codes[row] <- conditions$properties$visibility$unitCode
      visibility.quality.controls[row] <- conditions$properties$visibility$qualityControl
    
      if(is.null(conditions$properties$relativeHumidity$value)) {
        relative.humidity.values[row] <- NA
      }
      else {
        relative.humidity.values[row] <- conditions$properties$relativeHumidity$value
      }
      relative.humidity.unit.codes[row] <- conditions$properties$relativeHumidity$unitCode
      relative.humidity.quality.controls[row] <- conditions$properties$relativeHumidity$qualityControl
    
      if(is.null(conditions$properties$windChill$value)) {
        wind.chill.values[row] <- NA
      }
      else {
        wind.chill.values[row] <- conditions$properties$windChill$value
      }
      wind.chill.unit.codes[row] <- conditions$properties$windChill$unitCode
      wind.chill.quality.controls[row] <- conditions$properties$windChill$qualityControl
    
      if(is.null(conditions$properties$heatIndex$value)) {
        heat.index.values[row] <- NA
      }
      else {
        heat.index.values[row] <- conditions$properties$heatIndex$value
      }
      heat.index.unit.codes[row] <- conditions$properties$heatIndex$unitCode
      heat.index.quality.controls[row] <- conditions$properties$heatIndex$qualityControl
      row <- row + 1
    }
  }
  conditions.tbl <- tibble(
    time.stamps = timestamps, formatted.timestamps = formatted.timestamps,
    temperature.values, temperature.unit.codes, temperature.quality.controls,
    dewpoint.values, dewpoint.unit.codes, dewpoint.quality.controls,
    wind.speed.values, wind.speed.unit.codes, wind.speed.quality.controls,
    wind.direction.values, wind.direction.unit.codes, wind.direction.quality.controls,
    wind.gust.values, wind.gust.unit.codes, wind.gust.quality.controls,
    wind.chill.values, wind.chill.unit.codes, wind.chill.quality.controls,
    barometric.pressure.values, barometric.pressure.unit.codes, barometric.pressure.quality.controls,
    sea.level.pressure.values, sea.level.pressure.unit.codes, sea.level.pressure.quality.controls,
    relative.humidity.values, relative.humidity.unit.codes, relative.humidity.quality.controls,
    visibility.values, visibility.unit.codes, visibility.quality.controls,
    heat.index.values, heat.index.unit.codes, heat.index.quality.controls
  )
}

##########################################################################################
## utils
##########################################################################################

##########################################################################################
# turns 2019-07-13T01:00:00+00:00/P8D into start time and end time
##########################################################################################
parse.valid.times <- function(valid.times) {
  # 1. split into start time and time span by "/"
  valid.times.parts <- unlist(str_split(valid.times, "/"))
  # 2. turn start time into timestamp using lubridate
  start.instant <- ymd_hms(valid.times.parts[1])
  # 3. turn time span into period using lubridate
  time.duration <- duration(valid.times.parts[2])
  # 4. add period to start time and return vector with named values
  end.instant <- start.instant + time.duration
  list(start.time = start.instant, end.time = end.instant)
}

