hello <- function() {
  "Hello, world!"
}

echo <- function(msg) {
  list(msg = paste0("The message is: ", msg))
}

n_plot <- function(n) {
  n <- as.numeric(n)
  if (n > 1e6) stop("n must be less than or equal to 1e6", call. = FALSE)
  hist(rnorm(n))
}

add <- function(x, y) {
  x <- as.numeric(x)
  y <- as.numeric(y)
  if (is.na(x) | is.na(y)) stop("Invalid input", call. = FALSE)
  x + y
}
