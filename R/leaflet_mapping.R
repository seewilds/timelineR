#' eq_map
#'
#' @param df a data frame
#' @param annot_col column to take annotations from
#'
#' @return leaflet map
#' 
#' @examples
#' \donttest{eq_map(usa_hurricanes, annot_col = 'DATE')}
#' 
#' @export
eq_map <- function(df, annot_col){
  m <- leaflet::leaflet()#%>%
  m <- leaflet::addTiles(m)#%>%
  m <- leaflet::addCircleMarkers(map = m, data = df, radius = ~EQ_PRIMARY, lng = ~LONGITUDE, lat = ~LATITUDE, popup = ~paste(eval(parse(text = annot_col))))
  m
  }
#' eq_create_label
#'
#' @param df a data frame
#'
#' @return data frame with column of annotations
#' 
#' @examples
#' \donttest{usa_hurricanes%>%eq_create_label(.)%>%eq_map(annot_col = 'popup_text')}
#' 
#' @export
eq_create_label <- function(df){
  df$popup_text <- ""
  df$popup_text <- ifelse(!is.na(df$LOCATION),
                          paste(df$popup_text,
                                "<b>Location:</b>", df$LOCATION, "<br />"),
                          df$popup_text)
  df$popup_text <- ifelse(!is.na(df$EQ_PRIMARY),
                          paste(df$popup_text,
                                "<b>Magnitude:</b>", df$EQ_PRIMARY, "<br />"),
                          df$popup_text)
  df$popup_text <- ifelse(!is.na(df$TOTAL_DEATHS),
                          paste(df$popup_text,
                                "<b>Total Deaths:</b>", df$TOTAL_DEATHS, "<br />"),
                          df$popup_text)
  return(df)
}