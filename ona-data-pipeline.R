

## ONA Survey ETL


library(dplyr)
library(shiny)
library(shinyWidgets)
library(DT)
library(tibble)
library(lubridate)
library(rmarkdown)
library(leaflet)
library(tidyr)
library(ggplot2)
library(stringr)
library(gt)
library(readr)
library(shinydashboard)
library(dashboardthemes)
library(plotly)

## Read in Data ##

equip_info_historical <- read_csv(file = "https://ona.io/pacafenet/99874/460026/download.csv?data-type=dataset",
                                  na = c("n/a", "")) %>%  
  rename(latitude = `_equip_location_latitude`,
         longitude = `_equip_location_longitude`,
         submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>% 
  rename_all(~gsub(pattern = "-", replacement = "_", x = .)) %>% 
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>% 
  select(equip_id, manufacturer, facility, equip_type, equip_type_other, lab_level, lab_level_is_other, ownership_type, ownership_type_is_other,
         waranty_status, equipment_status, equipment_purchase_status, manual_availability, manufacture_date, freq_service_maintenance, freq_calibration,
         date_active, engineering_service_provider, engineering_service_provider_email_address, most_recent_calibration, most_recent_maintenance,
         latitude, longitude, submitted_by, submission_time) %>% 
  arrange(equip_id, desc(submission_time)) %>%  
  group_by(equip_id) %>% 
  # These if else's seem to account for when things are left blank, good idea, think all are required right now
  mutate(manufacturer = if_else(condition = is.na(manufacturer),
                                true = lead(manufacturer),
                                false = manufacturer),
         facility = if_else(condition = is.na(facility),
                            true = lead(facility),
                            false = facility),
         equip_type = if_else(condition = is.na(equip_type),
                              true = lead(equip_type),
                              false = equip_type),
         equip_type_other = if_else(condition = is.na(equip_type_other),
                                    true = lead(equip_type_other),
                                    false = equip_type_other),
         lab_level = if_else(condition = is.na(lab_level),
                             true = lead(lab_level),
                             false = lab_level),
         lab_level_is_other = if_else(condition = is.na(lab_level_is_other),
                                      true = lead(lab_level_is_other),
                                      false = lab_level_is_other),
         ownership_type = if_else(condition = is.na(ownership_type),
                                  true = lead(ownership_type),
                                  false = ownership_type),
         ownership_type_is_other = if_else(condition = is.na(ownership_type_is_other),
                                           true = lead(ownership_type_is_other),
                                           false = ownership_type_is_other),
         waranty_status = if_else(condition = is.na(waranty_status),
                                  true = lead(waranty_status),
                                  false = waranty_status),
         equipment_status = if_else(condition = is.na(equipment_status),
                                    true = lead(equipment_status),
                                    false = equipment_status),
         equipment_purchase_status = if_else(condition = is.na(equipment_purchase_status),
                                             true = lead(equipment_purchase_status),
                                             false = equipment_purchase_status),
         manual_availability = if_else(condition = is.na(manual_availability),
                                       true = lead(manual_availability),
                                       false = manual_availability),
         manufacture_date = if_else(condition = is.na(manufacture_date),
                                    true = lead(manufacture_date),
                                    false = manufacture_date),
         freq_service_maintenance = if_else(condition = is.na(freq_service_maintenance),
                                            true = lead(freq_service_maintenance),
                                            false = freq_service_maintenance),
         freq_calibration = if_else(condition = is.na(freq_calibration),
                                    true = lead(freq_calibration),
                                    false = freq_calibration),
         date_active = if_else(condition = is.na(date_active),
                               true = lead(date_active),
                               false = date_active),
         engineering_service_provider = if_else(condition = is.na(engineering_service_provider),
                                                true = lead(engineering_service_provider),
                                                false = engineering_service_provider),
         engineering_service_provider_email_address = if_else(condition = is.na(engineering_service_provider_email_address),
                                                              true = lead(engineering_service_provider_email_address),
                                                              false = engineering_service_provider_email_address),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration),
                                           true = lead(most_recent_calibration),
                                           false = most_recent_calibration),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance),
                                           true = lead(most_recent_maintenance),
                                           false = most_recent_maintenance),
         latitude = if_else(condition = is.na(latitude),
                            true = lead(latitude),
                            false = latitude),
         longitude = if_else(condition = is.na(longitude),
                             true = lead(longitude),
                             false = longitude),
         submitted_by = if_else(condition = is.na(submitted_by),
                                true = lead(submitted_by),
                                false = submitted_by)) %>% 
  ungroup() %>% 
  mutate(equip_id = as.character(equip_id))

equip_info_current <- equip_info_historical

# Column lookup - activities

activity_equip_info_lookup <- tibble(
  equipment_attribute_to_alter = c("date_active__yyyy_mm_dd",
                                   "engineering_service_provider",
                                   "engineering_service_provider_email_addre",
                                   "equipment_latitude",
                                   "equipment_longitude",
                                   "equipment_purchase_status",
                                   "equipment_status",
                                   "equipment_type",
                                   "facility",
                                   "frequency_calibration__enter_number",
                                   "frequency_service_maintenance__enter_num",
                                   "is_the_equipment_s_user_manual_available",
                                   "lab_level",
                                   "manufacture_date",
                                   "manufacturer",
                                   "most_recent_calibration",
                                   "most_recent_maintenance",
                                   "ownership_type",
                                   "under_warranty___yes_no"),
  equip_info_colnames = c("date_active",
                          "engineering_service_provider",
                          "engineering_service_provider_email_address",
                          "latitude",
                          "longitude",
                          "equipment_purchase_status",
                          "equipment_status",
                          "equip_type",
                          "facility",
                          "freq_calibration",
                          "freq_service_maintenance",
                          "manual_availability",
                          "lab_level",
                          "manufacture_date",
                          "manufacturer",
                          "most_recent_calibration",
                          "most_recent_maintenance",
                          "ownership_type",
                          "waranty_status")
)

activity_info <- read_csv(file = "https://ona.io/pacafenet/99874/594290/download.csv?data-type=dataset",
                                     na = c("n/a", "")) %>%  
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>%
  rename_all(~gsub(pattern = "-", replacement = "_", x = .)) %>%
  rename_all(~tolower(.)) %>%
  # WARNING - SEE BELOW
  # Put this back in when working with real data
  # filter(submitted_by != "pacafenet" |
  # is.na(submitted_by)) %>%
  select(equipment_id, equipment_attribute_to_alter, new_value, submission_time) %>%
  arrange(equipment_id, desc(submission_time)) %>% 
  distinct(equipment_id, equipment_attribute_to_alter, .keep_all = T) %>% 
  left_join(x = ., y = activity_equip_info_lookup, by = "equipment_attribute_to_alter")

# Quick check to make sure all have column values

# sum(is.na(activity_info_historical$equip_info_colnames))

for(i in 1:nrow(activity_info)){
  
  # For Testing
  # i <- 1  # Characters
  # i <- 9
  # i <- 3  # Dates
  # i <- 7  # Numbers
  
  
  curr_data <- activity_info %>% 
    slice(i)
  
  if(curr_data$submission_time > equip_info_current$submission_time[equip_info_current$equip_id == curr_data$equipment_id]){
    
    # For characters
    
    if(is.character(equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id])){
    
      equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id] <- str_to_title(string = curr_data$new_value) 
    
    }
    
    # For Dates
    
    if(is.Date(equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id])){
      
      equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id] <- ymd(curr_data$new_value) 
      
    }
    
    # For Numbers
    
    if(is.numeric(equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id])){
      
      equip_info_current[[curr_data$equip_info_colnames]][equip_info_current$equip_id == curr_data$equipment_id] <- as.numeric(curr_data$new_value)
      
    }
    
  }
  
}

##################

## Keep historical record of activities ##

# NOW - need to figure out a way to preserver the historical data. What I've done above takes the data as it was originally entered and changes the values
# to reflect the current state. Need to be able to report on how it's changed over time. 

# Requirements - if timestamp later than exisitng, create a new row in the existing data with all old columns but the new value reflected

activity_info_historical <- read_csv(file = "https://ona.io/pacafenet/99874/594290/download.csv?data-type=dataset",
                                     na = c("n/a", "")) %>%  
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>%
  rename_all(~gsub(pattern = "-", replacement = "_", x = .)) %>%
  rename_all(~tolower(.)) %>%
  # WARNING - SEE BELOW
  # Put this back in when working with real data
  # filter(submitted_by != "pacafenet" |
  # is.na(submitted_by)) %>%
  select(equipment_id, equipment_attribute_to_alter, new_value, submission_time) %>%
  arrange(equipment_id, desc(submission_time)) %>% 
  # distinct(equipment_id, equipment_attribute_to_alter, .keep_all = T) %>%  # don't need this fx if keeping all activity
  left_join(x = ., y = activity_equip_info_lookup, by = "equipment_attribute_to_alter")

for(i in 1:nrow(activity_info_historical)){

  # For Testing
  # i <- 1
  # i <- 9
  # i <- 3  # Dates
  # i <- 7  # Numbers

  
  curr_data <- activity_info_historical %>%
    slice(i)

  if(curr_data$submission_time > max(equip_info_historical$submission_time[equip_info_historical$equip_id == curr_data$equipment_id], na.rm = T)){

    # For characters
    
    if(is.character(equip_info_historical[[curr_data$equip_info_colnames]])){
      
      curr_data2 <- curr_data %>% 
        mutate(new_value = str_to_title(string = new_value)) %>% 
        select(-equipment_attribute_to_alter) %>% 
        spread(key = equip_info_colnames, value = new_value) %>% 
        left_join(x = ., y = equip_info_historical, by = c("equipment_id" = "equip_id")) %>% 
        select(-contains(".y")) %>% 
        rename_all(~str_remove_all(string = ., pattern = ".x"))
      
      equip_info_historical <- bind_rows(equip_info_historical, curr_data2)
      
    }
    
    # For Dates
    
    if(is.Date(equip_info_historical[[curr_data$equip_info_colnames]])){

      curr_data2 <- curr_data %>%
        mutate(new_value = ymd(new_value)) %>%
        select(-equipment_attribute_to_alter) %>%
        spread(key = equip_info_colnames, value = new_value) %>%
        left_join(x = ., y = equip_info_historical, by = c("equipment_id" = "equip_id")) %>%
        select(-contains(".y")) %>%
        rename_all(~str_remove_all(string = ., pattern = ".x"))

      equip_info_historical <- bind_rows(equip_info_historical, curr_data2)

    }

        # For Numbers
    
    if(is.numeric(equip_info_historical[[curr_data$equip_info_colnames]])){
      
      curr_data2 <- curr_data %>%
        mutate(new_value = as.numeric(new_value)) %>%
        select(-equipment_attribute_to_alter) %>%
        spread(key = equip_info_colnames, value = new_value) %>%
        left_join(x = ., y = equip_info_historical, by = c("equipment_id" = "equip_id")) %>%
        select(-contains(".y")) %>%
        rename_all(~str_remove_all(string = ., pattern = ".x"))
      
      equip_info_historical <- bind_rows(equip_info_historical, curr_data2)
      
    }

  }
  
}

##########################################

## Maintenance and Calibration Request Information ##

calib_req_info_hist <- read_csv(file = "https://ona.io/pacafenet/99874/461478/download.csv?data-type=dataset",
                                na = c("n/a", "")) %>%
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>%
  # WARNING - SEE BELOW
  # Put this back in when working with real data
  #   filter(submitted_by != "pacafenet" |
  #            is.na(submitted_by)) %>% 
  mutate(submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>%
  select(1:2, 6, 11, 16) %>%
  mutate(equip_id = as.character(equip_id)) %>%  # In for now - likely won't need with real data
  arrange(equip_id, desc(submission_time))

# Request Maintenance - still based on just fake data, so no changes made yet - FIX LATER

maintenance_req_info_hist <- read_csv(file = "https://ona.io/pacafenet/99874/461477/download.csv?data-type=dataset",
                                      na = c("n/a", "")) %>%
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>%
  # WARNING - SEE BELOW
  # Put this back in when working with real data
  #   filter(submitted_by != "pacafenet" |
  #            is.na(submitted_by)) %>% 
  mutate(submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>%
  select(1:2, 6, 11, 16) %>%
  mutate(equip_id = as.character(equip_id)) %>%  # In for now - likely won't need with real data
  arrange(equip_id, desc(submission_time))

# Joining Historical request info together

req_info_hist <- full_join(x = calib_req_info_hist, y = maintenance_req_info_hist, by = "equip_id", suffix = c("_calib", "_maint")) %>%
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>%
  # WARNING - SEE BELOW
  # Put this back in when working with real data
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>%
  select(-submitted_by_calib, -submitted_by_maint) %>%
  filter(submitted_by != "pacafenet")

#####################################################

## Write to eTool Directory ##

write_csv(equip_info_current,
          path = "..//shiny-server//eTool//Data//current_state_data.csv")

write_csv(equip_info_historical,
          path = "..//shiny-server//eTool//Data//historical_data.csv")

write_csv(req_info_hist,
          path = "..//shiny-server//eTool//Data//request_history_data.csv")

##############################



# Then - pull in the calibration 




