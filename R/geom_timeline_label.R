#' @inheritParams ggplot2-ggproto
StatTimelabel <- ggplot2::ggproto("StatTimelabel", ggplot2::Stat, 
                        compute_group = function(data, scales) {
                          df <- data%>%filter(x >= xmin)
                          ifelse( c("n_max", "label") %in% colnames(df), df <- df%>%dplyr::arrange(dplyr::desc(n_max_arrange))%>%dplyr::slice(1:n_max[1]), df)
                          df
                        },
                        required_aes = c("x", "xmin"),
                        optional_aes = c("n_max", "n_max_arrange", "label")
)

#' @inheritParams geom_timeline_label
stat_timelabel <- function(mapping = NULL, data = NULL, geom = "timelabel",
                          position = "identity", show.legend = TRUE, 
                          outliers = TRUE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    stat = StatTimelabel, 
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
draw_panel_function_line <- function(data, panel_scales, coord) {
  ifelse( "y" %in% colnames(data), data$y <- data$y, data$y <- rep(1/3, nrow(data)))
  coords <- coord$transform(data, panel_scales) 
  #str(coords)
  segs = grid::segmentsGrob(y0 = grid::unit(coords$y, "npc") + grid::unit(coords$size*3, "points"), 
                        y1 = grid::unit(coords$y * ggplot2::.pt / 2.5, "npc"),
                        x0 = grid::unit(coords$x, "npc"),
                        x1 = grid::unit(coords$x, "npc"),
                        default.units = "npc",
                        gp = grid::gpar(lwd = coords$size))
  
        texts = grid::textGrob(
                        coords$label,
                        y = grid::unit(coords$y * .pt / 2.5, "npc"),
                        x = grid::unit(coords$x, "npc"),
                        rot = 45,
                        just = c("left", "bottom"),
                        gp = grid::gpar(fontsize = coords$fontsize))

  grid::gTree(children = grid::gList(segs, texts))
  
}
#' @inheritParams ggplot2-ggproto
GeomTimelabel <- ggplot2::ggproto("GeomTimelabel", ggplot2::Geom,
                        required_aes = c("x", "xmin"),
                        optional_aes = c("n_max", "label", "n_max_arrange"),
                        default_aes = ggplot2::aes(lwd=1, col = "black", fontsize = 8),
                        draw_key = ggplot2::draw_key_point,
                        draw_panel = draw_panel_function_line
)
#' geom_timeline_label
#' 
#' Geom for labelling for geom_timeline
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
#' geom_timeline_label understands the following aesthetics (required aesthetics 
#' are in bold):
#' \itemize{
#'  \item{\strong{"x"}}{column of date values}
#'  \item{\strong{"xmin"}}{date to start plot, ending at last date}
#'  \item{\strong{"label"}}{column of labels to plot}
#'  \item{\strong{"n_max"}}{maximum number of labels to plot}
#'  \item{\strong{"n_max_arrange"}}{column used to organize, in descending order, n_max labels}
#'  \item{"lwd"}{desired color, entered as a single string, or on column}
#'  \item{"col"}{sets colour}
#'  \item{"fontsize"}{sets fontsize}
#' }
#' @return gglist
#'
#' @examples
#' \donttest{ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) + geom_timeline(aes(xmin =as.Date("1990-01-01"))) + geom_timeline_label(aes(xmin =as.Date("1990-01-01"), label = LOCATION_NAME))}
#' 
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "timelabel", 
                          position = "identity", show.legend = FALSE, 
                          na.rm = FALSE, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    data = data, 
    mapping = mapping,
    stat = stat,
    geom = GeomTimelabel,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}