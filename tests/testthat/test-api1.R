test_that("hello works", {
  expect_equal(hello(), "Hello, world!")
})

test_that("echo works", {
  expect_equal(echo("Hello World"), list(msg = "The message is: Hello World"))
})

test_that("n_plot works", {
  expect_error(n_plot(1e7))
})

test_that("add works", {
  expect_equal(add(3, 2), 5)
  expect_equal(add("3", "2"), 5)
  expect_error(add("a", 4), "Invalid input")
})
