
usgs_gages <- read.csv(here("1-data/instrumented_all-predictors.csv"))

# Create the summarized dataframe
summary_df <- usgs_gages %>%
  group_by(Site_Num, HUC8, Lat, Long) %>%
  summarise(
    num_years_of_record = n(),
    years_of_record = list(sort(unique(Year)))
  ) %>%
  ungroup()

# View the result
print(summary_df)

# Optionally, save the dataframe to a CSV file
# write.csv(summary_df, "summary_output.csv", row.names = FALSE)

