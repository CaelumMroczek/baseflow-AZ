sites_init <- dataRetrieval::whatNWISsites(stateCd = "AZ", #Only sites in AZ
                            parameterCd = "00060",  #discharge
                            service="dv", #daily mean values
                            startDate = "1972-01-01") #everything starting 1972

sites <- filter(sites_init, site_tp_cd %in% c('ST')) #only sites that are a Stream
sites <- sites[,-c(1,4,7,8)] #remove unwanted columns
colnames(sites) = c('Site_Num', 'Station_Name', 'Latitude', 'Longitude')

#short term fix
sites <- sites[c(1:224,226:405),]


packageURL <- "https://cran.r-project.org/src/contrib/Archive/EcoHydRology/EcoHydRology_0.4.12.1.tar.gz"
install.packages(packageURL, repos=NULL, type="source")

USGSsites = site_calcs(sites)
