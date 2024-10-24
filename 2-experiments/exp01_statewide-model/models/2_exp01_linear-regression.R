
model <- lm(BFI ~ .,
            data = trainingData)

summary(model)

# Make predictions on the training data
predictions <- predict(model, trainingData)

# Calculate MSE
mse_value <- mse(trainingData$BFI, predictions)

# Calculate RMSE
rmse_value <- rmse(trainingData$BFI, predictions)

# Calculate R-squared
r2_value <- summary(model)$r.squared

# Calculate PBIAS (Percent Bias)
pbias_value <- (sum(trainingData$BFI - predictions) / sum(trainingData$BFI)) * 100


results <- data.frame(Observed_BFI = trainingData$BFI, Predicted_BFI = predictions)

# Plot observed vs. predicted BFI
ggplot(data = results, mapping = aes(y = Observed_BFI, x = Predicted_BFI))+
  geom_point(alpha = 0.3,
             color = '#414141') +
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
