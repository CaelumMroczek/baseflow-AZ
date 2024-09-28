#################################################
## Training Hyperparameters for Basin&Range XGBoost model
## to predict BFI for streamgages in Basin&Range region
#################################################

training.Basin <- read.csv(here("2-experiments/exp_regional-models/data/instrumented.Basin_all-predictors.csv"))

BFI.log.Basin <- logit(training.Basin$BFI)

tune_grid <- expand.grid(
  nrounds = seq(from = 500, to = 1000, by = 50),
  eta = c(0.025, 0.05, 0.075, 0.1),
  max_depth = c(3, 4, 5, 6, 7),
  gamma = c(0, 0.025, 0.05, 0.075, 0.1),
  colsample_bytree = c(0.6, 0.8, 1),
  min_child_weight = c(1, 3, 5, 10),
  subsample = c(0.5, 1)
)

start.time <- Sys.time()
xgb_caret <- train(x = training.Basin[,7:52],
                   y = BFI.log.Basin,
                   method = "xgbTree",
                   trControl = trainControl(
                     method = "cv",
                     number = 5,
                     verboseIter = TRUE),
                   tuneGrid = tune_grid,
                   verbosity = 0)

xgb_caret$bestTune
end.time <- Sys.time()
time.taken <- round(end.time - start.time, 2)
time.taken

#################################################
## 7754 samples
## 46 predictor
## Time Taken: xxxx hours

## Hyperparameter Tuning

#################################################

#################################################
## Training Hyperparameters for CO Plateau XGBoost model
## to predict BFI for streamgages in CO Plateau region
#################################################

training.Plateau <- read.csv(here("2-experiments/exp_regional-models/data/instrumented.Plateau_all-predictors.csv"))

BFI.log.Plateau <- logit(training.Plateau$BFI)

tune_grid <- expand.grid(
  nrounds = seq(from = 500, to = 1000, by = 50),
  eta = c(0.025, 0.05, 0.075, 0.1),
  max_depth = c(3, 4, 5, 6, 7),
  gamma = c(0, 0.025, 0.05, 0.075, 0.1),
  colsample_bytree = c(0.6, 0.8, 1),
  min_child_weight = c(1, 3, 5, 10),
  subsample = c(0.5, 1)
)

start.time <- Sys.time()
xgb_caret <- train(x = training.Plateau[,7:52],
                   y = BFI.log.Plateau,
                   method = "xgbTree",
                   trControl = trainControl(
                     method = "cv",
                     number = 5,
                     verboseIter = TRUE),
                   tuneGrid = tune_grid,
                   verbosity = 0)

xgb_caret$bestTune
end.time <- Sys.time()
time.taken <- round(end.time - start.time, 2)
time.taken

#################################################
## 1743 samples
## 46 predictor
## Time Taken: xxxx hours

## Hyperparameter Tuning
