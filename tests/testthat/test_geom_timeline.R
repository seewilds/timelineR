context("Test Timeline Stat and Geom")

usa_hurricanes <- final_hurricanes%>%dplyr::filter(COUNTRY == "USA")
t <- ggplot2::ggplot(data = usa_hurricanes, ggpllot2::aes(DATE, COUNTRY)) + geom_timeline(ggplot2::aes(xmin =as.Date("1999-01-01")))

test_that("t is a list", {
  expect_true(typeof(t) == "list")
})