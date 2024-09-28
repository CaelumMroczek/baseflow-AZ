analysis.stats <- function(dataset) {
  model.stats <- postResample(dataset$Predicted_BFI, dataset$BFI)

  results <- data.frame(
    "R2" = model.stats[[2]],
    "MSE" = model.stats[[1]] ^ 2,
    "RMSE" = model.stats[[1]],
    "MAE" = model.stats[[3]],
    "Nash-Sutcliffe" = NSE(dataset$Predicted_BFI, dataset$BFI),
    "pbias" = pbias(dataset$Predicted_BFI, dataset$BFI))

  return(results)
}
