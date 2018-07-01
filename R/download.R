#' download_sed
#'
#'This function automatically downloads the database of hurricanes from the
#'National Centres for Environmental Information, compiled by the National
#'Oceanic and Atmospheric Administration (NOAA).
#'
#' @return function returns a data frame with all observations contained in
#' the NOAA hurricane database
#'
#' @examples
#' \donttest{all_hurricanes <- download_sed()}
#'
#' @export
download_sed <- function(){
  read.table("https://www.ngdc.noaa.gov/nndc/struts/results?type_0=Exact&query_0=$ID&t=101650&s=13&d=189&dfn=signif.txt", sep = "\t", header = TRUE, fill =TRUE, quote = "", stringsAsFactors = FALSE)
}

#' eq_clean_data
#'
#' Takes the data frame downloaded from the NOAA and cleans it:
#' converts lattitute and longitude to numeric types, and creates a DATE
#' column.
#'
#' @param df a data frame to be cleaned
#'
#' @return This function returns a cleaned data frame.
#'
#' @examples
#' \donttest{all_hurricanes_clean <- eq_clean_data(all_hurricanes)}
#'
#' @export
eq_clean_data <- function(df){
  df$LATITUDE <- as.integer(df$LATITUDE)
  df$LONGITUDE <- as.integer(df$LONGITUDE)
  df$MONTH[is.na(df$MONTH)] <- 01
  df$DAY[is.na(df$DAY)] <- 01
  df$DATE <- julian(x = df$MONTH,  d = df$DAY, y = df$YEAR)
  df$DATE <- as.Date(df$DATE, origin = "1970-01-01")
  df
}

#' eq_location_clean
#'
#' This function takes the NOAA hurricane data and cleans the LOCATION_NAME
#' column.
#'
#' @param df a data frame with LOCATION_DATA column to be cleaned.
#'
#' @return a data frame with extraneous data removed from column
#' LOCATION_NAME.
#'
#' @examples
#' \donttest{final_hurricanes <- eq_location_clean(all_hurricanes_clean)}
#'
#' @export
eq_location_clean <- function(df){
  df$LOCATION_NAME <- gsub("^.*:", "", df$LOCATION_NAME)
  df$LOCATION_NAME <- gsub("^ *", "", df$LOCATION_NAME)
  df
}
