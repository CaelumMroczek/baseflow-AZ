# Test Script
##

az <- aoi_get(state = "AZ")
huc <- st_sf(st_read(here("1-data/raw/shapefile/huc8.shp")))


et <- getGridMET(AOI = az,
                varname = "etr",
                startDate = "2015-01-01",
                endDate = "2015-12-31")


precip <- getGridMET(AOI = az,
                varname = "pr",
                startDate = "2015-01-01",
                endDate = "2015-12-31")

summed_values <- terra::app(et$daily_mean_reference_evapotranspiration_alfalfa, sum)
summed_values_2 <- terra::app(precip$precipitation_amount, sum)


z <- exactextractr::exact_extract(summed_values, huc, fun = "mean", append_cols = "HUC8")
z2 <- exactextractr::exact_extract(summed_values_2, huc, fun = "mean")

z3 <- cbind(z,z2)


ggplot(z3_long, aes(x = HUC8, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "2015: gridMET ET and gridMET Precipitation     ",
       x = "HUC8",
       y = "mm") +
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        legend.text = element_blank(),
        legend.box.background = element_blank(),
        legend.title = element_blank())
