---
output:
  pdf_document: default
  html_document: default
---
# Models

## Hyper-parameter Tuning

1.  Regional Model - Basin & Range

    -   Model to predict BFI trained on Basin & Range training dataset
    -   optimal model chosen by minimizing RMSE

| nrounds | max_depth | eta   | gamma | colsample_bytree | min_child_weight | subsample |
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| 1000    | 6         | 0.025 | 0     | 0.8              | 5                | 1         |

2.  Regional Model - Colorado Plateau

    -   Model to predict BFI trained on Colorado Plateau training dataset
    -   optimal model chosen by minimizing RMSE

| nrounds | max_depth | eta   | gamma | colsample_bytree | min_child_weight | subsample |
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| 550     | 5         | 0.025 | 0.075 | 0.8              | 1                | 0.5       |

## Model Statistics

1.  Regional Model - Basin & Range

| R2     | MSE    | RMSE   | MAE   | Nash-Sutcliffe | pbias |
|--------|--------|--------|-------|----------------|-------|
| 0.7553 | 0.0173 | 0.1314 | 0.084 | 0.7471         | -6    |

2.  Regional Model - Colorado Plateau

| R2     | MSE    | RMSE   | MAE    | Nash-Sutcliffe | pbias |
|--------|--------|--------|--------|----------------|-------|
| 0.8183 | 0.0123 | 0.1108 | 0.0782 | 0.8149         | -3.7  |

3.  Statewide Model - Basin & Range

| R2     | MSE    | RMSE   | MAE    | Nash-Sutcliffe | pbias |
|--------|--------|--------|--------|----------------|-------|
| 0.7479 | 0.0179 | 0.1336 | 0.0895 | 0.7385         | -6.2  |

4.  Statewide Model - Colorado Plateau 

| R2     | MSE    | RMSE   | MAE    | Nash-Sutcliffe | pbias |
|--------|--------|--------|--------|----------------|-------|
| 0.8155 | 0.0125 | 0.1118 | 0.0789 | 0.8116         | -34   |
