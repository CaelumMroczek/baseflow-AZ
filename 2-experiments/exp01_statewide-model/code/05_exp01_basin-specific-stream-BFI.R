# Read in artificial lat long points
# derived from points on each NHD stream sections
pts.raw <- read.csv(here("2-experiments/exp01_statewide-model/data/lower-san-pedro_pts.csv"))
years <- 1991:2020


# Load variable datasets
ppt <- read.csv(here("1-data/huc8_precip.csv"))
tmp <- read.csv(here("1-data/huc8_temperature.csv"))
et <- read.csv(here("1-data/huc8_aet.csv"))
spat <- read.csv(here("1-data/huc8_spatial-variables.csv"))

huc8_shape <- shapefile(here("1-data/raw/shapefile/huc8.shp"))

## Prepare pts dataframe
# Need to extract HUC8 from each Lat/Long
# and add years 1991:2020 to each observation
pts_sf <- st_as_sf(pts.raw, coords = c("Long", "Lat"), crs = 4326) # Assuming pts is in WGS84 (EPSG:4326)
pts_sf <- st_transform(pts_sf, crs = st_crs(huc8_shape)) # Transform pts_sf to the CRS of huc8_shape (which is Mercator)
huc8_sf <- st_as_sf(huc8_shape) # Convert huc8_shape to an sf object if it is not already
pts_with_huc8 <- st_join(pts_sf, huc8_sf)# Perform a spatial join to extract the HUC8 that each point is in

pts_with_huc8 <- st_transform(pts_with_huc8, crs = 4326) # Make pts_with_huc8 the same CRS as pts

pts <- pts_with_huc8 %>%
  mutate(Long = st_coordinates(.)[, 1],
         Lat = st_coordinates(.)[, 2]) %>% # Extract the Longitude and Latitude from the geometry column
  expand_grid(years) %>% # Add suite of years to each observation
  rename(Long = Long,
         Lat = Lat,
         Elevation_M = Elev_M,
         Year = years) %>%
  dplyr::select(HUC8, Long, Lat, Year, Elevation_M) # Choose/Reorder columns

# Assign variables to each observation
source(here("1-data/preprocessing/1_preprocess_fx.R"))
final.sanPedro <- assignVariables_preprocessing(pts)

final_data.sanPedro <- final.sanPedro[,c(1:4,6:8,5,10:51)]

# Predictions -------------------------------------------------------------

xgb.statewide <- xgb.load(here("2-experiments/exp01_statewide-model/models/xgb.statewide"))

final_data.sanPedro$Predicted_BFI <- inv.logit(predict(object = xgb.statewide, newdata = as.matrix(final_data.sanPedro[, 5:50])))

summary.sanPedro <- final_data.sanPedro %>%
  group_by(HUC8, Long, Lat) %>%
  summarise(meanBFI = mean(Predicted_BFI))

write.csv(final_data.sanPedro, here("2-experiments/exp01_statewide-model/data/san-pedro-pts_dataset.csv"))
write.csv(summary.sanPedro, here("2-experiments/exp01_statewide-model/data/san-pedro_meanBFI.csv"))

# Upper Verde Streams -----------------------------------------------------

# Read in artificial lat long points
# derived from points on each NHD stream sections
pts.raw <- read.csv(here("2-experiments/exp01_statewide-model/data/upper-verde_pts.csv"))
years <- 1991:2020


# Load variable datasets
ppt <- read.csv(here("1-data/huc8_precip.csv"))
tmp <- read.csv(here("1-data/huc8_temperature.csv"))
et <- read.csv(here("1-data/huc8_aet.csv"))
spat <- read.csv(here("1-data/huc8_spatial-variables.csv"))

huc8_shape <- shapefile(here("1-data/raw/shapefile/huc8.shp"))

## Prepare pts dataframe
# Need to extract HUC8 from each Lat/Long
# and add years 1991:2020 to each observation
pts_sf <- st_as_sf(pts.raw, coords = c("Long", "Lat"), crs = 4326) # Assuming pts is in WGS84 (EPSG:4326)
pts_sf <- st_transform(pts_sf, crs = st_crs(huc8_shape)) # Transform pts_sf to the CRS of huc8_shape (which is Mercator)
huc8_sf <- st_as_sf(huc8_shape) # Convert huc8_shape to an sf object if it is not already
pts_with_huc8 <- st_join(pts_sf, huc8_sf)# Perform a spatial join to extract the HUC8 that each point is in

pts_with_huc8 <- st_transform(pts_with_huc8, crs = 4326) # Make pts_with_huc8 the same CRS as pts

pts <- pts_with_huc8 %>%
  mutate(Long = st_coordinates(.)[, 1],
         Lat = st_coordinates(.)[, 2]) %>% # Extract the Longitude and Latitude from the geometry column
  expand_grid(years) %>% # Add suite of years to each observation
  rename(Long = Long,
         Lat = Lat,
         Elevation_M = Elev_M,
         Year = years) %>%
  dplyr::select(HUC8, Long, Lat, Year, Elevation_M) # Choose/Reorder columns

# Assign variables to each observation
source(here("1-data/preprocessing/1_preprocess_fx.R"))
final.Verde <- assignVariables_preprocessing(pts)

final_data.Verde <- final.Verde[,c(1:4,6:8,5,10:51)]

summary.Verde <- final_data.Verde %>%
  group_by(HUC8, Long, Lat) %>%
  summarise(meanBFI = mean(Predicted_BFI))

# Predictions -------------------------------------------------------------

xgb.statewide <- xgb.load(here("2-experiments/exp01_statewide-model/models/xgb.statewide"))

final_data.Verde$Predicted_BFI <- inv.logit(predict(object = xgb.statewide, newdata = as.matrix(final_data.Verde[, 5:50])))

write.csv(final_data.Verde, here("2-experiments/exp01_statewide-model/data/verde-pts_dataset.csv"))
write.csv(summary.Verde, here("2-experiments/exp01_statewide-model/data/verde_meanBFI.csv"))
