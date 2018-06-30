#' @inheritParams ggplot2-ggproto
StatTimeline <- ggplot2::ggproto("StatTimeline", ggplot2::Stat, 
                         compute_group = function(data, scales) {
                           df <- data%>%filter(x>=xmin)
                           df
                         },
                         required_aes = c("x", "xmin"),
                         optional_aes = c("y")
)

#' @inheritParams geom_timeline
stat_timeline<- function(mapping = NULL, data = NULL, geom = "timeline",
                           position = "identity", show.legend = TRUE, 
                           outliers = TRUE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatTimeline, 
    data = data, 
    mapping = mapping, 
    geom = geom, 
    position = position, 
    show.legend = show.legend, 
    inherit.aes = inherit.aes,
    params = params
  )        
}

draw_panel_function <- function(data, panel_scales, coord) {
  ifelse( "y" %in% colnames(data), data$y <- data$y, data$y <- rep(1/3, nrow(data)))
  
  coords <- coord$transform(data, panel_scales) 
  str(coords)
  liness = grid::segmentsGrob(y0 = unit(c(coords$y, coords$y), "native"), y1 = unit(c(coords$y, coords$y), "native"))
  
  dots = grid::pointsGrob(
    x = coords$x,
    y = coords$y,
    pch = coords$shape,
    default.units = "native",
    size = unit(coords$size, "points"),
    gp = grid::gpar(fill = coords$fill, col = coords$col, alpha = coords$alpha, stroke = coords$stroke)
  )
  grid::gTree(children = grid::gList(liness, dots))
  
}

#' @inheritParams ggplot2-ggproto
GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::Geom,
                         required_aes = c("x", "xmin"),
                         default_aes = ggplot2::aes(shape= 21, col = "black", fill = "red", alpha = 1, stroke=1, size = 10),
                         draw_key = ggplot2::draw_key_point,
                         draw_panel = draw_panel_function
)

#' geom_timeline
#'
#' @param mapping 
#' @param data 
#' @param stat 
#' @param position 
#' @param show.legend 
#' @param na.rm 
#' @param inherit.aes 
#' @param ...
#' 
#' @section Aesthetics:
#' geom_timeline understands the following aesthetics (required aesthetics 
#' are in bold):
#' \itemize{
#'  \item{\strong{"x"}}{column of longitude values}
#'  \item{\strong{"xmin"}}{column of latitude values}
#'  \item{"y"}{column of North West maximum wind radial extent, in 
#'  nautical miles}
#'  \item{"shape"}{not recommended}
#'  \item{"col"}{desired color, entered as a single string, or on column}
#'  \item{"fill"}{sets tranparency}
#'  \item{"alpha"}{not recommended}
#' } 
#'
#' @return
#' 
#' @examples
#' \donttest{usa_hurricanes <- final_hurricanes%>%filter(COUNTRY == "USA")
#' ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) + geom_timeline(aes(xmin =as.Date("1999-01-01")))}
#' 
#' @export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "timeline", 
                          position = "identity", show.legend = TRUE, 
                          na.rm = FALSE, inherit.aes = TRUE, ...) {
  layer(
    data = data, 
    mapping = mapping,
    stat = stat,
    geom = GeomTimeline,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}