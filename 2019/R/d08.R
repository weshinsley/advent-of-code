part1 <- function(input, wid, hei) {
  per_layer <- wid * hei
  layers <- nchar(input) / per_layer
  least_zeroes <- per_layer
  best_answer <- 0
  for (layer in seq(0, layers - 1)) {
    this_layer <- as.numeric(unlist(strsplit(
      substring(input, 1+(layer * per_layer), ((layer + 1) * per_layer)), "")))
    n0 <- sum(this_layer == 0)
    if (n0 < least_zeroes) {
      least_zeroes <- n0
      best_answer <- sum(this_layer == 1) * sum(this_layer == 2)
    }
  }
  best_answer
}

data_frame <- function(...) {
  data.frame(stringsAsFactors = FALSE, ...)
}

part2 <- function(input, wid, hei) {
  per_layer <- wid * hei
  white <- NULL
  black <- NULL
  for (x in seq_len(wid)) {
    for (y in seq_len(hei)) {
      pixel <- (wid * (y-1)) + x
      while (substring(input, pixel, pixel) == '2') {
        pixel <- pixel + per_layer
      }
      if (substring(input, pixel, pixel) == '0') {
        black <- rbind(black, data_frame(x = x, y = y))
      } else {
        white <- rbind(white, data_frame(x = x, y = y))
      }
    }
  }
  png("wes.png")
  plot(x = white$x, y = -white$y, type="p",xlim = c(-5, 30), ylim = c(-15,5),
       pch = 15, cex=3, main="Part 2", xlab="", ylab="")
  dev.off()
  Sys.sleep(1)
  browseURL("wes.png")
}

input <- readLines("../inputs/input_8.txt")
c(part1(input, 25, 6), part2(input, 25, 6))
