
###########################################################################################################
# Notes #

# Need to report out on requests made, answered, outstanding requests - perhaps colored based on how long left open?

### Can add all the code from the pipeline RMD as the setup for this app

# definately want to add the ability to export to csv/Excel from the tables. See if possible in GT, otherwise need to use DT 
# (see https://rstudio.github.io/DT/extensions.html) for that particular extension 

# Adding the ability to download data from the app (https://shiny.rstudio.com/articles/download.html)

# Have to make sure that links are to surveys are included in the app where relevant to re-route. 

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

### Data pipeline

#########################################################################################################
# Historical Data #

equip_info <- read_csv(file = "https://ona.io/pacafenet/99874/460026/download.csv?data-type=dataset") %>% 
  mutate(retirement_flag = "No") %>%
  rename(latitude = `_equip_location_latitude`,
         longitude = `_equip_location_longitude`,
         submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>% 
  select(1:15, 17:18, 24, 29, 34) %>% 
  arrange(desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

activity_info <- read_csv(file = "https://ona.io/pacafenet/99874/460087/download.csv?data-type=dataset") %>% 
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>% 
  select(1:8, 12, 17) %>% 
  arrange(desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

#########################################################################################################

#########################################################################################################
# Current State #

curr_data <- left_join(x = equip_info, y = activity_info, by = "equip_id", suffix = c(".info",".activity")) %>% 
  select(1:10, 21, 11, 22, 12, 23, 13, 24, 14, 25, 15, 26, 16, 20, 27, 17, 28, 18, 29) %>% 
  mutate(calib_engineer_nm = if_else(condition = is.na(calib_engineer_nm.activity),  
                                     true = calib_engineer_nm.info,
                                     false = calib_engineer_nm.activity),
         calib_engineer_post = if_else(condition = is.na(calib_engineer_post.activity),
                                       true = calib_engineer_post.info,
                                       false = calib_engineer_post.activity),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration.activity),
                                           true = most_recent_calibration.info,
                                           false = most_recent_calibration.activity),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance.activity),
                                           true = most_recent_maintenance.info,
                                           false = most_recent_maintenance.activity),
         maintenance_engineer_nm = if_else(condition = is.na(maintenance_engineer_nm.activity),
                                           true = maintenance_engineer_nm.info,
                                           false = maintenance_engineer_nm.activity),
         maintenance_engineer_post = if_else(condition = is.na(maintenance_engineer_post.activity),
                                             true = maintenance_engineer_post.info,
                                             false = maintenance_engineer_post.activity),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance.activity),
                                           true = most_recent_maintenance.info,
                                           false = most_recent_maintenance.activity),
         latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         retirement_flag.activity = if_else(condition = is.na(retirement_flag.activity),
                                            true = "No",
                                            false = retirement_flag.activity),
         retirement_flag = if_else(condition = retirement_flag.activity == "Yes" | retirement_flag.info == "Yes",
                                   true = "Yes",
                                   false = "No")) %>% 
  select(-matches("info|activity")) %>% 
  mutate(expected_retirement_date = date_active + 720,
         next_expected_calibration = most_recent_calibration + 90,
         next_expected_maintenance = most_recent_maintenance + 180)

calib_req_info <- read_csv(file = "https://ona.io/pacafenet/99874/461478/download.csv?data-type=dataset") %>% 
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>% 
  select(1:2, 6, 11) %>% 
  arrange(desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

maintenance_req_info <- read_csv(file = "https://ona.io/pacafenet/99874/461477/download.csv?data-type=dataset") %>% 
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>% 
  select(1:2, 6, 11) %>% 
  arrange(desc(submission_time)) %>% 
  distinct(equip_id, .keep_all = T)

activity_req <- full_join(x = calib_req_info, y = maintenance_req_info, by = "equip_id", suffix = c("_calib", "_maint")) %>% 
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>% 
  select(-submitted_by_calib, -submitted_by_maint) %>% 
  left_join(x = ., y = curr_data[ , c(1, 14:15, 18:21)], by = "equip_id") %>% 
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
                                           false = "No")) %>% 
  select(equip_id, calibration_request_date, submission_time_calib, maintenance_request_date, submission_time_maint, submitted_by, 
         activity_required_calib, activity_required_maint, retirement_flag, expected_retirement_date, next_expected_calibration, 
         next_expected_maintenance)

#########################################################################################################

# UI

ui <- dashboardPage(
  
  dashboardHeader(title = "Equipment Maintenance Tracking Inventory",
                  titleWidth = 750),
  
  dashboardSidebar(width = 300,
                   
                   sidebarMenu(
                     
                     # This is where the tabs for each thing I want to show in the app need to go
                     
                     h4("Report View"),  # May decide to get rid of this, or could change the look up a bit 
                     
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
                              tabName = "equip_activity_details",
                              icon = icon("bullhorn"))
                     
                   )),
  
  dashboardBody(
    
    tabItems(  # Has to hold the layout for each item I want to show for each tab specified ^^
      
      tabItem()  # An individual layout for one of the tabs
      
    )
    
  )
  
)

# Server

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)


























































