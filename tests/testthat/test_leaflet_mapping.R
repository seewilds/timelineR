context("Test Leaflet Map and Annotations")

t <- eq_map(usa_hurricanes, annot_col = 'DATE')

test_that("t is a list", {
  expect_true(typeof(t) == "list")
})

t <- usa_hurricanes%>%eq_create_label(.)%>%eq_map(annot_col = 'popup_text')
test_that("t is a list", {
  expect_true(typeof(t) == "list")
})