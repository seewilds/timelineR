context("Test Timeline Label stat and geom")

t <- ggplot2::ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) 
t <- t + geom_timeline(aes(xmin =as.Date("1999-01-01")))  
t <- t + geom_timeline_label(aes(xmin =as.Date("1990-01-01"), label = LOCATION_NAME))

test_that("t is a list", {
  expect_true(typeof(t) == "list")
})