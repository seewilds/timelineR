#' @inheritParams ggplot2-theme
#' 
#' @export
theme_timeline <- function(...){
  ggplot2::theme_minimal(...) + ggplot2::theme(legend.position = "bottom", axis.title.y = element_blank(), axis.line.x = element_line(color="black", size = 0.5))
}