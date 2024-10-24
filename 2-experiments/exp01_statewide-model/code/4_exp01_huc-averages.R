# Read in artificial lat long points
# derived from 20 random points in each HUC on a stream line
pts.raw <- read.csv(here("1-data/ArtificialPoints_20241015.csv"))
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
pts_sf <- st_as_sf(pts.raw, coords = c("Longitude", "Latitude"), crs = 4326) # Assuming pts is in WGS84 (EPSG:4326)
pts_sf <- st_transform(pts_sf, crs = st_crs(huc8_shape)) # Transform pts_sf to the CRS of huc8_shape (which is Mercator)
huc8_sf <- st_as_sf(huc8_shape) # Convert huc8_shape to an sf object if it is not already
pts_with_huc8 <- st_join(pts_sf, huc8_sf)# Perform a spatial join to extract the HUC8 that each point is in

pts_with_huc8 <- st_transform(pts_with_huc8, crs = 4326) # Make pts_with_huc8 the same CRS as pts

pts <- pts_with_huc8 %>%
  mutate(Longitude = st_coordinates(.)[, 1],
         Latitude = st_coordinates(.)[, 2]) %>% # Extract the Longitude and Latitude from the geometry column
  expand_grid(years) %>% # Add suite of years to each observation
  rename(Long = Longitude,
         Lat = Latitude,
         Elevation_M = Elev_m,
         Year = years) %>%
  dplyr::select(HUC8, Long, Lat, Year, Elevation_M) # Choose/Reorder columns

# Assign variables to each observation
source(here("1-data/preprocessing/1_preprocess_fx.R"))
final <- assignVariables_preprocessing(pts)

final_data <- final[,c(1:4,6:8,5,10:51)]
#write.csv(final_data, here("2-experiments/exp01_statewide-model/data/artificial-pts_dataset.csv"))


# Predictions -------------------------------------------------------------

xgb.statewide <- xgb.load(here("2-experiments/exp01_statewide-model/models/xgb.statewide"))

final_data$Predicted_BFI <- inv.logit(predict(object = xgb.statewide, newdata = as.matrix(final_data[, 5:50])))

huc_avg <- final_data %>%
  group_by(HUC8) %>%
  summarise(BFI = mean(Predicted_BFI))

write.csv(huc_avg, here("2-experiments/exp01_statewide-model/models/huc8_meanBFI_19912020.csv"))
