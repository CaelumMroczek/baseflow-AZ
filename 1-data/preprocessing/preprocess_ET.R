## HUC8 Mean Annual ET
#Data source: GridMET
#Timeframe: 1979-2022 (years before 1958 replaced with basin mean over period of record)
#Unit: mm

here::i_am("1-data/preprocessing/preprocess_ET.R")

#Set download folder
prism::prism_set_dl_dir(here::here("1-data/raw/PRISM"))

#AZ state shapefile
AZ <- AOI::aoi_get(state = "AZ")

#Format to pull produce raster:
ppt_2013<- prism::pd_to_file(prism::prism_archive_subset("ppt", "annual", years = 2013))
ppt_2013_rast <- raster::raster(ppt_2013)

#GW Basins shapefile
huc8_shape <- raster::shapefile(here::here("1-data/raw/shapefile/huc8.shp"))

#Set CRS to the same
huc8_shape <- spTransform(huc8_shape, raster::crs(ppt_2013_rast))

huc8_annualET <- data.frame(HUC8 = huc8_shape$HUC8) #dataframe with HUC8 numbers in order

####################################################################################################
##--Following this: https://tmieno2.github.io/R-as-GIS-for-Economists/gridMET.html--##

#gridMET etr = grass reference crop; pet = alfalfa reference crop
downloader::download(
  url = "http://www.northwestknowledge.net/metdata/data/pet_2015.nc",
  destfile = "1-data/raw/gridMET/pet_2015.nc",
  mode = 'wb'
)

pet_2015 <- terra::rast("1-data/raw/gridMET/pet_2015.nc")
huc8_shape <- spTransform(huc8_shape, crs(pet_2015))


####################
pet_by_huc <-
  exact_extract(pet_2015, huc8_shape, progress = FALSE) %>%
  rbindlist(idcol = "rowid")

pet_by_huc <-
  #--- wide to long ---#
  melt(pet_by_huc, id.var = c("rowid", "coverage_fraction")) %>%
  #--- remove observations with NA values ---#
  .[!is.na(value), ]


pet_by_id <- pet_by_huc %>%
  group_by(rowid,variable) %>%
  summarise(pet_aw = (sum(value * coverage_fraction)) / (sum(coverage_fraction)))

pet <- pet_by_id %>%
  group_by(rowid) %>%
  summarise(pet_anual = sum(pet_aw))


pet_by_id <- pet_by_huc %>%
  #--- convert from character to numeric  ---#
  mutate(rowid = as.numeric(rowid)) %>%
  #--- group summary ---#
  group_by(rowid) %>%
  summarise(pet_aw = (sum(value * coverage_fraction)) / (sum(coverage_fraction)))

####################################################################################################
huc8_annualET <- cbind(huc8_annualET, test)

##############
for (year in 1990:2022){ #only goes to 1979

  ##########
  d <- climateR::getGridMET(AZ, #shape of AZ
                  varname = "pet", #actual ET
                  startDate = paste(year,"01","01",sep = "-"),
                  endDate = paste(year,"12","31", sep = "-"))


  #calculate mean annual ET
  summed_values <- terra::app(d$daily_mean_reference_evapotranspiration_grass, sum)

  z <- exact_extract(summed_values, GWBasins, fun = "mean", append_cols = "BASIN_NAME")

  z <- z %>%
    rename_with(~paste0(as.character(year)), mean)

  GW_annualET <- cbind(GW_annualET,z[2])
}

#Produce mean annual ET for each basin across available period of record of gridMET data (1958-2022) to be the ET values pre-1979

GWMean <- rowMeans(as.matrix(GW_annualET[,2:66]))
GW_annualET <- cbind(GW_annualET,GWMean)

# Make columns for 1901-1957
years <- data.frame(matrix(ncol = length(1901:1957), nrow = nrow(GW_annualET)))
colnames(years) <- as.character(1901:1957)

GW_annualET <- cbind(years, GW_annualET)

# Replace all NA from 1901-1957 with mean basin ET
for (i in 1901:1957){
  GW_annualET[, as.character(i)] <- GW_annualET[,124]
}

# Reorder columns
GW_annualET <- GW_annualET[,c(58,1:57,59:123)]

#write_csv(GW_annualET, here("data/variables/GW_ET_ANNUAL.csv"))
