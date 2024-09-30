#################################################
## Training statewide XGBoost model to predict BFI
## for Colorado Plateau region (AZ)
#################################################

trainingData <- read.csv(here("2-experiments/exp02_regional-models/data/instrumented.Plateau_all-predictors.csv"))

# observed BFI (log transformed to keep values between 0-1)
trainingData$BFI.log <- logit(trainingData$BFI)

# Tuned hyper-parameters
tune_grid <- list(
  eta = 0.025,
  max_depth = 5,
  gamma = 0.075,
  colsample_bytree = 0.8,
  min_child_weight = 1,
  subsample = 0.5)

# Create 10-fold cross-validation indices
num_folds <- 10
fold_indices <- createFolds(trainingData$HUC8, k = num_folds)

# Initialize an empty dataframe to store results from all folds
results_df <- data.frame()

#################################################
## Train the model
## 10-fold cross validation
#################################################

for (fold in 1:num_folds) {
  # Get the indices for the current fold
  fold_index <- fold_indices[[fold]]

  # Split the data into training and testing sets
  training <- trainingData[-fold_index, ]
  testing <- trainingData[fold_index, ]

  # Train an xgboost model on the training set
  xgb.model <- xgboost(
    nrounds = 550,
    data = as.matrix(training[, 7:52]),
    label = training$BFI.log,
    params = tune_grid,
    verbose = 0
  )

  # Make predictions on the testing set
  predictions <- predict(xgb.model, newdata = as.matrix(testing[, 7:52]))
  predictions <- inv.logit(predictions)

  # Store the results with testing data and the predictions
  results_fold <- cbind(testing, Predicted_BFI = predictions)

  # Combine the results from each fold into one dataframe
  results_df <- bind_rows(results_df, results_fold)

  cat("Completed fold", fold, "/", num_folds, "\n")
}

# Save Model
xgb.save(xgb.model, here("2-experiments/exp02_regional-models/models/xgb.plateau"))

# Save Results dataframe
write.csv(results_df, here("2-experiments/exp02_regional-models/data/plateau-model_results.csv"), row.names = FALSE)

xgb.plot.importance(xgb.importance(model = xgb.model), rel_to_first = TRUE, top_n = 10)

#################################################
## Goodness of Fit Statistics
#################################################
stats <- postResample(results_df$Predicted_BFI,results_df$BFI)

mse <- stats[[1]]^2
nash_sutcliffe <- NSE(results_df$Predicted_BFI, results_df$BFI)
pbias <- pbias(results_df$Predicted_BFI, results_df$BFI)

#################################################
## Plotting Actual vs. Observed
#################################################
ggplot(data = results_df, mapping = aes(y = BFI, x = Predicted_BFI))+
  geom_point(alpha = 0.3,
             color = '#414141') +
  geom_smooth(method = "lm",
              linetype = "dashed",
              color = 'black',
              linewidth = .75,
              se=FALSE,
              fullrange=TRUE) +
  geom_abline(slope = 1,
              intercept =  0,
              color = "black",
              linewidth = 0.75) +
  theme_few() +
  theme(text=element_text(size=16, family = "Helvetica"),
        axis.title.y = element_text(size = 16, face = "bold"),
        axis.title.x = element_text(size = 16, face = "bold"),
        axis.ticks.length = unit(.1,'cm'),
        axis.ticks = element_line(size = 0.5),
        plot.margin = margin(1, 1, 1, 1, "cm"),
        panel.border = element_rect(colour = "black", fill=NA, linewidth=1)) +
  scale_x_continuous(breaks = c(0,0.25,0.5,0.75,1),
                     labels = c("", "0.25", "0.5", "0.75", "1"),
                     expand = c(0, 0), limits = c(0, 1)) +
  scale_y_continuous(breaks = c(0,0.25,0.5,0.75,1),
                     labels = c("0", "0.25", "0.5", "0.75", "1"),
                     expand = c(0, 0), limits = c(0, 1)) +
  labs(y = "Observed BFI",
       x = "Predicted BFI")
