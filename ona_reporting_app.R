
###########################################################################################################
# Notes #

# Need to report out on requests made, answered, outstanding requests - perhaps colored based on how long left open?

# definately want to add the ability to export to csv/Excel from the tables. See if possible in GT, otherwise need to use DT 
# (see https://rstudio.github.io/DT/extensions.html) for that particular extension 

# Adding the ability to download data from the app (https://shiny.rstudio.com/articles/download.html)  
# Doesn't have to be from the specific table

# Have to make sure that links are to surveys are included in the app where relevant to re-route. 

# Ensure that blank values from Ona come through as NA

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

### Data pipeline

#########################################################################################################

# Historical Data #

equip_info <- read_csv(file = "https://ona.io/pacafenet/99874/460026/download.csv?data-type=dataset") %>% 
  rename(latitude = `_equip_location_latitude`,
         longitude = `_equip_location_longitude`,
         submission_time = "_submission_time",
         submitted_by = "_submitted_by") %>% 
  select(1:15, 17:18, 24, 29) %>% 
  arrange(equip_id, desc(submission_time)) %>%  
  group_by(equip_id) %>% 
  mutate(equip_type = if_else(condition = is.na(equip_type),
                              true = lead(equip_type),
                              false = equip_type),
         manufacturer = if_else(condition = is.na(manufacturer),
                                true = lead(manufacturer),
                                false = manufacturer),
         manufacture_date = if_else(condition = is.na(manufacture_date),
                                    true = lead(manufacture_date),
                                    false = manufacture_date),
         date_active = if_else(condition = is.na(date_active),
                               true = lead(date_active),
                               false = date_active),
         facility = if_else(condition = is.na(facility),
                            true = lead(facility),
                            false = facility),
         ownership_type = if_else(condition = is.na(ownership_type),
                                  true = lead(ownership_type),
                                  false = ownership_type),
         lab_level = if_else(condition = is.na(lab_level),
                             true = lead(lab_level),
                             false = lab_level),
         lab_level_is_other = if_else(condition = is.na(lab_level_is_other),
                                      true = lead(lab_level_is_other),
                                      false = lab_level_is_other),
         calib_engineer_nm = if_else(condition = is.na(calib_engineer_nm),
                                     true = lead(calib_engineer_nm),
                                     false = calib_engineer_nm),
         calib_engineer_post = if_else(condition = is.na(calib_engineer_post),
                                       true = lead(calib_engineer_post),
                                       false = calib_engineer_post),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration),
                                           true = lead(most_recent_calibration),
                                           false = most_recent_calibration),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance),
                                           true = lead(most_recent_maintenance),
                                           false = most_recent_maintenance),
         maintenance_engineer_nm = if_else(condition = is.na(maintenance_engineer_nm),
                                           true = lead(maintenance_engineer_nm),
                                           false = maintenance_engineer_nm),
         maintenance_engineer_post = if_else(condition = is.na(maintenance_engineer_post),
                                             true = lead(maintenance_engineer_post),
                                             false = maintenance_engineer_post),
         latitude = if_else(condition = is.na(latitude),
                            true = lead(latitude),
                            false = latitude),
         longitude = if_else(condition = is.na(longitude),
                             true = lead(longitude),
                             false = longitude)) %>% 
  distinct(equip_id, .keep_all = T)

activity_info <- read_csv(file = "https://ona.io/pacafenet/99874/460087/download.csv?data-type=dataset") %>% 
  rename(submission_time = "_submission_time",
         submitted_by = "_submitted_by",
         equip_id = "Equipment_ID") %>% 
  select(1:8, 12, 17) %>% 
  arrange(equip_id, desc(submission_time)) %>%
  group_by(equip_id) %>% 
  mutate(calib_engineer_nm = if_else(condition = is.na(calib_engineer_nm),
                                     true = lead(calib_engineer_nm, n = 1),
                                     false = calib_engineer_nm),
         calib_engineer_post = if_else(condition = is.na(calib_engineer_post),
                                       true = lead(calib_engineer_post, n = 1),
                                       false = calib_engineer_post),
         most_recent_calibration = if_else(condition = is.na(most_recent_calibration),  
                                           true = lead(most_recent_calibration, n = 1),
                                           false = most_recent_calibration),
         maintenance_engineer_nm = if_else(condition = is.na(maintenance_engineer_nm),  
                                           true = lead(maintenance_engineer_nm, n = 1),
                                           false = maintenance_engineer_nm),
         maintenance_engineer_post = if_else(condition = is.na(maintenance_engineer_post),  
                                             true = lead(maintenance_engineer_post, n = 1),
                                             false = maintenance_engineer_post),
         most_recent_maintenance = if_else(condition = is.na(most_recent_maintenance),  
                                           true = lead(most_recent_maintenance, n = 1),
                                           false = most_recent_maintenance),
         retirement_flag = if_else(condition = is.na(retirement_flag),  
                                   true = lead(retirement_flag, n = 1),
                                   false = retirement_flag)) %>% 
  distinct(equip_id, .keep_all = T)

#########################################################################################################

#########################################################################################################

# Current State #

curr_data <- left_join(x = equip_info, y = activity_info, by = "equip_id", suffix = c(".info",".activity")) %>% 
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
         submitted_by = if_else(condition = is.na(submitted_by.activity),
                                true = submitted_by.info,
                                false = submitted_by.activity),
         latitude = as.numeric(latitude),
         longitude = as.numeric(longitude),
         retirement_flag = if_else(condition = is.na(retirement_flag),
                                            true = "No",
                                            false = retirement_flag),
         retirement_flag = if_else(condition = retirement_flag == "Yes",
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

curr_data_activity_req <- full_join(x = calib_req_info, y = maintenance_req_info, by = "equip_id", suffix = c("_calib", "_maint")) %>% 
  mutate(submitted_by = if_else(condition = is.na(submitted_by_calib),
                                true = submitted_by_maint,
                                false = submitted_by_calib)) %>% 
  select(-submitted_by_calib, -submitted_by_maint) %>% 
  right_join(x = ., y = curr_data, by = "equip_id") %>%  # Here's the issue 
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
         submitted_by = submitted_by.y) %>% 
  select(-submitted_by.x, -submitted_by.y)

#########################################################################################################

# Application # 

ui <- dashboardPage(
  
  dashboardHeader(title = "Equipment Maintenance Tracking Inventory",
                  titleWidth = 750),
  
  # Consider changing this, there are some pretty flexible layouts possible
  dashboardSidebar(width = 300,
                   
                   sidebarMenu(id = "tabs",
                     
                     # This is where the tabs for each thing I want to show in the app need to go
                     
                     h4("Report View"),  # May decide to get rid of this, or could change the look up a bit 
                     
                     # SHOULD be able to use curr_data_activity_req for all these
                     
                     menuItem(text = "Equipment Report Overview",
                              tabName = "overview_info",
                              icon = icon("chart-line")),
                     
                     menuItem(text = "Equipment Details",  # The one I'm currently working on
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
    
    tabItems(  # Has to hold the layout for each item I want to show for each tab specified ^^
      
      tabItem(tabName = "overview_info",
              
              h4("Test Page 1")
              
              ),
      
      tabItem(tabName = "equip_details",
              
              fluidRow(  # There could be room to add more later 
                
                column(width = 4,
                  pickerInput(inputId = "equipment_type",
                              label = "Choose Equipment Type(s):",
                              choices = sort(unique(curr_data_activity_req$equip_type)),
                              selected = sort(unique(curr_data_activity_req$equip_type)),
                              multiple = T,
                              options = list(`actions-box` = T,
                                             `live-search` = T))
                ),
                column(width = 4,
                       pickerInput(inputId = "facility",
                                   label = "Choose Facilitie(s):",
                                   choices = sort(unique(curr_data_activity_req$facility)),
                                   selected = sort(unique(curr_data_activity_req$facility)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                ),
                column(width = 4,
                       pickerInput(inputId = "submitted_by",
                                   label = "Choose Survey Respondent(s):",
                                   choices = sort(unique(curr_data_activity_req$submitted_by)),
                                   selected = sort(unique(curr_data_activity_req$submitted_by)),
                                   multiple = T,
                                   options = list(`actions-box` = T,
                                                  `live-search` = T))
                )
              ),
              
              # Need to add a download button as well 
              
              fluidRow(gt_output("equip_details_table"))
            
              ),  # An individual layout for one of the tabs
      
      tabItem(tabName = "equip_activity_details",
              
              h4("Test Page 3")
              
              ),
      
      tabItem(tabName = "equip_activity_requests",
              
              h4("Test Page 4")
              
              )
      
    )
    
  )
  
)

server <- function(input, output, session) {
  
  output$equip_details_table <- render_gt({
    
    tt <- curr_data_activity_req %>%   
      filter(equip_type %in% c(input$equipment_type) &
               facility %in% c(input$facility) &
               submitted_by %in% c(input$submitted_by)  # Filters aren't working because of this one
             ) %>%
      gt() %>% 
      cols_align(align = "center") %>%
      cols_hide(columns = vars(calibration_request_date,
                               submission_time_calib,
                               maintenance_request_date,
                               submission_time_maint,
                               lab_level_is_other,
                               latitude,
                               longitude,
                               # retirement_flag,
                               most_recent_calibration,
                               most_recent_maintenance,
                               expected_retirement_date,
                               next_expected_calibration,
                               next_expected_maintenance,
                               activity_required_calib,
                               activity_required_maint)) %>%  
      cols_move(columns = vars(ownership_type),
                after = vars(lab_level)) %>%  
      cols_move(columns = vars(retirement_flag),
                after = vars(maintenance_engineer_post)) %>%  
      cols_label(equip_id = "Equipment ID", 
                 submitted_by = "Submitted by",
                 equip_type = "Equipment Type",
                 manufacturer = "Manufacturer",
                 manufacture_date = "Manufacture Date",
                 date_active = "Date Active",  # This date is getting squeezed, aparently cols_width is a thing need to update gt
                 facility = "Facility",
                 ownership_type = "Ownership Type",
                 lab_level = "Facility Level", 
                 calib_engineer_nm = "Calibration Engineer Name",
                 calib_engineer_post = "Calibration Engineer Post", 
                 maintenance_engineer_nm = "Maintenance Engineer Name",
                 maintenance_engineer_post = "Maintenance Engineer Post",
                 retirement_flag = "Retirement Flag") %>%  # Rename the columns
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
  
}

shinyApp(ui = ui, server = server)


























































