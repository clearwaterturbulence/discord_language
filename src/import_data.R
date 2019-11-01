library(tidyverse)

extract_server <- function(flnm) {
  str_extract(flnm, pattern = ".+(?= - )")
}

extract_channel <- function(flnm) {
  str_extract(flnm, pattern = "(?<= - ).+(?= \\[)")
}

read_csv_discord <- function(flnm) {
  read_delim(flnm, delim = ";", col_types = cols_only(
    AuthorID = col_double(),
    Author = col_character(),
    Date = col_datetime(format = ""),
    Content = col_character(),
    Attachments = col_character(),
    Reactions = col_character()
  )) %>% mutate(Server = extract_server(basename(flnm)), Channel = extract_channel(flnm))
}

suppressWarnings(raw_data <- list.files(path = "./data/raw", recursive = TRUE, include.dirs = FALSE, full.names = TRUE) %>% map_df(~read_csv_discord(.)))

write_rds(raw_data, "./data/raw/raw_data.RDS")