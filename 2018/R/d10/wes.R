advent10 <- function(input) {
  px <- as.integer(substring(input, 11, 16))
  py <- as.integer(substring(input,19,24))
  vx <- as.integer(substring(input,37,38))
  xrange <- max(px) - min(px)
  yrange <- max(py) - min(py)
  s <- 0
  while (TRUE) {
    px <- px + vx
    py <- py + vy
    xrange2 <- max(px) - min(px)
    yrange2 <- max(py) - min(py)
    if ((xrange2 > xrange) || (yrange2 > yrange)) {
      px <- px - vx
      py <- py - vy
      break
    }
    xrange <- xrange2
    yrange <- yrange2
    s <- s + 1
  }
  miny <- min(py)-1
  minx <- min(px)-1
  grid <- rep(list(rep(".", xrange+1)), yrange+1)
  for (i in seq_len(length(px))) grid[[py[i]-miny]][px[i]-minx] <- "#"
  for (i in seq_len(length(grid))) message(grid[[i]])
  s
}


input <- readLines("wes-input.txt")
advent10(input)

