
usgs_gages <- read.csv(here("1-data/instrumented_all-predictors.csv"))

## Produce table with instrumented gauges used in study
## To be added to Supplemental Information

summary_df <- usgs_gages %>%
  group_by(Site_Num, HUC8, Lat, Long) %>%
  summarise(
    num_years_of_record = n(),
    years_of_record = list(sort(unique(Year)))
  ) %>%
  ungroup()

summary_df$years_of_record <- sapply(summary_df$years_of_record, toString)
write.csv(summary_df, here("1-data/instrumented_period-of-record.csv"), row.names = F)

