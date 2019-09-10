test_that("delay works", {
  r <- replicate(10, {
    tictoc::tic()
    delay(res = list())
    end <- tictoc::toc(quiet = TRUE)
    end$toc - end$tic
  })

  expect_true(max(r) <= 1)
})
