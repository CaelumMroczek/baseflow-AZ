## 30 August 2024
- produced and reworked huc8 precipitation and temperature data in the new project format
- began implementing gridMET data in preprocessing
  - Current issue: each day of the year has a `min value` and `max value` for pet
  - Assumedly I should take the mean between the two?

## 31 August 2024
- having issues accessing `climateR`, can't run `getGridMET()`
  - need to figure out another way to access and clip gridMET data
