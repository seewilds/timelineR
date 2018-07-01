#' eq_map
#'
#' @param df 
#' @param annot_col 
#'
#' @return
#' 
#' 
#' @examples
#' \donttest{eq_map(usa_hurricanes, annot_col = 'DATE')}
#' 
#' @importFrom leaflet leaflet
#' @importFrom leaflet addTiles
#' @importFrom leaflet addCircleMarkers
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
#' @param df 
#'
#' @return
#' 
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