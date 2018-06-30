#' @inheritParams ggplot2-ggproto
StatTimelabel <- ggplot2::ggproto("StatTimelabel", ggplot2::Stat, 
                        compute_group = function(data, scales) {
                          df <- data%>%filter(x>=xmin)
                          ifelse( "n_max" %in% colnames(data), df <- data%>%arrange(EQ_PRIMARY)%>%slice(1:n_max), df)
                          df
                        },
                        required_aes = c("x", "xmin"),
                        optional_aes = c("n_max")
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

draw_panel_function_line <- function(data, panel_scales, coord) {
  ifelse( "y" %in% colnames(data), data$y <- data$y, data$y <- rep(1/3, nrow(data)))
  coords <- coord$transform(data, panel_scales) 
  str(coords)
  segs = grid::segmentsGrob(y0 = unit(coords$y, "native"), 
                        y1 = unit(coords$y + 0.05, "native"),
                        x0 = unit(coords$x, "native"),
                        x1 = unit((coords$x), "native"),
                        default.units = "native",
                        gp = grid::gpar(lwd = coords$size))
  
        texts = grid::textGrob(
                        coords$label,
                        y = unit(coords$y + 0.05, "npc"),
                        x = unit(coords$x, "npc"),
                        rot = 45,
                        just = c("left", "bottom"),
                        gp = grid::gpar(fontsize = coords$fontsize))

  grid::gTree(children = grid::gList(segs, texts))
  
}

#' @inheritParams ggplot2-ggproto
GeomTimelabel <- ggplot2::ggproto("GeomTimelabel", ggplot2::Geom,
                        required_aes = c("x", "xmin", "label"),
                        optional_aes = c("n_max"),
                        default_aes = ggplot2::aes(lwd=1, col = "red", fontsize = 8),
                        draw_key = ggplot2::draw_key_point,
                        draw_panel = draw_panel_function_line
)

#' geom_timeline_label
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
#' geom_timeline_label understands the following aesthetics (required aesthetics 
#' are in bold):
#' \itemize{
#'  \item{\strong{"x"}}{column of longitude values}
#'  \item{\strong{"xmin"}}{column of latitude values}
#'  \item{\strong{"label"}}{column of North West maximum wind radial extent, in 
#'  nautical miles}
#'  \item{"n_max"}{not recommended}
#'  \item{"lwd"}{desired color, entered as a single string, or on column}
#'  \item{"col"}{sets tranparency}
#'  \item{"fontsize"}{not recommended}
#' }
#' @return
#'
#' @examples
#' \donttest{ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) + geom_timeline(aes(xmin =as.Date("1990-01-01"))) + geom_timeline_label(aes(xmin =as.Date("1990-01-01"), label = LOCATION_NAME))}
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "timelabel", 
                          position = "identity", show.legend = FALSE, 
                          na.rm = FALSE, inherit.aes = TRUE, ...) {
  layer(
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