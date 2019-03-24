
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
library(shinydashboard)
library(dashboardthemes)

googlesheets::gs_auth(token = "shiny_app_token.rds")
my_sheets <- googlesheets::gs_ls()

sheet_key <- my_sheets$sheet_key[1]
ss <- googlesheets::gs_key(my_sheets$sheet_key[1])

start_data <- googlesheets::gs_read_csv(ss) %>% 
    arrange(serial_num, desc(last_altered)) %>%
    distinct(serial_num, .keep_all = T)

ui <- dashboardPage(
    
    dashboardHeader(title = "Submit New Equipment Data Below",
                    titleWidth = 450),
    
    dashboardSidebar(disable = T),
    
    dashboardBody(
        
        fluidRow(

            box(pickerInput(inputId = "equip_type",
                            label = "Select the Equipment Type:",
                            choices = sort(unique(start_data$equip_type)),
                            selected = sort(unique(start_data$equip_type))[1]),
                width = 2),
            
            box(numericInput(inputId = "serial_num",
                             label = "Type in the Equipment Identifier:",
                             value = 1),
                width = 2),

            box(selectizeInput(inputId = "manufacturer",
                               label = "Select the Manufacturer:",
                               choices = sort(unique(start_data$manufacturer)),
                               selected = sort(unique(start_data$manufacturer))[1],
                               options = list(create = T)),
                width = 2),
            
            box(pickerInput(inputId = "facility",
                            label = "Select the lab that will house the equipment:",
                            choices = sort(unique(start_data$facility)),
                            selected = sort(unique(start_data$facility))[1]),
                width = 2),
           
            box(pickerInput(inputId = "ownership_type",
                            label = "Select the ownership status of the equipment:",
                            choices = sort(unique(start_data$ownership_type)),
                            selected = sort(unique(start_data$ownership_type))[1]),
                width = 2),
           
            box(pickerInput(inputId = "lab_level",
                            label = "Select the lab's level:",
                            choices = sort(unique(start_data$lab_level)),
                            selected = sort(unique(start_data$lab_level))[1]),
                width = 2)
            
            ),
        
        fluidRow(
            
            box(selectizeInput(inputId = "calib_engineer_nm",
                               label = "Select the Calibration Engineer:",
                               choices = sort(unique(start_data$calib_engineer_nm)),
                               selected = sort(unique(start_data$calib_engineer_nm))[1],
                               options = list(create = T)),
                width = 3),
            
            box(selectizeInput(inputId = "calib_engineer_post",
                               label = "Select the Calibration Engineer's Post:",
                               choices = sort(unique(start_data$calib_engineer_post)),
                               selected = sort(unique(start_data$calib_engineer_post))[1],
                               options = list(create = T)),
                width = 3),
            
            box(selectizeInput(inputId = "maintenance_engineer_nm",
                               label = "Select the Maintenance Engineer:",
                               choices = sort(unique(start_data$maintenance_engineer_nm)),
                               selected = sort(unique(start_data$maintenance_engineer_nm))[1],
                               options = list(create = T)),
                width = 3),
            
            box(selectizeInput(inputId = "maintenance_engineer_post",
                               label = "Select the Maintenance Engineer's Post:",
                               choices = sort(unique(start_data$maintenance_engineer_post)),
                               selected = sort(unique(start_data$maintenance_engineer_post))[1],
                               options = list(create = T)),
                width = 3)
        ),
        
        fluidRow(
            box(dateInput(inputId = "manufacture_date",
                          label = "Select the Equipment Manufacture Date:",
                          value = Sys.Date(),
                          min = "2000-01-01"),
                width = 3),
            box(dateInput(inputId = "date_active",
                          label = "Select the Date the Equipment was made active:",
                          value = Sys.Date(),
                          min = "2000-01-01"),
                width = 3)
        ),
        
        fluidRow(
            useSweetAlert(),
            
            actionBttn(inputId = "new_data_button",
                       label = "Submit Equipment Data",
                       style = "pill")
            
        )
    )
)

server <- function(input, output, session) {
    
    new_data <- eventReactive(input$new_data_button,
                              {
                                  tt <- tibble(
                                      serial_num = input$serial_num,
                                      equip_type = input$equip_type,
                                      manufacturer = input$manufacturer,
                                      manufacture_date = input$manufacture_date,
                                      date_active = input$date_active,
                                      date_not_viable = input$manufacture_date + 730,
                                      facility = input$facility,
                                      ownership_type = input$ownership_type,
                                      lab_level = input$lab_level,
                                      calib_engineer_nm = input$calib_engineer_nm,
                                      calib_engineer_post = input$calib_engineer_post,
                                      most_recent_calibration = "",
                                      next_calibration = input$date_active + 90,
                                      most_recent_maintenance <- "",
                                      next_maintenance = input$date_active + 180,
                                      maintenance_engineer_nm = input$maintenance_engineer_nm,
                                      maintenance_engineer_post = input$maintenance_engineer_post,
                                      retirement_date = input$date_active + 720,
                                      retirement_requested = "",
                                      retirement_dt_requested = "",
                                      last_altered = ymd_hms(Sys.time())
                                  ) %>% 
                                      mutate(long = if_else(condition = input$facility == "Lab",
                                                            true = "11.502075200000036",
                                                            false = if_else(condition = input$facility == "Lab1",
                                                                            true = "9.767868700000008",
                                                                            false = "3.379205700000057")),
                                             lat = if_else(condition = input$facility == "Lab",
                                                           true = "3.848032500000001",
                                                           false = if_else(condition = input$facility == "Lab1",
                                                                           true = "4.0510564",
                                                                           false = "6.5243793"))) %>% 
                                      mutate_all(as.character)
                              })
                              
    observeEvent(input$new_data_button, {
        sendSweetAlert(session = session,
                       title = "FYI:",
                       type = "info",
                       text = "You have successfully added equipment info. This change will be reflected next time you open the eTool.")
    })
    
    observeEvent(input$new_data_button,
                 {
                     googlesheets::gs_auth(token = "shiny_app_token.rds")
                     my_sheets <- googlesheets::gs_ls()

                     sheet_key <- my_sheets$sheet_key[1]
                     ss <- googlesheets::gs_key(my_sheets$sheet_key[1])

                     googlesheets::gs_add_row(ss = ss,
                                              input = new_data())
                 })
    
}

shinyApp(ui = ui, server = server)










