#latest observations at each of those stations
tampa.current.conditions <- current.conditions(tampa.forecast.stations$stations)
tampa.current.conditions %>% write_csv("tampa.current.conditions.csv")

tampa.all.observations <- all.conditions.for.stations(tampa.forecast.stations$stations$station.id)
tampa.all.observations %>% write_csv("tampa.all.observations.csv")

#latest observations at each of those stations
clearwater.current.conditions <- current.conditions(clearwater.forecast.stations$stations)
clearwater.current.conditions %>% write_csv("clearwater.current.conditions.csv")

clearwater.all.observations <- all.conditions.for.stations(clearwater.forecast.stations$stations$station.id)
clearwater.all.observations %>% write_csv("clearwater.all.observations.csv")

#latest observations at each of those stations
lutz.current.conditions <- current.conditions(lutz.forecast.stations$stations)
lutz.current.conditions %>% write_csv("lutz.current.conditions.csv")

lutz.all.observations <- all.conditions.for.stations(lutz.forecast.stations$stations$station.id)
lutz.all.observations %>% write_csv("lutz.all.observations.csv")

#pensacola
pensacola.current.conditions <- current.conditions(pensacola.forecast.stations$stations)
pensacola.current.conditions %>% write_csv("pensacola.current.conditions.csv")

pensacola.all.observations <- all.conditions.for.stations(pensacola.forecast.stations$stations$station.id)
pensacola.all.observations %>% write_csv("pensacola.all.observations.csv")

#key west
key.west.current.conditions <- current.conditions(key.west.forecast.stations$stations)

key.west.current.conditions %>% write_csv("key.west.current.conditions.csv")

key.west.all.observations <- all.conditions.for.stations(key.west.forecast.stations$stations$station.id)
key.west.all.observations %>% write_csv("key.west.all.observations.csv")
