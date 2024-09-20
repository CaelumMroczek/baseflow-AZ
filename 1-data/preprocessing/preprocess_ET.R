## HUC8 Mean Annual Actual Evapotranspiration (AET)
## Data source: TerraClimate
## Timeframe: 1958-2022 (years before 1958 replaced with basin mean over period of record)
## Unit: mm

# Load Arizona shapefile
AZ <- aoi_get(state = "AZ")

# Load Groundwater Basins shapefile
HUC8_basins <- st_sf(st_read(here("1-data/raw/shapefile/huc8.shp")))

# Initialize dataframe for groundwater basin mean annual ET
HUC_annualET <- data.frame(HUC8 = HUC8_basins$HUC8)

# Loop through available TerraClimate data (1958-2022)
for (year in 1958:2022) {

  # Get TerraClimate actual evapotranspiration (aet) data for Arizona
  d <- getTerraClim(
    AZ, # Arizona shapefile
    varname = "aet", # actual ET
    startDate = paste(year, "01", "01", sep = "-"),
    endDate = paste(year, "12", "31", sep = "-")
  )

  # Calculate total ET for the year
  summed_values <- terra::app(d$aet, sum)

  # Extract the mean ET for each groundwater basin
  z <- exact_extract(summed_values, HUC8_basins, fun = "mean", append_cols = "HUC8")

  # Rename the mean column to the corresponding year
  z <- z %>% rename_with(~paste0(as.character(year)), mean)

  # Append the year’s mean ET values to the dataframe
  HUC_annualET <- cbind(HUC_annualET, z[2])
}

# Calculate the mean annual ET for each basin over 1958-2022
HUCMean <- rowMeans(as.matrix(HUC_annualET[, 2:66]))
HUC_annualET <- cbind(HUC_annualET, HUCMean)

# Initialize columns for years 1901-1957
years <- data.frame(matrix(ncol = length(1901:1957), nrow = nrow(HUC_annualET)))
colnames(years) <- as.character(1901:1957)

# Append the 1901-1957 columns to the dataframe
HUC_annualET <- cbind(years, HUC_annualET)

# Replace NA values for 1901-1957 with the mean basin ET (HUCMean)
for (i in 1901:1957) {
  HUC_annualET[, as.character(i)] <- HUC_annualET[, "HUCMean"]
}

# Reorder the columns to have 1901-2022 sequentially
HUC_annualET <- HUC_annualET[, c(58, 1:57, 59:123)]

#Write AET file to 1-data
#write_csv(HUC_annualET, here("1-data/huc8_aet.csv"))
