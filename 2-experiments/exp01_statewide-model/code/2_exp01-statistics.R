#################################################
## Statistics of statewide XGBoost model
## observed vs predicted
#################################################

# Load model and model result dataframe
xgb.statewide <- xgboost::xgb.load(here::here("2-experiments/exp01_statewide-model/models/xgb.statewide"))

model.results <- read.csv(here::here("2-experiments/exp01_statewide-model/data/statewide-model_results.csv"))


#################################################
## Statistics of statewide model - ALL DATA
#################################################

xgb.plot.importance(xgb.importance(model = xgb.statewide), rel_to_first = TRUE, top_n = 10)

# Goodness of Fit Stats
data.full <- model.results

analysis.stats(data.full)

# Actual-Predicted Plot
ggplot(data = data.full, mapping = aes(y = BFI, x = Predicted_BFI))+
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

#################################################
## Statistics of statewide model - Physiographic regions
#################################################

regions <- read.csv(here("1-data/instrumented_regions.csv"))

data.regional <- model.results %>%
  left_join(regions %>% dplyr::select(Site_Num, PROVINCE), by = "Site_Num")

region.Basin <- which(data.regional$PROVINCE == "BASIN AND RANGE")
region.Plateau <- which(data.regional$PROVINCE == "COLORADO PLATEAUS")

# Basin&Range Goodness of Fit Stats
analysis.stats(data.regional[region.Basin,])

# Colorado Plateau Goodness of Fit Stats
analysis.stats(data.regional[region.Plateau,])

# Actual-Predicted Plot
ggplot(data = data.regional, mapping = aes(y = BFI, x = Predicted_BFI, color = PROVINCE))+
  geom_point(alpha = 0.3) +
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

#################################################
## Statistics of statewide model - Precipitation
#################################################
precip.low <- which(data.full$Precip_MM < median(data.full$Precip_MM)) #streamgages with precipitation below median
precip.high <- which(data.full$Precip_MM > median(data.full$Precip_MM)) #streamgages with precipitation above median

# low precip Goodness of Fit Stats
analysis.stats(data.full[precip.low,])

# high precip Plateau Goodness of Fit Stats
analysis.stats(data.full[precip.high,])

