site_calcs <- function(dataset){

  dataset = as.data.frame(cbind(dataset, BFI = 0)) #Create BFI column in dataset
  errors = c()

  pb <- progress_bar$new(total = 100)

  for (i in 1:nrow(dataset)){
    pb$tick(0)
    site_no <- as.character(dataset[i,][1]) #retrieve site number for every site

    gauge <- dataRetrieval::readNWISdv(siteNumbers = toString(site_no),
                        parameterCd = "00060", statCd = "00003",
                        startDate = "1972-01-01",
                        endDate = "2022-12-31") #Retrieves data from USGS stream data based on site number

    gauge <- na.omit(gauge)

    if (nrow(gauge)!=0){
      bf <- EcoHydRology::BaseflowSeparation(gauge$X_00060_00003,passes = 3)#conduct baseflow separation

      BFsum <- sum(bf$bt)
      Tsum <- sum(bf$qft) + sum(bf$bt)
      bfi <- BFsum/Tsum

      dataset$BFI[i] = bfi
    } else{
      errors = append(errors,i)
    }
    pb$tick()
  }

  output = list('dataset' = dataset, 'errors' = errors)
  return(output)

}
