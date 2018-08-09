#' theme_timeline
#' 
#' dedicated theme for use with the timelineR package.
#' 
#' @inheritParams ggplot2::theme
#' 
#' @export
theme_timeline <- function(...){
  ggplot2::theme_minimal(...) + ggplot2::theme(legend.position = "bottom", axis.title.y = ggplot2::element_blank(), axis.line.x = ggplot2::element_line(color="black", size = 0.5))
}