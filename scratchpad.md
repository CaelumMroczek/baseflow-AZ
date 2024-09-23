## 30 August 2024

-   produced and reworked huc8 precipitation and temperature data in the new project format
-   began implementing gridMET data in preprocessing
    -   Current issue: each day of the year has a `min value` and `max value` for pet
    -   Assumedly I should take the mean between the two?

## 31 August 2024

-   having issues accessing `climateR`, can't run `getGridMET()`
    -   need to figure out another way to access and clip gridMET data

## 2 September 2024

-   worked through this <https://tmieno2.github.io/R-as-GIS-for-Economists/gridMET.html> workflow to access gridMET data
    -   exactextractr ReadMe provides explanations on how to 'natively' calculate the coverage-weighted average of PET in each HUC8 basin
    -   Each gridMET cell has an associated fraction of coverage within each HUC8; so the sum of raster values within the polygon, accounting for coverage fraction is required
-   produces reference ET \~4 times larger than equivalent P

## 6 September 2024

-   adding preprocessing
    -   Changed USGS gage choice to only streams (removed canals, which could add to issues of impermeable surfaces)

## 19 September 2024

-   reworked preprocess_ET.R to produce TerraClimate AET data
    -   Assuming that we will be fine to use this dataset for baseflow estimation but not for water balance/recharge
-   preprocess_USGSgages.R
    -   sites[225,] - Santa Cruz River at Tucson, AZ - 09482500
        -   Has data prior to 1992 and after, causes issues with BaseFlowSeparation function due to formatting... may need to change by hand
    -   Building out streamgage dataset for Training Data

## 21 September 2024

-   Adjusted time frame for precip, temp, ET, USGS gauges to go through 2023
-   Edited annualUSGS_preprocessing function to filter out years w/ \<335 days recorded, BFI\<0/NaN then only include sites with \>10 yr period of record - Function now produces a dataframe of Site_Num, Year, BFI -\> 9932 observations
-   TO DO: build function to assign precip, temp, ET, elevation, spatial variables to each observation

## 22 September 2024

-   remove CO River sites from the USGS gages (9500 observations)
-   wrote assignVariables_preprocessing function
    -   assigns precip, temp, ET, elevation, spatial variables to each observation of annual_USGSsites
-   update preprocessing README
-   produced training dataset for XGBoost models

## 23 September 2024

-   Ran Statewide Model hyperparameter tuning over night (\~14.5 hours)
    -   optimal model chosen by minimizing RMSE

        | nrounds | max_depth | eta  | gamma | colsample_bytree | min_child_weight | subsample |
        |-----------|-----------|-----------|-----------|-----------|-----------|-----------|
        | 650     | 7         | 0.05 | 0.1   | 0.6              | 10               | 1         |

        : Hyper-parameters (Statewide Model)
-   Added quick linear regression to check general differnces... not commented
