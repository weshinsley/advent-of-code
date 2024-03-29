parse_input1 <- function(f) {
  x <- readLines(f)
  list(time = as.integer(strsplit(x[1], "\\s+")[[1]][-1]),
       dist = as.integer(strsplit(x[2], "\\s+")[[1]][-1]))
}

parse_input2 <- function(f) {
  x <- readLines(f)
  list(
    time = as.numeric(paste0(strsplit(x[1], "\\s+")[[1]][-1], collapse = "")),
    dist = as.numeric(paste0(strsplit(x[2], "\\s+")[[1]][-1], collapse = "")))
}

race <- function(d) {
  res <- 1
  for (i in seq_along(d$time)) {
    hold <- 1:(d$time[i] - 1)
    dist <- (d$time[i] - hold) * hold
    res <- res * sum(dist > d$dist[i])
  }
  res
}

part1 <- function(f) {
  race(parse_input1(f))
}
part2 <- function(f) {
  race(parse_input2(f))
}


test <- function() {
  stopifnot(part1("../inputs/d06-test.txt") == 288)
  stopifnot(part2("../inputs/d06-test.txt") == 71503)
}

test()
part1("../inputs/d06-input.txt")
part2("../inputs/d06-input.txt")
