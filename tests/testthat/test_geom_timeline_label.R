context("Test Timeline Label stat and geom")

t <- ggplot(data = usa_hurricanes, aes(DATE, COUNTRY)) + geom_timeline(aes(xmin =as.Date("1999-01-01")))  + geom_timeline_label(aes(xmin =as.Date("1990-01-01"), label = LOCATION_NAME))

test_that("t is a list", {
  expect_true(typeof(t) == "list")
})