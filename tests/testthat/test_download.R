context("Download and Cleaning")

all_hurricanes <- download_sed()
test_that("download is a data.frame", {
  expect_true(class(all_hurricanes) == "data.frame")
})

all_hurricanes_clean <- eq_clean_data(all_hurricanes)
test_that("all_hurricanes_clean is a data.frame", {
  expect_true(class(all_hurricanes_clean) == "data.frame")
})

final_hurricanes <- eq_location_clean(all_hurricanes_clean)
test_that("final_hurricanes is a data.frame", {
  expect_true(class(final_hurricanes) == "data.frame")
})