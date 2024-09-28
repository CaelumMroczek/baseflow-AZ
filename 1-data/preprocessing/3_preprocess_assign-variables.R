#################################################
## Assigning physiographic region to instrumented streamgage dataset
#################################################

regional_inst.data <- read.csv(here("1-data/raw/instrumented_region.csv"))

streamgage_regional.data <- regional_inst.data %>%
  distinct(Site_Num, .keep_all = TRUE) #unique usgs streamgages only
streamgage_regional.data <- streamgage_regional.data[,c(1:4,6)] #remove Year col

#write.csv(streamgage_regional.data, here("1-data/instrumented_regions.csv"))

#################################################
## Creating new datasets of training data for each region
#################################################
regions <- read.csv(here("1-data/instrumented_regions.csv"))
instrumented <- read.csv(here("1-data/instrumented_all-predictors.csv"))

data.regional <- instrumented %>%
  left_join(regions %>% dplyr::select(Site_Num, PROVINCE), by = "Site_Num") #add PROVINCE column to dataset

region.Basin <- which(data.regional$PROVINCE == "BASIN AND RANGE") #which indices are in B&R
region.Plateau <- which(data.regional$PROVINCE == "COLORADO PLATEAUS")

data.Basin <- instrumented[region.Basin,]
data.Plateau <- instrumented[region.Plateau,]

write.csv(data.Basin, here("1-data/instrumented.Basin_all-predictors.csv"), row.names = FALSE)
write.csv(data.Plateau, here("1-data/instrumented.Plateau_all-predictors.csv"), row.names = FALSE)
