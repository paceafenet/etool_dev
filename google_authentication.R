library(googlesheets)  # May just want to call these explicitly from the package

## prepare the OAuth token and set up the target sheet:
##  - do this interactively
##  - do this EXACTLY ONCE

# shiny_token <- gs_auth() # authenticate w/ your desired Google identity here
# saveRDS(shiny_token, "shiny_app_token.rds")

gs_auth(token = "shiny_app_token.rds")  # Use henceforth
my_sheets <- gs_ls()

sheet_key <- my_sheets$sheet_key[1]  # Fake data key, refer to a different key for other data
ss <- gs_key(sheet_key)  # Defines the sheet I want to interact with

# Reading the data as it is currently, this is what I'll want to refer to in the server function

ss_data <- gs_read_csv(ss)  # Pulls the data as a df, may need to manipulate the data types, but can worry about that later