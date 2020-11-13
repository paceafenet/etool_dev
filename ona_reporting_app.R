
###########################################################################################################
# Notes #

# May be worth fixing the joins now with activity - since I can figure out how to build in the logic for
# notifiations

# Add email context to allow for notifications. 
  # Logic starts at line 

#######################

#########################################################################################################

# App Setup

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

### Data pipeline

#########################################################################################################

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
                                false = submitted_by),
         equip_id = as.character(equip_id))

# Activity form - still based on just fake data, so no changes made as of yet - FIX LATER

activity_info_historical <- read_csv(file = "https://ona.io/pacafenet/99874/460087/download.csv?data-type=dataset",
                                     na = c("n/a", "")) %>%  
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>% 
  rename_all(~gsub(pattern = "-", replacement = "_", x = .)) %>% 
  rename_all(~tolower(.)) %>% 
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
  mutate(submission_date = ymd(str_sub(string = submission_time, start = 1, end = 10))) %>%
  select(1:2, 6, 11, 16) %>%
  mutate(equip_id = as.character(equip_id)) %>%  # In for now - likely won't need with real data
  arrange(equip_id, desc(submission_time))

# Joining Historical request info together

req_info_hist <- full_join(x = calib_req_info_hist, y = maintenance_req_info_hist, by = "equip_id", suffix = c("_calib", "_maint")) %>% 
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>% 
  select(-submitted_by_calib, -submitted_by_maint)

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
  
  # HERE - this is where the conditions should be for saying whether or not the equipment needs attention - great stopping point
  
  mutate(activity_required_calib = if_else(condition = (calibration_request_date > most_recent_calibration &
                                                          !is.na(calibration_request_date) &
                                                          retirement_flag != "Yes") |
                                             next_expected_calibration < most_recent_calibration,
                                           true = "Yes",
                                           false = "No"),
         activity_required_maint = if_else(condition = (maintenance_request_date > most_recent_maintenance &
                                                          !is.na(maintenance_request_date) &
                                                          retirement_flag != "Yes") |
                                             next_expected_maintenance < most_recent_maintenance,
                                           true = "Yes",
                                           false = "No"),
         submitted_by = submitted_by.y,
         submission_date = if_else(condition = submission_date_calib > submission_date_maint &
                                     !is.na(submission_date_calib),
                                   true = submission_date_calib,
                                   false = submission_date_maint)) %>% 
  select(-submitted_by.x, -submitted_by.y)

#########################################################################################################

# Application # 

ui <- dashboardPage(
  
  dashboardHeader(title = "Equipment Maintenance Tracking",
                  titleWidth = 500),
  
  dashboardSidebar(width = 300,
                   
                   sidebarMenu(id = "tabs",
                     
                     h4("Report View"),  
                     
                     menuItem(text = "Equipment Report Overview", 
                              tabName = "overview_info",
                              icon = icon("chart-line")),
                     
                     menuItem(text = "Equipment Details",
                              tabName = "equip_details",
                              icon = icon("binoculars")),
                     
                     menuItem(text = "Equipment Activity Details",
                              tabName = "equip_activity_details",
                              icon = icon("table")),
                     
                     menuItem(text = "Equipment Maintenance Requests",
                              tabName = "equip_activity_requests",
                              icon = icon("bullhorn"))
                   )),
  dashboardBody(
    
    theme_grey_light,

    tabItems(
      
      tabItem(tabName = "overview_info",
              
              fluidRow( 
                
                valueBoxOutput(outputId = "kpi_pieces_active_equip",
                               width = 2), 
                
                valueBoxOutput(outputId = "kpi_pieces_need_attention",
                               width = 2),  
                
                valueBoxOutput(outputId = "kpi_total_requests", 
                               width = 2),
                
                valueBoxOutput(outputId = "kpi_total_outstanding_requests", 
                               width = 2),
                
                valueBoxOutput(outputId = "kpi_requests_answered",
                               width = 2)
              ),  
              
              fluidRow(
                tabBox(title = strong("Equipment Requiring Attention by Category"),  
                       id = "attention_tabset",
                       
                       tabPanel(title = "Lab Count",
                                plotlyOutput("equip_by_lab_bar")),
                       
                       tabPanel(title = "Lab Pct",
                                plotlyOutput("equip_by_lab_pct_bar")),
                       
                       tabPanel(title = "Attention Category",
                                plotlyOutput("equip_by_attention_category_bar")),
                       
                       tabPanel(title = "Lab Level",
                                plotlyOutput("equip_attention_level_bar"))
                )
              )
      ),
      
      tabItem(tabName = "equip_details",
              fluidRow(  
                column(width = 3,
                       pickerInput(inputId = "equipment_id",
                                   label = "Choose Equipment ID(s):",
                                   choices = sort(unique(curr_data_activity_req$equip_id)),
                                   selected = sort(unique(curr_data_activity_req$equip_id)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                       ),
                column(width = 3,
                  pickerInput(inputId = "equipment_type",
                              label = "Choose Equipment Type(s):",
                              choices = sort(unique(curr_data_activity_req$equip_type)),
                              selected = sort(unique(curr_data_activity_req$equip_type)),
                              multiple = T,
                              options = list(`actions-box` = T,
                                             `live-search` = T))
                ),
                column(width = 3,
                       pickerInput(inputId = "facility",
                                   label = "Choose Facilitie(s):",
                                   choices = sort(unique(curr_data_activity_req$facility)),
                                   selected = sort(unique(curr_data_activity_req$facility)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 3,
                       pickerInput(inputId = "submitted_by",
                                   label = "Choose Survey Respondent(s):",
                                   choices = sort(unique(curr_data_activity_req$submitted_by)),
                                   selected = sort(unique(curr_data_activity_req$submitted_by)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                )
              ),
              
              fluidRow(downloadButton(outputId = "download_equip_details",
                                      label = "Download Data")),
              
              fluidRow(gt_output("equip_details_table")),
              
              fluidRow(h3(a("Enter Equipment Information", href = "https://enketo.ona.io/x/#xsR3wR1v")))
              
              ),  
      
      tabItem(tabName = "equip_activity_details", 
              
              fluidRow(  
                column(width = 3,
                       pickerInput(inputId = "equipment_id_hist",
                                   label = "Choose Equipment ID(s):",
                                   choices = sort(unique(historical_data$equip_id)),
                                   selected = sort(unique(historical_data$equip_id)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 3,
                       pickerInput(inputId = "equipment_type_hist",
                                   label = "Choose Equipment Type(s):",
                                   choices = sort(unique(historical_data$equip_type)),
                                   selected = sort(unique(historical_data$equip_type)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 3,
                       pickerInput(inputId = "manufacturer_hist",
                                   label = "Choose Equipment Type(s):",
                                   choices = sort(unique(historical_data$manufacturer)),
                                   selected = sort(unique(historical_data$manufacturer)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))),
                column(width = 3,
                       pickerInput(inputId = "facility_hist",
                                   label = "Choose Facilitie(s):",
                                   choices = sort(unique(historical_data$facility)),
                                   selected = sort(unique(historical_data$facility)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                )
              ), 
              
              fluidRow(
                column(width = 2,
                  dateRangeInput(inputId = "dt_submitted_hist",
                                 label = "Select Submission Date Range:",
                                 start = min(historical_data$submission_date, na.rm = T),
                                 end = max(historical_data$submission_date, na.rm = T),
                                 min = min(historical_data$submission_date, na.rm = T),
                                 max = max(historical_data$submission_date, na.rm = T))
                ),
                column(width = 2,
                  dateRangeInput(inputId = "dt_manufacture_hist",
                                 label = "Select Manufacture Date Range:",
                                 start = min(historical_data$manufacture_date, na.rm = T),
                                 end = max(historical_data$manufacture_date, na.rm = T),
                                 min = min(historical_data$manufacture_date, na.rm = T),
                                 max = max(historical_data$manufacture_date, na.rm = T))
                ),
                column(width = 2,
                  dateRangeInput(inputId = "dt_active_hist",
                                 label = "Select Active Date Range:",
                                 start = min(historical_data$date_active, na.rm = T),
                                 end = max(historical_data$date_active, na.rm = T),
                                 min = min(historical_data$date_active, na.rm = T),
                                 max = max(historical_data$date_active, na.rm = T))
                ),
                column(width = 2,
                  dateRangeInput(inputId = "dt_calibration_hist",
                                 label = "Select Calibration Date Range:",
                                 start = min(historical_data$most_recent_calibration, na.rm = T),
                                 end = max(historical_data$most_recent_calibration, na.rm = T),
                                 min = min(historical_data$most_recent_calibration, na.rm = T),
                                 max = max(historical_data$most_recent_calibration, na.rm = T))
                ),
                column(width = 2,
                  dateRangeInput(inputId = "dt_maintenance_hist",
                                 label = "Select Maintenance Date Range:",
                                 start = min(historical_data$most_recent_maintenance, na.rm = T),
                                 end = max(historical_data$most_recent_maintenance, na.rm = T),
                                 min = min(historical_data$most_recent_maintenance, na.rm = T),
                                 max = max(historical_data$most_recent_maintenance, na.rm = T))
                ),
                column(width = 2,
                  pickerInput(inputId = "submitted_by_hist",
                              label = "Choose Survey Respondent(s):",
                              choices = sort(unique(historical_data$submitted_by)),
                              selected = sort(unique(historical_data$submitted_by)),
                              multiple = T,
                              options = list(`actions-box` = T,
                                             `live-search` = T))
                )
              ),
              
              fluidRow(downloadButton(outputId = "download_equip_activity_hist_details",
                                      label = "Download Data")),
              
              fluidRow(gt_output("equip_activity_hist_table")),

              fluidRow(h3(a("Enter Activity Information", href = "https://enketo.ona.io/x/#JBXgIyIf")))
              
              ),
      
      tabItem(tabName = "equip_activity_requests",  
              
              fluidRow(
                column(width = 3,
                       pickerInput(inputId = "equipment_id_req",
                                   label = "Choose Equipment ID(s):",
                                   choices = sort(unique(curr_data_activity_req$equip_id)),
                                   selected = sort(unique(curr_data_activity_req$equip_id)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 3,
                       pickerInput(inputId = "facility_req",
                                   label = "Choose Facilitie(s):",
                                   choices = sort(unique(curr_data_activity_req$facility)),
                                   selected = sort(unique(curr_data_activity_req$facility)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 3,
                       dateRangeInput(inputId = "dt_calibration_req",
                                      label = "Select Calibration Request Date Range:",
                                      start = min(curr_data_activity_req$calibration_request_date, na.rm = T),
                                      end = max(curr_data_activity_req$calibration_request_date, na.rm = T),
                                      min = min(curr_data_activity_req$calibration_request_date, na.rm = T),
                                      max = max(curr_data_activity_req$calibration_request_date, na.rm = T))
                ),
                column(width = 3,
                       dateRangeInput(inputId = "dt_maintenance_req",
                                      label = "Select Maintenance Request Date Range:",
                                      start = min(curr_data_activity_req$maintenance_request_date, na.rm = T),
                                      end = max(curr_data_activity_req$maintenance_request_date, na.rm = T),
                                      min = min(curr_data_activity_req$maintenance_request_date, na.rm = T),
                                      max = max(curr_data_activity_req$maintenance_request_date, na.rm = T))
                )
              ),
              
              fluidRow(downloadButton(outputId = "download_equip_req_details",
                                      label = "Download Data")),
              
              fluidRow(gt_output("equip_req_table")),
              
              fluidRow(h3(a("Request Calibration", href = "https://enketo.ona.io/x/#VI2FevM7"))),
              
              fluidRow(h3(a("Request Maintenance", href = "https://enketo.ona.io/x/#OPkgR4Hc")))
              
              )
    )
  )
)

server <- function(input, output, session) {
  
  output$equip_details_table <- render_gt({
    
    tt <- curr_data_activity_req %>%   
      filter(equip_id %in% c(input$equipment_id) &
               equip_type %in% c(input$equipment_type) &
               facility %in% c(input$facility) &
               submitted_by %in% c(input$submitted_by)) %>%
      gt() %>% 
      cols_align(align = "center") %>%
      cols_hide(columns = vars(calibration_request_date,
                               submission_time_calib,
                               maintenance_request_date,
                               submission_time_maint,
                               lab_level_is_other,
                               latitude,
                               longitude,
                               most_recent_calibration,
                               most_recent_maintenance,
                               expected_retirement_date,
                               next_expected_calibration,
                               next_expected_maintenance,
                               activity_required_calib,
                               activity_required_maint,
                               submission_date_calib,
                               submission_date_maint)) %>%  
      cols_move(columns = vars(ownership_type),
                after = vars(lab_level)) %>%  
      cols_move(columns = vars(retirement_flag),
                after = vars(maintenance_engineer_post)) %>%  
      cols_label(equip_id = "Equipment ID", 
                 submitted_by = "Submitted by",
                 equip_type = "Equipment Type",
                 manufacturer = "Manufacturer",
                 manufacture_date = "Manufacture Date",
                 date_active = "Date Active",
                 facility = "Facility",
                 ownership_type = "Ownership Type",
                 lab_level = "Facility Level", 
                 calib_engineer_nm = "Calibration Engineer Name",
                 calib_engineer_post = "Calibration Engineer Post", 
                 maintenance_engineer_nm = "Maintenance Engineer Name",
                 maintenance_engineer_post = "Maintenance Engineer Post",
                 retirement_flag = "Retirement Flag",
                 submission_date = "Last Updated") %>%
      fmt_missing(columns = everything(),
                  missing_text = "") %>% 
      cols_width(vars(date_active) ~ px(100),
                 vars(equip_id) ~ px(80),
                 vars(manufacturer) ~ px(125)) %>% 
      tab_style(style = list(cell_fill(color = "white"),
                             cell_text(color = "red")),  
                locations = cells_data(columns = vars(equip_id),
                                       rows = activity_required_calib == "Yes" | activity_required_maint == "Yes")) %>% 
      tab_style(style = list(cell_fill(color = "white"),
                             cell_text(color = "red")),  
                locations = cells_data(columns = vars(retirement_flag),
                                       rows = retirement_flag == "Yes")) %>% 
      tab_header(title = "Detailed Equipment Information") %>%
      tab_footnote(footnote = "Red indicates equipment needs attention.",
                   locations = cells_column_labels(columns = vars(equip_id))) %>% 
      tab_footnote(footnote = "Equipment flagged for retirement.",
                   locations = cells_column_labels(columns = vars(retirement_flag))) %>% 
      tab_options(row.striping.include_stub = T,
                  row.striping.include_table_body = T,
                  table.border.top.color = "black",
                  table_body.border.bottom.color = "black",
                  table.width = "80%")
  })
  
  output$download_equip_details <- downloadHandler(

    filename = function(){
      paste0("Equipment Details Data ", Sys.Date(), ".xlsx")},
    
    content = function(file){
      xlsx::write.xlsx(as.data.frame(equip_details_export <- curr_data_activity_req %>%
                                       filter(equip_type %in% c(input$equipment_type) &
                                                facility %in% c(input$facility) &
                                                submitted_by %in% c(input$submitted_by)) %>%
                                       select(equip_id,
                                              submitted_by,
                                              equip_type,
                                              manufacturer,
                                              manufacture_date,
                                              date_active,
                                              facility,
                                              ownership_type,
                                              lab_level,
                                              calib_engineer_nm,
                                              calib_engineer_post,
                                              maintenance_engineer_nm,
                                              maintenance_engineer_post,
                                              retirement_flag) %>%
                                       rename("Equip ID" = equip_id,
                                              "Submitted by" = submitted_by,
                                              "Equipment Type" = equip_type,
                                              "Manufacturer" = manufacturer,
                                              "Manufacture Date" = manufacture_date,
                                              "Date Active" = date_active,
                                              "Facility" = facility,
                                              "Ownership Type" = ownership_type,
                                              "Facility Level" = lab_level,
                                              "Calibration Engineer Name" = calib_engineer_nm,
                                              "Calibration Engineer Post" = calib_engineer_post,
                                              "Maintenance Engineer Name" = maintenance_engineer_nm,
                                              "Maintenance Engineer Post" = maintenance_engineer_post,
                                              "Retirement Flag" = retirement_flag)),
                       file = file, 
                       sheetName = "Equip Details",
                       showNA = F,
                       row.names = F,
                       append = F)
    }
  )
  
  output$equip_activity_hist_table <- render_gt({
    
    tt <- historical_data %>%
      filter(equip_id %in% c(input$equipment_id_hist) &
               equip_type %in% c(input$equipment_type_hist) &  
               manufacturer %in% c(input$manufacturer_hist) &
               facility %in% c(input$facility_hist) &
               submitted_by %in% c(input$submitted_by_hist) &
               submission_date >= input$dt_submitted_hist[1] &  
               submission_date <= input$dt_submitted_hist[2] &
               manufacture_date >= input$dt_manufacture_hist[1] &
               manufacture_date <= input$dt_manufacture_hist[2] &
               date_active >= input$dt_active_hist[1] &
               date_active <= input$dt_active_hist[2] &
               most_recent_calibration >= input$dt_calibration_hist[1] &
               most_recent_calibration <= input$dt_calibration_hist[2] &
               most_recent_maintenance >= input$dt_maintenance_hist[1] &
               most_recent_maintenance <= input$dt_maintenance_hist[2]) %>%
      ungroup() %>% 
      gt() %>%
      cols_align(align = "center") %>%
      cols_hide(columns = vars(lab_level_is_other,  
                               latitude,                 
                               longitude,
                               submission_time,
                               retirement_flag)) %>%
      cols_move(columns = vars(ownership_type),
                after = vars(lab_level)) %>%
      cols_move(columns = vars(retirement_flag),
                after = vars(submission_date)) %>%
      cols_move(columns = vars(most_recent_maintenance),
                after = vars(maintenance_engineer_post)) %>% 
      cols_label(equip_id = "Equipment ID",
                 submitted_by = "Submitted by",
                 equip_type = "Equipment Type",
                 manufacturer = "Manufacturer",
                 manufacture_date = "Manufacture Date",
                 date_active = "Date Active",
                 facility = "Facility",
                 ownership_type = "Ownership Type",
                 lab_level = "Facility Level",
                 calib_engineer_nm = "Calibration Engineer Name",
                 calib_engineer_post = "Calibration Engineer Post",
                 maintenance_engineer_nm = "Maintenance Engineer Name",
                 maintenance_engineer_post = "Maintenance Engineer Post",
                 most_recent_calibration = "Most Recent Calibration",
                 most_recent_maintenance = "Most Recent Maintenance",
                 submission_date = "Submission Date") %>%
      cols_width(vars(date_active) ~ px(100),
                 vars(equip_id) ~ px(80),
                 vars(manufacturer) ~ px(125),
                 vars(facility) ~ px(80),
                 vars(retirement_flag) ~ px(80),
                 vars(lab_level) ~ px(80),
                 vars(calib_engineer_nm) ~ px(80),
                 vars(calib_engineer_post) ~ px(80),
                 vars(maintenance_engineer_nm) ~ px(100),
                 vars(maintenance_engineer_post) ~ px(100),
                 vars(retirement_flag) ~ 90) %>%
      tab_style(style = list(cell_fill(color = "white"),
                             cell_text(color = "red")),
                locations = cells_data(columns = vars(equip_id),
                                       rows = retirement_flag == "Yes")) %>%
      tab_header(title = "Detailed Equipment Activity Information") %>%
      tab_footnote(footnote = "Red indicates equipment flagged for retirement.",
                   locations = cells_column_labels(columns = vars(equip_id))) %>%
      tab_options(row.striping.include_stub = T,
                  row.striping.include_table_body = T,
                  table.border.top.color = "black",
                  table_body.border.bottom.color = "black",
                  table.width = "80%")
  })

  output$download_equip_activity_hist_details <- downloadHandler(

    filename = function(){
      paste0("Activity Details Data ", Sys.Date(), ".xlsx")},

    content = function(file){  # ISSUE HERE
      xlsx::write.xlsx(as.data.frame(activity_details_export <- historical_data %>%
                                       filter(equip_id %in% c(input$equipment_id_hist) &
                                                equip_type %in% c(input$equipment_type_hist) &  
                                                manufacturer %in% c(input$manufacturer_hist) &
                                                facility %in% c(input$facility_hist) &
                                                submitted_by %in% c(input$submitted_by_hist) &
                                                submission_date >= input$dt_submitted_hist[1] &  
                                                submission_date <= input$dt_submitted_hist[2] &
                                                manufacture_date >= input$dt_manufacture_hist[1] &
                                                manufacture_date <= input$dt_manufacture_hist[2] &
                                                date_active >= input$dt_active_hist[1] &
                                                date_active <= input$dt_active_hist[2] &
                                                most_recent_calibration >= input$dt_calibration_hist[1] &
                                                most_recent_calibration <= input$dt_calibration_hist[2] &
                                                most_recent_maintenance >= input$dt_maintenance_hist[1] &
                                                most_recent_maintenance <= input$dt_maintenance_hist[2]) %>%
                                       ungroup() %>% 
                                       select(-c(lab_level_is_other,  
                                                 latitude,                 
                                                 longitude,
                                                 submission_time,
                                                 retirement_flag)) %>%
                                       rename("Equipment ID" = equip_id,
                                              "Submitted by" = submitted_by,
                                              "Equipment Type" = equip_type,
                                              "Manufacturer" = manufacturer,
                                              "Manufacture Date" = manufacture_date,
                                              "Date Active" = date_active,
                                              "Facility" = facility,
                                              "Ownership Type" = ownership_type,
                                              "Facility Level" = lab_level,
                                              "Calibration Engineer Name" = calib_engineer_nm,
                                              "Calibration Engineer Post" = calib_engineer_post,
                                              "Maintenance Engineer Name" = maintenance_engineer_nm,
                                              "Maintenance Engineer Post" = maintenance_engineer_post,
                                              "Most Recent Calibration" = most_recent_calibration,
                                              "Most Recent Maintenance" = most_recent_maintenance,
                                              "Submission Date" = submission_date)),
                       file = file,
                       sheetName = "Activity Details",
                       showNA = F,
                       row.names = F,
                       append = F)
    }
  )
  
  output$equip_req_table <- render_gt({

    tt <- curr_data_activity_req %>%
      filter(equip_id %in% c(input$equipment_id_req) &
               facility %in% c(input$facility_req) &
               (is.na(calibration_request_date) |
                (calibration_request_date >= input$dt_calibration_req[1] &
                   calibration_request_date <= input$dt_calibration_req[2])) &
               (is.na(maintenance_request_date) |
                  (maintenance_request_date >= input$dt_maintenance_req[1] &
                     maintenance_request_date <= input$dt_maintenance_req[2]))) %>%
      gt() %>%
      cols_align(align = "center") %>%
      cols_hide(columns = vars(submission_time_maint,
                               manufacturer,
                               manufacture_date,
                               lab_level,
                               lab_level_is_other,
                               latitude,
                               longitude,
                               activity_required_calib,
                               activity_required_maint,
                               submission_time_calib,
                               submission_time_calib,
                               retirement_flag,
                               submitted_by,	
                               submission_date,
                               date_active,
                               ownership_type)) %>%
      cols_move(columns = vars(most_recent_calibration, next_expected_calibration, calib_engineer_nm, calib_engineer_post),
                after = vars(submission_date_calib)) %>%
      cols_move(columns = vars(equip_type, facility),
                after = vars(equip_id)) %>% 
      cols_move(columns = vars(next_expected_maintenance),
                after = vars(most_recent_maintenance)) %>% 
      cols_label(equip_id = "Equipment ID",
                 equip_type = "Equipment Type",
                 calibration_request_date = "Calib Req Date",
                 submission_date_calib = "Date Submitted",  
                 maintenance_request_date = "Maintenance Req Date",	
                 submission_date_maint = "Date Submitted",	
                 facility = "Facility",	
                 calib_engineer_nm = "Calib Engr",
                 calib_engineer_post = "Engr Post",	
                 most_recent_calibration = "Last Calib",	
                 most_recent_maintenance = "Last Maintenance",	
                 maintenance_engineer_nm = "Maintenance Engr",	
                 maintenance_engineer_post = "Engr Post",	
                 expected_retirement_date = "Expected Retirement",	
                 next_expected_calibration = "Next Calib",	
                 next_expected_maintenance = "Next Maintenance") %>%
      fmt_missing(columns = everything(),
                  missing_text = "") %>% 
      cols_width(vars(equip_id) ~ px(80),
                 vars(most_recent_calibration, next_expected_calibration) ~ px(120)) %>%
      tab_style(style = list(cell_fill(color = "white"),
                             cell_text(color = "red")),
                locations = cells_data(columns = vars(equip_id),
                                       rows = activity_required_calib == "Yes" | activity_required_maint == "Yes")) %>%
      tab_style(style = list(cell_fill(color = "white"),  # Issue
                             cell_text(color = "red")),
                locations = cells_data(columns = vars(calibration_request_date),
                                       rows = (calibration_request_date > most_recent_calibration &
                                         !is.na(calibration_request_date) &
                                         retirement_flag != "Yes") |
                  next_expected_calibration < most_recent_calibration)) %>%
      tab_style(style = list(cell_fill(color = "white"),
                             cell_text(color = "red")),
                locations = cells_data(columns = vars(maintenance_request_date),
                                       rows = (maintenance_request_date > most_recent_maintenance &
                                         !is.na(maintenance_request_date) &
                                         retirement_flag != "Yes") |
                  next_expected_maintenance < most_recent_maintenance)) %>%
      tab_header(title = "Detailed Request Information") %>%
      tab_footnote(footnote = "Red indicates equipment needs attention.",
                   locations = cells_column_labels(columns = vars(equip_id))) %>%
      tab_options(row.striping.include_stub = T,
                  row.striping.include_table_body = T,
                  table.border.top.color = "black",
                  table_body.border.bottom.color = "black",
                  table.width = "80%")
  })

  output$download_equip_req_details <- downloadHandler(

    filename = function(){
      paste0("Request Details Data ", Sys.Date(), ".xlsx")},

    content = function(file){
      xlsx::write.xlsx(as.data.frame(tt <- curr_data_activity_req %>%
                                       filter(equip_id %in% c(input$equipment_id_req) &
                                                facility %in% c(input$facility_req) &
                                                (is.na(calibration_request_date) |
                                                   (calibration_request_date >= input$dt_calibration_req[1] &
                                                      calibration_request_date <= input$dt_calibration_req[2])) &
                                                (is.na(maintenance_request_date) |
                                                   (maintenance_request_date >= input$dt_maintenance_req[1] &
                                                      maintenance_request_date <= input$dt_maintenance_req[2]))) %>%
                                       select(-c(submission_time_maint,
                                                 manufacturer,
                                                 manufacture_date,
                                                 lab_level,
                                                 lab_level_is_other,
                                                 latitude,
                                                 longitude,
                                                 activity_required_calib,
                                                 activity_required_maint,
                                                 submission_time_calib,
                                                 submission_time_calib,
                                                 retirement_flag,
                                                 submitted_by,	
                                                 submission_date,
                                                 date_active,
                                                 ownership_type)) %>%
                                       rename("Equipment ID" = equip_id,
                                              "Equipment Type" = equip_type,
                                              "Calib Req Date" = calibration_request_date,
                                              "Date Submitted" = submission_date_calib,  
                                              "Maintenance Req Date" = maintenance_request_date,	
                                              "Date Submitted" = submission_date_maint,	
                                              "Facility" = facility,	
                                              "Calib Engr" = calib_engineer_nm,
                                              "Engr Post" = calib_engineer_post,	
                                              "Last Calib" = most_recent_calibration,	
                                              "Last Maintenance" = most_recent_maintenance,	
                                              "Maintenance Engr" = maintenance_engineer_nm,	
                                              "Engr Post" = maintenance_engineer_post,	
                                              "Expected Retirement" = expected_retirement_date,	
                                              "Next Calib" = next_expected_calibration,	
                                              "Next Maintenance" = next_expected_maintenance)),
                       file = file,
                       sheetName = "Equip Details",
                       showNA = F,
                       row.names = F,
                       append = F)
    }
  )
  
  output$kpi_pieces_active_equip <- renderValueBox(  # Current data
    valueBox(value = prettyNum(tt <- curr_data_activity_req %>% 
                                 filter(retirement_flag == "No")%>% 
                                 nrow(), 
                               big.mark = ","),
             subtitle = "Active Pieces of Equipment")
  )
  
  output$kpi_pieces_need_attention <- renderValueBox(  # Current data
    valueBox(value = prettyNum(tt <- curr_data_activity_req %>% 
                                 filter(retirement_flag == "No" &
                                          (activity_required_calib == "Yes" | activity_required_maint == "Yes")) %>% 
                                 nrow(), 
                               big.mark = ","),
             subtitle = "Immediate Acivity Needed")
  )
  
  output$kpi_total_requests <- renderValueBox(  # req_info_hist
    valueBox(value = prettyNum(tt <- req_info_hist %>% 
                                 nrow(),
                               big.mark = ","),
             subtitle = "Number of Requests Made")
  )
  
  output$kpi_total_outstanding_requests <- renderValueBox(  
    valueBox(value = prettyNum(tt <- left_join(x = req_info_hist, y = curr_data_activity_req, by = "equip_id", suffix = c("_req", "_curr")) %>% 
                                 mutate(outstanding_req = if_else(condition = (calibration_request_date_req > calibration_request_date_curr &
                                                                                 !is.na(calibration_request_date_req) &
                                                                                 retirement_flag != "Yes") |
                                                                    (maintenance_request_date_req > maintenance_request_date_curr &
                                                                       !is.na(maintenance_request_date_req) &
                                                                       retirement_flag != "Yes"),
                                                                  true = "Yes",
                                                                  false = "No")) %>% 
                                 filter(outstanding_req == "Yes") %>% 
                                 nrow(),
                               big.mark = ","),
             subtitle = "Number Outstanding Requests")
  )
  
  output$kpi_requests_answered <- renderValueBox(  
    valueBox(value = prettyNum(tt <- left_join(x = req_info_hist, y = curr_data_activity_req, by = "equip_id", suffix = c("_req", "_curr")) %>% 
                                 mutate(outstanding_req = if_else(condition = (calibration_request_date_req > calibration_request_date_curr &
                                                                                 !is.na(calibration_request_date_req) &
                                                                                 retirement_flag != "Yes") |
                                                                    (maintenance_request_date_req > maintenance_request_date_curr &
                                                                       !is.na(maintenance_request_date_req) &
                                                                       retirement_flag != "Yes"),
                                                                  true = "Yes",
                                                                  false = "No")) %>% 
                                 filter(outstanding_req == "No") %>% 
                                 nrow(),
                               big.mark = ","),
             subtitle = "Number of Requests Answered")
  )

  output$equip_by_lab_bar <- renderPlotly({ 
    
    tt <- curr_data_activity_req %>% 
      filter(retirement_flag != "Yes") %>%
      mutate(requires_attn = if_else(condition = activity_required_calib == "Yes" | activity_required_maint == "Yes",
                                     true = "Yes",
                                     false = "No")) %>%
      group_by(facility, requires_attn) %>%  
      tally() %>% 
      pivot_wider(names_from = requires_attn, values_from = n, values_fill = list(n = 0))
    
    tt2 <- tt %>% 
      ggplot(aes(x = facility, weight = Yes)) +  
      geom_bar(fill = "white", color = "black") +
      coord_flip() +
      theme_classic() + 
      xlab("Facility") + 
      scale_y_continuous(name = "Number of Labs",
                         limits = c(0, sum(tt$Yes, na.rm = T)),
                         breaks = seq(0, sum(tt$Yes, na.rm = T), 1)) +
      theme(legend.position = "none",
            axis.text.x = element_text(face = "bold"),
            axis.text.y = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            axis.text = element_text(color = "Black"))
  })

  output$equip_by_lab_pct_bar <- renderPlotly({  
    
    tt <- curr_data_activity_req %>%
      filter(retirement_flag != "Yes") %>%
      mutate(requires_attn = if_else(condition = activity_required_calib == "Yes" | activity_required_maint == "Yes",
                                     true = "Yes",
                                     false = "No")) %>%
      group_by(facility, requires_attn) %>%  # Changes
      tally() %>% 
      pivot_wider(names_from = requires_attn, values_from = n, values_fill = list(n = 0)) %>% 
      mutate(pct_yes = round((Yes/(No + Yes)) * 100, digits = 2))

    tt2 <- tt %>%
      ggplot(aes(x = facility, weight = pct_yes)) +  # Changes
      geom_bar(fill = "white", color = "black") +
      coord_flip() +
      theme_classic() +
      xlab("Facility") +  # Changes
      scale_y_continuous(name = "% Equipment Requiring Attention",  # Changes
                         limits = c(0, 100),
                         breaks = seq(0, 100, 5)) +
      theme(legend.position = "none",
            axis.text.x = element_text(face = "bold"),
            axis.text.y = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            axis.text = element_text(color = "Black"))
  })

  output$equip_by_attention_category_bar <- renderPlotly({  

    tt <- curr_data_activity_req %>% 
      filter(retirement_flag != "Yes") %>%
      mutate(requires_attn = if_else(condition = activity_required_calib == "Yes" | activity_required_maint == "Yes",
                                     true = "Yes",
                                     false = "No")) %>% 
      group_by(requires_attn) %>%  
      tally() 

    tt2 <- tt %>% 
      ggplot(aes(x = requires_attn, weight = n)) +
      geom_bar(fill = "white", color = "black") +
      coord_flip() +
      theme_classic() + 
      xlab("Requires Attention") + 
      scale_y_continuous(name = "Count",
                         limits = c(0, sum(tt$n, na.rm = T)),
                         breaks = seq(0, sum(tt$n, na.rm = T), 1)) +
      theme(legend.position = "none",
            axis.text.x = element_text(face = "bold"),
            axis.text.y = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            axis.text = element_text(color = "Black"))

  })

  output$equip_attention_level_bar <- renderPlotly({  # Current data

    tt <- curr_data_activity_req %>%
      filter(retirement_flag != "Yes") %>%
      mutate(requires_attn = if_else(condition = activity_required_calib == "Yes" | activity_required_maint == "Yes",
                                     true = "Yes",
                                     false = "No")) %>%
      group_by(lab_level, requires_attn) %>%  
      tally() %>% 
      pivot_wider(names_from = requires_attn, values_from = n, values_fill = list(n = 0))

    tt2 <- tt %>%
      ggplot(aes(x = lab_level, weight = Yes)) + 
      geom_bar(fill = "white", color = "black") +
      coord_flip() +
      theme_classic() +
      xlab("Lab Level") +  
      scale_y_continuous(name = "Count", 
                         limits = c(0, sum(tt$Yes, na.rm = T)),
                         breaks = seq(0, sum(tt$Yes, na.rm = T), 1)) +
      theme(legend.position = "none",
            axis.text.x = element_text(face = "bold"),
            axis.text.y = element_text(face = "bold"),
            axis.title = element_text(face = "bold"),
            axis.text = element_text(color = "Black"))
  })
}

shinyApp(ui = ui, server = server)


























































