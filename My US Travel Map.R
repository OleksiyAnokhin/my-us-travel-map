# Oleksiy Anokhin 
# October 8, 2017

# My US Travel Map 

# Libraries
library(rgdal)
library(sp)
library(leaflet)
library(geojsonio)
library(RColorBrewer)
library(dplyr)

# Set working directory
# setwd("C:/Users/wb516241/OneDrive - WBG/Oleksiy Anokhin/My R Work/Shiny apps/App US Travel Map")

# Read csv, which was created specifically for this app
travel.data <- read.csv("My US Travel Map.csv", header = TRUE) 
class(travel.data)
# Read geojson file
states <- geojson_read("gz_2010_us_040_00_500k.json", what = "sp")
class(states)
travel.map <- merge(states, travel.data, by.x = "NAME", by.y = "State", duplicateGeoms = TRUE)
class(travel.map)

# Create a map
pal <- colorFactor(
  palette = c("red", "yellow", "orange", "gray", "green"),
  domain = travel.map$State.status)

state_popup <- paste0("<strong>State: </strong>", 
                      travel.map$NAME, 
                      "<br><strong>State status: </strong>",
                      travel.map$State.status)

city_popup <- paste0("<strong>City/town: </strong>", 
                     travel.map$City, 
                     "<br><strong>City/town status: </strong>",
                     travel.map$City.status)

  leaflet(travel.map) %>% 
    addProviderTiles(providers$Stamen.TonerLite) %>%  
    setView(lng = -98.583, lat = 39.833, zoom = 4) %>%  
    addPolygons(color = "#444444", weight = 1, 
                # opacity = 0.5, 
                fillOpacity = 0.7,
                fillColor = ~pal(travel.map$State.status),
                popup = state_popup) %>%
    addMarkers(data = travel.map, ~travel.map$long, ~travel.map$lat, popup = city_popup#,
              #clusterOptions = markerClusterOptions()
              ) %>%
    addLegend("bottomright", pal = pal, values = ~travel.map$State.status, opacity = 1,
              title = "My Travel Map in the US by State")
  
  