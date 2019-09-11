delay <- function(max_s = 1, fail = 0, req, res) {
  max_s <- as.numeric(max_s)
  s <- stats::runif(1, max = max_s)
  Sys.sleep(s)
  # Randomly fail certain responses
  res$status <- if(stats::runif(1) <= as.numeric(fail)) 404 else 200
  list(msg = paste0("Slept for ", s, " seconds"))
}

#' Run API 2
#'
#' @param ... Options passed to \code{plumber::plumb()$run()}
#' @examples
#' \dontrun{
#' run_api2()
#' run_api2(swagger = TRUE, port = 8000)
#' }
#' @return A running Plumber API
#' @export
run_api2 <- function(...) {
  plumber::plumb(dir = system.file("plumber", "api2", package = "plumbpkg"))$run(...)
}
