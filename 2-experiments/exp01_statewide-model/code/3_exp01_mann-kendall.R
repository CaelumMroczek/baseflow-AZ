# Mann-Kendall Trend Test -------------------------------------------------

## Kendall Rank Correlation
## BFI and Year

usgs_gages <- read.csv(here("1-data/instrumented_all-predictors.csv"))

# Function to perform Kendall Rank test on each streamgage's BFI data
perform_mann_kendall <- function(data) {
  # Perform Kendall Rank test on BFI
  test_result <- MannKendall(data$BFI)

  # Extract Kendall's tau and p-value
  tau <- test_result$tau
  p_value <- test_result$sl

  return(data.frame(tau = tau, p_value = p_value))
}

# Apply the Kendall Rank test to each streamgage over its full period of record
mann_kendall_results <- usgs_gages %>%
  group_by(Site_Num, HUC8, Lat, Long) %>%
  summarise(mk_result = list(perform_mann_kendall(pick(BFI)))) %>%
  unnest(cols = c(mk_result)) %>%
  ungroup()

# Indicate is the result is significant [1 = yes, 0 = no]
mann_kendall_results$sig_05 <- ifelse(mann_kendall_results$p_value < 0.05, 1, 0)

# Indicate trend [1 = positive, 0 = negative]
mann_kendall_results$trend <- ifelse(mann_kendall_results$tau > 0, 1, 0)

write.csv(mann_kendall_results, here("2-experiments/exp01_statewide-model/data/mann_kendall_results.csv"), row.names = FALSE)

# Kendall Rank Correlation Test -------------------------------------------------

## Kendall Rank Correlation
## BFI and Year

usgs_gages <- read.csv(here("1-data/instrumented_all-predictors.csv"))

# Function to perform Kendall Rank test on each streamgage's BFI data
perform_kendall_rank <- function(data) {
  # Perform Kendall Rank test on BFI
  test_result <- Kendall(data$Year, data$BFI)

  # Extract Kendall's tau and p-value
  tau <- test_result$tau
  p_value <- test_result$sl

  return(data.frame(tau = tau, p_value = p_value))
}

# Apply the Kendall Rank test to each streamgage over its full period of record
year_kendall_results <- instrumented_all_predictors %>%
  group_by(Site_Num, HUC8, Lat, Long) %>%
  summarise(mk_result = list(perform_kendall_rank(pick(Year, BFI)))) %>%
  unnest(cols = c(mk_result)) %>%
  ungroup()


# Kendall Rank Correlation Test -------------------------------------------------

## Kendall Rank Correlation
## BFI and Year

usgs_gages <- read.csv(here("1-data/instrumented_all-predictors.csv"))

# Function to perform Kendall Rank test on each streamgage's BFI data
perform_kendall_rank <- function(data) {
  # Perform Kendall Rank test on BFI
  test_result <- Kendall(data$Year, data$BFI)

  # Extract Kendall's tau and p-value
  tau <- test_result$tau
  p_value <- test_result$sl

  return(data.frame(tau = tau, p_value = p_value))
}

# Apply the Kendall Rank test to each streamgage over its full period of record
year_kendall_results <- instrumented_all_predictors %>%
  group_by(Site_Num, HUC8, Lat, Long) %>%
  summarise(mk_result = list(perform_kendall_rank(pick(Year, BFI)))) %>%
  unnest(cols = c(mk_result)) %>%
  ungroup()
