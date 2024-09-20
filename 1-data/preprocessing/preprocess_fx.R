site_calcs <- function(dataset){

  dataset <- as.data.frame(cbind(dataset, BFI = 0)) # Create BFI column in dataset
  errors <- c() # Initialize an empty vector to store error indices

  # Initialize progress bar with total rows in the dataset
  pb <- progress::progress_bar$new(total = nrow(dataset))

  for (i in 1:nrow(dataset)){
    # Retrieve site number for each row
    site_no <- as.character(dataset[i, 1])

    # Retrieve data from USGS stream data for each site number
    gauge <- dataRetrieval::readNWISdv(
      siteNumbers = toString(site_no),
      parameterCd = "00060",
      statCd = "00003",
      endDate = "2022-12-31"
    )

    # Remove missing values from the gauge data
    gauge <- na.omit(gauge)

    # If gauge data is not empty, perform baseflow separation
    if (nrow(gauge) != 0){
      bf <- EcoHydRology::BaseflowSeparation(gauge$X_00060_00003, passes = 3)

      BFsum <- sum(bf$bt)
      Tsum <- sum(bf$qft) + sum(bf$bt)
      bfi <- BFsum / Tsum

      dataset$BFI[i] <- bfi
    } else {
      errors <- append(errors, i) # Store the index of the error
    }

    # Update the progress bar for each iteration
    pb$tick()
  }

  # Return the updated dataset and error indices
  output <- list('dataset' = dataset, 'errors' = errors)
  return(output)
}
