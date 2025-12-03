d <- lapply(readLines("../inputs/input_2.txt"), function(x)
  as.numeric(unlist(strsplit(x, "x"))))

part1 <- function(d) {
  sum(unlist(lapply(d, function(x) {
    areas <- sort(c(x[1] * x[2], x[2] * x[3], x[3] * x[1]))
    (2 * sum(areas)) + areas[1]
  })))
}

part2 <- function(d) {
  sum(unlist(lapply(d, function(x) {
    x <- sort(x)
    x[1] + x[1] + x[2] + x[2] + (x[1] * x[2] * x[3])
  })))
} 

c(part1(d),part2(d))
