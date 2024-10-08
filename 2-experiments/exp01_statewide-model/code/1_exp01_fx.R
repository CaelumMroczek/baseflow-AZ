analysis.stats <- function(dataset) {
  model.stats <- caret::postResample(dataset$Predicted_BFI, dataset$BFI)

  results <- data.frame(
    "R2" = model.stats[[2]],
    "MSE" = model.stats[[1]] ^ 2,
    "RMSE" = model.stats[[1]],
    "MAE" = model.stats[[3]],
    "Nash-Sutcliffe" = hydroGOF::NSE(dataset$Predicted_BFI, dataset$BFI),
    "pbias" = hydroGOF::pbias(dataset$Predicted_BFI, dataset$BFI))

  return(results)
}
