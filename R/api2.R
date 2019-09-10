delay <- function(max_s = 1, fail = 0, req, res) {
  max_s <- as.numeric(max_s)
  s <- runif(1, max = max_s)
  Sys.sleep(s)
  # Randomly fail certain responses
  res$status <- if(runif(1) <= as.numeric(fail)) 404 else 200
  list(msg = paste0("Slept for ", s, " seconds"))
}
