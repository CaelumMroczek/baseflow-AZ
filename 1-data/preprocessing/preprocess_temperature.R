## HUC8 Mean Temperature
## Data source: PRISM
## Timeframe: 1901-2022
## Unit: degrees C

#Set download folder
prism_set_dl_dir(here("1-data/raw/PRISM"))

#Download PRISM data
get_prism_annual("tmean", years = 1901:2022, keepZip = FALSE)

#Format to pull produce raster:
ppt_2013<- pd_to_file(prism_archive_subset("ppt", "annual", years = 2013))
ppt_2013_rast <- raster(ppt_2013)

#HUC8 shapefile
huc8_shape <- shapefile(here("1-data/raw/shapefile/huc8.shp"))

#Set CRS to the same
huc8_shape <- spTransform(huc8_shape, crs(ppt_2013_rast))

#Initialize precip dataframe
num_years <- length(1901:2022)
num_HUCs <- length(exact_extract(ppt_2013_rast, huc8_shape, fun = "mean"))

huc8_temp <- data.frame(matrix(nrow = num_HUCs, ncol = num_years+1))
huc8_temp[,1] <-  huc8_shape$HUC8

colnames(huc8_temp) <- c("HUC8", as.character(1901:2022))

#Assign annual precip to each HUC8 for period of record
count <- 1 #initialize

for(i in 1901:2022){ #period of record
  count <- count+1

  rast_file <- pd_to_file(prism_archive_subset("tmean", "annual", years = i)) #read raster filename
  tmp_rast <- raster(rast_file) #create raster

  #produce HUC means for that raster
  tmp_mean <- exact_extract(tmp_rast, huc8_shape, fun = "mean")

  huc8_temp[,count] <- round(tmp_mean,2) #input means to dataframe
}

#Write precip file to 1-data
#write_csv(huc8_temp, here("1-data/huc8_temperature.csv"))
