parse_file <- function(f = "../inputs/input_1.txt") {
  read.csv(f, sep = "", header = FALSE, col.names = c("x", "y"))
}

part1 <- function(d) {
  sum(abs(sort(d$x) - sort(d$y)))
}

part2 <- function(d) {
  sum(unlist(lapply(d$x, function(x) sum(d$y[d$y == x]))))
}

d <- parse_file()
c(part1(d), part2(d))
