#' @inheritParams ggplot2-ggproto
StatTimeline <- ggplot2::ggproto("StatTimeline", ggplot2::Stat, 
                         compute_group = function(data, scales) {
                           df <- data%>%dplyr::filter(x >= xmin)
                           df
                         },
                         required_aes = c("x", "xmin"),
                         optional_aes = c("y")
)
#' @inheritParams geom_timeline
stat_timeline<- function(mapping = NULL, data = NULL, geom = "timeline",
                           position = "identity", show.legend = TRUE, 
                           outliers = TRUE, inherit.aes = TRUE, na.rm = TRUE,...) {
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
#'
draw_panel_function <- function(data, panel_scales, coord) {
  ifelse( "y" %in% colnames(data), data$y <- data$y, data$y <- rep(1/3, nrow(data)))
  
  coords <- coord$transform(data, panel_scales) 
  liness = grid::segmentsGrob(y0 = grid::unit(c(coords$y, coords$y), "npc"), 
                              y1 = grid::unit(c(coords$y, coords$y), "npc")
                              )
  
  dots = grid::pointsGrob(
    x = coords$x,
    y = coords$y,
    pch = coords$shape,
    default.units = "npc",
    size = grid::unit(coords$size * ggplot2::.pt + coords$stroke * ggplot2::.stroke /2, "points"),
    gp = grid::gpar(fill = ggplot2::ggplot2::alpha(coords$fill, coords$alpha), alpha(col = coords$col,coords$alpha), stroke = coords$stroke)
  )
  grid::gTree(children = grid::gList(liness, dots))
  
}
#' GeomTimeline
#' @inheritParams ggplot2-ggproto
GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::Geom,
                         required_aes = c("x", "xmin"),
                         default_aes = ggplot2::aes(shape= 21,  fill = "dodgerblue4", colour = "dodgerblue4", alpha = 1, stroke=1, size = 12),
                         draw_key = ggplot2::draw_key_point,
                         draw_panel = draw_panel_function
)
#' geom_timeline
#' 
#' Geom for mapping instances of an event over time.
#'
#' @param mapping Set of aesthetic mappings created by aes or aes_. 
#' If specified and inherit.aes = TRUE (the default), it is combined 
#' with the default mapping at the top level of the plot. You must 
#' supply mapping if there is no plot mapping.
#' @param data The data to be displayed in this layer. There are three 
#' options:
#' If NULL, the default, the data is inherited from the plot data as 
#' specified in the call to ggplot.
#' 
#' A data.frame, or other object, will 
#' override the plot data. All objects will be fortified to produce 
#' a data frame. See fortify for which variables will be created. 
#' 
#' A function will be called with a single argument, the plot data. 
#' The return value must be a data.frame., and will be used as the 
#' layer data.
#' @param stat The statistical transformation to use on the data for 
#' this layer, as a string.
#' @param position Position adjustment, either as a string, or the 
#' result of a call to a position adjustment function.
#' @param show.legend logical. Should this layer be included in the 
#' legends? NA, the default, includes if any aesthetics are mapped. 
#' FALSE never includes, and TRUE always includes.
#' @param na.rm If FALSE, the default, missing values are removed 
#' with a warning. If TRUE, missing values are silently removed.
#' @param inherit.aes If FALSE, overrides the default aesthetics, 
#' rather than combining with them. This is most useful for helper 
#' functions that define both data and aesthetics and shouldn't inherit 
#' behaviour from the default plot specification, e.g. borders.
#' @param ... other arguments passed on to layer. These are often aesthetics, 
#' used to set an aesthetic to a fixed value, like color = "red" or 
#' size = 3. They may also be parameters to the paired geom/stat.
#' 
#' @section Aesthetics:
#' geom_timeline understands the following aesthetics (required aesthetics 
#' are in bold):
#' \itemize{
#'  \item{\strong{"x"}}{column of date values}
#'  \item{\strong{"xmin"}}{date to start plot, ending at last date}
#'  \item{"y"}{optional stratification columns}
#'  \item{"shape"}{sets shape}
#'  \item{"col"}{desired color, entered as a single string, or on column}
#'  \item{"fill"}{sets fill}
#'  \item{"alpha"}{sets tranparency}
#' } 
#'
#' @return gglist
#' 
#' @examples
#' \donttest{usa_hurricanes <- final_hurricanes%>%filter(COUNTRY == "USA")
#' ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) + geom_timeline(aes(xmin =as.Date("1999-01-01")))}
#' 
#' @export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "timeline", 
                          position = "identity", show.legend = TRUE, 
                          na.rm = TRUE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
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