## 30 August 2024
- produced and reworked huc8 precipitation and temperature data in the new project format
- began implementing gridMET data in preprocessing
    - Current issue: each day of the year has a `min value` and `max value` for pet
    - Assumedly I should take the mean between the two?

## 31 August 2024
- having issues accessing `climateR`, can't run `getGridMET()`
    -  need to figure out another way to access and clip gridMET data

## 2 September 2024
- worked through this <https://tmieno2.github.io/R-as-GIS-for-Economists/gridMET.html> workflow to access gridMET data
    - exactextractr ReadMe provides explanations on how to 'natively' calculate the coverage-weighted average of PET in each HUC8 basin
    - Each gridMET cell has an associated fraction of coverage within each HUC8; so the sum of raster values within the polygon, accounting for coverage fraction is required
- produces reference ET ~4 times larger than equivalent P

## 6 September 2024
- adding preprocessing
  - Changed USGS gage choice to only streams (removed canals, which could add to issues of impermeable surfaces)
