parse_input <- function(f) {
  xsize <- nchar(readLines(f, n = 1))
  oneline <- strsplit(paste0(readLines(f), collapse = ""), "")[[1]]
  stars <- which(oneline == "#") - 1
  data.frame(x = (stars %% xsize), y = (stars %/% xsize))
}

expansion <- function(stars, m) {
  m <- m - 1
  expand <- function(points) {
    all_points <- seq_len(max(points))
    gaps <- rev(all_points[!all_points %in% points])
    for (gap in gaps) {
      move <- points > gap
      points[move] <- points[move] + m
    }
    points
  }
  data.frame(x = expand(stars$x), y = expand(stars$y))
}

part1 <- function(d, m = 2) {
  sum(dist(expansion(d, m), "manhattan"))
}

part2 <- function(d) {
  part1(d, 1000000)
}

test <- function() {
  d <- parse_input("../inputs/d11-test.txt")
  stopifnot(part1(d) == 374)
  stopifnot(part1(d, 10) == 1030)
  stopifnot(part1(d, 100) == 8410)
}

test()
d <- parse_input("../inputs/d11-input.txt")
part1(d)
part2(d)
