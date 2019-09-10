library(plumber)

#* @apiTitle Simple API

#* Return hello world
#* @get /hello
plumbpkg:::hello

#* Echo back the message provided
#* @param msg The message to echo
#* @get /echo
plumbpkg:::echo

#* Plot histogram of n random points
#* @param n Number of random points. Must not be larger than 1e6.
#* @png
#* @get /plot
plumbpkg:::n_plot

#* Add two values together
#* @param x First value
#* @param y Second value
#* @get /add
plumbpkg:::add
