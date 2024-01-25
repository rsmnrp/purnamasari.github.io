# resalecars-plumber.R

library(sparklyr); library(dplyr); library(plumber)

sc <- spark_connect(master = "local", version = "3.4.0")

spark_model <- ml_load(sc, path = "spark_pipeline_cars")

#* @post /predict
function(TYPE, TRANSMISSION, COE_LISTED, NUM_PAST_OWNERS, BRAND_CATEGORY, MILEAGE_KM, CURB_WEIGHT_KG, OMV, ENGINE_CAPACITY_CC, DAYS_OF_COE_LEFT, FEATURE_COUNT, ACCESSORIES_COUNT, AGE_SINCE_MANUFACTURED, DAYS_SINCE_REGISTERED) {
  new_data <- data.frame(
    TYPE = as.character(TYPE),
    TRANSMISSION = as.character(TRANSMISSION),
    COE_LISTED = as.double(COE_LISTED),
    NUM_PAST_OWNERS = as.integer(NUM_PAST_OWNERS),
    BRAND_CATEGORY = as.character(BRAND_CATEGORY),
    MILEAGE_KM = as.double(MILEAGE_KM),
    CURB_WEIGHT_KG = as.double(CURB_WEIGHT_KG),
    OMV = as.double(OMV),
    ENGINE_CAPACITY_CC = as.double(ENGINE_CAPACITY_CC),
    DAYS_OF_COE_LEFT = as.double(DAYS_OF_COE_LEFT),
    FEATURE_COUNT = as.double(FEATURE_COUNT),
    ACCESSORIES_COUNT = as.integer(ACCESSORIES_COUNT),
    AGE_SINCE_MANUFACTURED = as.double(AGE_SINCE_MANUFACTURED),
    DAYS_SINCE_REGISTERED = as.double(DAYS_SINCE_REGISTERED),
    PRICE = NA
  )
  
  new_data_r <- copy_to(sc, new_data, overwrite = TRUE)
  
  ml_transform(spark_model, new_data_r) |>
    pull(prediction)
}