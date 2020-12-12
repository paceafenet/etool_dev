
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
library(shinyWidgets)
library(plotly)
library(dashboardthemes)

# Historical Data #

# New Equipment Registration Form

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


# Activity form - still based on just fake data, so no changes made as of yet - FIX LATER

activity_info_historical <- read_csv(file = "https://ona.io/pacafenet/99874/460087/download.csv?data-type=dataset",
                                     na = c("n/a", "")) %>%  
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>% 
  rename_all(~gsub(pattern = "-", replacement = "_", x = .)) %>% 
  rename_all(~tolower(.)) %>% 
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>% 
  select(equipment_id, engineering_service_provider, most_recent_calibration, most_recent_maintenance, retirement_flag, submission_time, 
         submitted_by) %>% 
  arrange(equipment_id, desc(submission_time)) %>%
  group_by(equipment_id) %>% 
  mutate(engineering_service_provider = if_else(condition = is.na(engineering_service_provider),
                                                true = lead(engineering_service_provider, n = 1),
                                                false = engineering_service_provider),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration),  
                                           true = lead(most_recent_calibration, n = 1),
                                           false = most_recent_calibration),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance),  
                                           true = lead(most_recent_maintenance, n = 1),
                                           false = most_recent_maintenance),
         retirement_flag = if_else(condition = is.na(retirement_flag),  
                                   true = lead(retirement_flag, n = 1),
                                   false = retirement_flag)) %>% 
  ungroup() %>% 
  mutate(equipment_id = as.character(equipment_id)) # In for now - likely won't need with real data, same with ^^ line

# Request Calibration - still based on just fake data, so no changes made yet - FIX LATER

calib_req_info_hist <- read_csv(file = "https://ona.io/pacafenet/99874/461478/download.csv?data-type=dataset",
                                na = c("n/a", "")) %>%
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>%
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>% 
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
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>% 
  mutate(submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>%
  select(1:2, 6, 11, 16) %>%
  mutate(equip_id = as.character(equip_id)) %>%  # In for now - likely won't need with real data
  arrange(equip_id, desc(submission_time))

# Joining Historical request info together

req_info_hist <- full_join(x = calib_req_info_hist, y = maintenance_req_info_hist, by = "equip_id", suffix = c("_calib", "_maint")) %>% 
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>% 
  filter(submitted_by != "pacafenet" |
           is.na(submitted_by)) %>% 
  select(-submitted_by_calib, -submitted_by_maint) %>% 
  filter(submitted_by != "pacafenet")

# Joins equipment information to activity events
# still based on fake data, won't be anything added here as of yet. No Matches until requests come in. Change the activity form to match the 
# conventions in the newly designed form

historical_data <- left_join(x = equip_info_historical, 
                             y = activity_info_historical, 
                             by = c("equip_id" = "equipment_id"), 
                             suffix = c(".info",".activity")) %>% 
  mutate(engineering_service_provider = if_else(condition = is.na(engineering_service_provider.activity),
                                                true = engineering_service_provider.info,
                                                false = engineering_service_provider.activity),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration.activity),
                                           true = most_recent_calibration.info,
                                           false = most_recent_calibration.activity),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance.activity),
                                           true = most_recent_maintenance.info,
                                           false = most_recent_maintenance.activity),
         submitted_by = if_else(condition = is.na(submitted_by.activity),
                                true = submitted_by.info,
                                false = submitted_by.activity),
         submission_time = if_else(condition = is.na(submission_time.activity),
                                   true = submission_time.info,
                                   false = submission_time.activity),
         latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         retirement_flag = if_else(condition = is.na(retirement_flag),
                                   true = "No",
                                   false = retirement_flag),
         retirement_flag = if_else(condition = retirement_flag == "Yes",
                                   true = "Yes",
                                   false = "No"),
         submission_time = if_else(condition = submission_time.activity > submission_time.info &
                                     !is.na(submission_time.activity),
                                   true = submission_time.activity,
                                   false = submission_time.info),
         submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>% 
  select(-matches("info|activity")) 

#########################################################################################################

#########################################################################################################

# Current State #

# New Equipment Registration Form - pulling data for the current state

equip_info <- equip_info_historical %>% 
  arrange(equip_id, desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

# Activity form - still based on just fake data, so no changes made as of yet - FIX LATER

activity_info <- activity_info_historical %>% 
  arrange(equipment_id, desc(submission_time)) %>% 
  distinct(equipment_id, .keep_all = T)

# Joins equipment information to activity events - FIX LATER
# still based on fake data, won't be anything added here as of yet. No Matches until requests come in

curr_data <- left_join(x = equip_info, 
                       y = activity_info, 
                       by = c("equip_id" = "equipment_id"), 
                       suffix = c(".info",".activity")) %>% 
  mutate(engineering_service_provider = if_else(condition = is.na(engineering_service_provider.activity),
                                                true = engineering_service_provider.info,
                                                false = engineering_service_provider.activity),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration.activity),
                                           true = most_recent_calibration.info,
                                           false = most_recent_calibration.activity),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance.activity),
                                           true = most_recent_maintenance.info,
                                           false = most_recent_maintenance.activity),
         submitted_by = if_else(condition = is.na(submitted_by.activity),
                                true = submitted_by.info,
                                false = submitted_by.activity),
         submission_time = if_else(condition = is.na(submission_time.activity),
                                   true = submission_time.info,
                                   false = submission_time.activity),
         latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         retirement_flag = if_else(condition = is.na(retirement_flag),
                                   true = "No",
                                   false = retirement_flag),
         retirement_flag = if_else(condition = retirement_flag == "Yes",
                                   true = "Yes",
                                   false = "No"),
         submission_time = if_else(condition = submission_time.activity > submission_time.info &
                                     !is.na(submission_time.activity),
                                   true = submission_time.activity,
                                   false = submission_time.info),
         submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>% 
  select(-matches("info|activity")) #%>% 
# Placeholder for getting next dates for stuff - may not need it, but comment it out for discussion
# mutate(expected_retirement_date = date_active + 720,
# next_expected_calibration = most_recent_calibration + 90,
# next_expected_maintenance = most_recent_maintenance + 180)

calib_req_info <- calib_req_info_hist %>% 
  arrange(equip_id, desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

maintenance_req_info <- maintenance_req_info_hist %>% 
  arrange(equip_id, desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

# Think this is where we can fix the logic to trigger emails

# Once the joins are fixed for the request forms, which won't return any matches right now, use the following loginc as the basis for identifying 
# equipment in need of service.

# If most_recent_maintenance is not NA, AND freq_service_maintenance != 0 AND 
# if (today's date - most_recent_maintenance)/freq_service_maintenance > 1, Flag
# OR
# If most_recent_maintenance is NA, AND freq_service_maintenance != 0 AND 
# if (today's date - date_active)/freq_service_maintenance > 1, Flag 

curr_data_activity_req <- full_join(x = calib_req_info, y = maintenance_req_info, by = "equip_id", suffix = c("_calib", "_maint")) %>% 
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>% 
  select(-submitted_by_calib, -submitted_by_maint) %>% 
  right_join(x = ., y = curr_data, by = "equip_id") %>% 
  
  # See how NA's are handled - also see if it's a character value
  mutate(activity_required_maint = if_else(condition = 
                                             (
                                               !is.na(most_recent_maintenance) &
                                                 freq_service_maintenance != 0 &
                                                 retirement_flag != "Yes" &
                                                 equipment_status == "functional" &
                                                 ((Sys.Date() - most_recent_maintenance) / freq_service_maintenance) > 1
                                             ) |
                                             (
                                               is.na(most_recent_maintenance) &
                                                 freq_service_maintenance != 0 &
                                                 equipment_status == "functional" &
                                                 retirement_flag != "Yes" &
                                                 ((Sys.Date() - date_active) / freq_service_maintenance) > 1
                                             ) |
                                             (  
                                               maintenance_request_date > most_recent_maintenance &
                                                 !is.na(maintenance_request_date) &
                                                 equipment_status == "functional" &
                                                 retirement_flag != "Yes"
                                             ),
                                           true = "Yes",
                                           false = "No"),
         activity_required_calib = if_else(condition = 
                                             (
                                               !is.na(most_recent_calibration) &
                                                 freq_calibration != 0 &
                                                 equipment_status == "functional" &
                                                 retirement_flag != "Yes" &
                                                 ((Sys.Date() - most_recent_calibration) / freq_calibration) > 1
                                             ) |
                                             (
                                               is.na(most_recent_calibration) &
                                                 freq_calibration != 0 &
                                                 equipment_status == "functional" &
                                                 retirement_flag != "Yes" &
                                                 ((Sys.Date() - date_active) / freq_calibration) > 1
                                             ) |
                                             (  
                                               calibration_request_date > most_recent_calibration &
                                                 !is.na(calibration_request_date) &
                                                 equipment_status == "functional" &
                                                 retirement_flag != "Yes"
                                             ),
                                           true = "Yes",
                                           false = "No"),
         submitted_by = submitted_by.y) %>% 
  group_by(equip_id) %>%
  mutate(submission_date = if_else(condition = submission_date_calib > submission_date_maint &
                                     !is.na(submission_date_calib),
                                   true = submission_date_calib,
                                   false = submission_date_maint)) %>%
  select(-submitted_by.x, -submitted_by.y) %>% 
  mutate(next_expected_calibration = if_else(condition = 
                                               calibration_request_date > most_recent_calibration &
                                               !is.na(calibration_request_date) &
                                               retirement_flag != "Yes",
                                             true = Sys.Date(),
                                             false = if_else(condition = 
                                                               !is.na(most_recent_calibration) &
                                                               freq_calibration != 0 &
                                                               retirement_flag != "Yes" &
                                                               ((Sys.Date() - most_recent_calibration) / freq_calibration) > 1,
                                                             true = most_recent_calibration + freq_calibration - 10,  
                                                             # Minus 10 => arbitrary, notice before due
                                                             false = if_else(condition = 
                                                                               is.na(most_recent_calibration) &
                                                                               freq_calibration != 0 &
                                                                               retirement_flag != "Yes" &
                                                                               ((Sys.Date() - date_active) / freq_calibration) > 1,
                                                                             true = date_active + freq_calibration - 10,
                                                                             false = ymd("2050-1-1")))),
         next_expected_maintenance = if_else(condition = 
                                               maintenance_request_date > most_recent_maintenance &
                                               !is.na(maintenance_request_date) &
                                               retirement_flag != "Yes",
                                             true = Sys.Date(),
                                             false = if_else(condition = 
                                                               !is.na(most_recent_maintenance) &
                                                               freq_service_maintenance != 0 &
                                                               retirement_flag != "Yes" &
                                                               ((Sys.Date() - most_recent_maintenance) / freq_service_maintenance) > 1,
                                                             true = most_recent_maintenance + freq_service_maintenance - 10,  
                                                             # Minus 10 => arbitrary, notice before due
                                                             false = if_else(condition = 
                                                                               is.na(most_recent_maintenance) &
                                                                               freq_service_maintenance != 0 &
                                                                               retirement_flag != "Yes" &
                                                                               ((Sys.Date() - date_active) / freq_service_maintenance) > 1,
                                                                             true = date_active + freq_service_maintenance - 10,
                                                                             false = ymd("2050-1-1")))))

write_csv(curr_data_activity_req,
          path = "Alert Data\\alert_data.csv")



