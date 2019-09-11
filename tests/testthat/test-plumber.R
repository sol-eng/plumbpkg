# Setup by starting APIs
root_path <- "http://localhost"

api1 <- callr::r_bg(
  function() {
    pr <- plumber::plumb(system.file("plumber", "api1", "plumber.R", package = "plumbpkg"))
    pr$run(port = 8000)
  }
)

api2 <- callr::r_bg(
  function() {
    pr <- plumber::plumb(dir = system.file("plumber", "api2", package = "plumbpkg"))
    pr$run(port = 8001)
  }
)

Sys.sleep(5)

teardown({
  api1$kill()
  api2$kill()
})

test_that("API is alive", {
  expect_true(api1$is_alive())
  expect_true(api2$is_alive())
})


test_that("hello endpoint works", {
  # Send API request
  r <- httr::GET(root_path, port = 8000, path = "hello")

  # Check response
  expect_equal(r$status_code, 200)
  expect_equal(httr::content(r, encoding = "UTF-8"), list("Hello, world!"))
})

test_that("echo endpoint works", {
  # Send API request
  r <- httr::GET(root_path, port = 8000, path = "echo", query = list(msg = "Hello World"))

  # Check response
  expect_equal(r$status_code, 200)
  expect_equal(httr::content(r, encoding = "UTF-8"), list(msg = list("The message is: Hello World")))
})

test_that("plot endpoint works", {
  # Send API request
  r <- httr::GET(root_path, port = 8000, path = "plot", query = list(n = 500))
  r_bad <- httr::GET(root_path, port = 8000, path = "plot", query = list(n = 1e7))

  # Check response
  expect_equal(r$status_code, 200)
  expect_equal(r_bad$status_code, 500)
})

test_that("add endpoint works", {
  # Send API request
  r <- httr::GET(root_path, port = 8000, path = "add", query = list(x = 3, y = 4))
  r_bad <- httr::GET(root_path, port = 8000, path = "add", query = list(x = 3, y = "a"))

  # Check response
  expect_equal(r$status_code, 200)
  expect_equal(r_bad$status_code, 500)
  expect_equal(httr::content(r, encoding = "UTF-8"), list(7))
})

test_that("delay endpoint works", {
  # Send API request
  r <- httr::GET(root_path, port = 8001, path = "delay", query = list(max_s = 2, fail = 0))
  r_fail <- httr::GET(root_path, port = 8001, path = "delay", query = list(max_s = 0, fail = 1))

  # Check response
  expect_equal(r$status_code, 200)
  expect_equal(r_fail$status_code, 404)
  expect_match(unlist(httr::content(r, encoding = "UTF-8")), "Slept for [0-9.]+ seconds")
  expect_match(unlist(httr::content(r_fail, encoding = "UTF-8")), "Slept for 0 seconds")
})
