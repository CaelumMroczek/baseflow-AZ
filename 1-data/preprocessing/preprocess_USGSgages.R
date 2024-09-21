#################################################
## USGS streamgage BFI for AZ gauges
## Data source: USGS
## Timeframe: 1901-2023
#################################################

# Get discharge data for all AZ streamgages
sites_init <- dataRetrieval::whatNWISsites(stateCd = "AZ", #Only sites in AZ
                            parameterCd = "00060",  #discharge
                            service="dv")

# Preprocessing retrieved streamgages
sites <- filter(sites_init, site_tp_cd %in% c('ST')) #only sites that are a Stream
sites <- sites[,-c(1,4,7,8)] #remove unwanted columns
colnames(sites) = c('Site_Num', 'Station_Name', 'Latitude', 'Longitude')
sites <- sites[c(1:254,256:478),] #hard code remove specific problem site

# Run annualUSGS_preprocessing fx from preprocess_fx.R to get filtered annual BFI for gauged sites
USGSsites = annualUSGS_preprocessing(sites)
yearly_bfi <- USGSsites$results

# Add lat/long to each site
for (i in 1:nrow(yearly_bfi)){


}

# Run

