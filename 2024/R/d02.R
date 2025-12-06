parse_file <- function(f = "../inputs/input_2.txt") {
  lapply(readLines(f), function(x) as.integer(strsplit(x, " ")[[1]]))
}

safe <- function(d) {
  (all(d > 0) || all(d < 0)) && (all(abs(d) %in% 1:3))
}

part1 <- function(d) {
  sum(unlist(lapply(d, function(x) safe(diff(x)))))
}

part2 <- function(d) {
  sum(unlist(lapply(d, function(x) {
    any(unlist(lapply(-1:(-1 - length(x)), function(y) safe(diff(x[y])))))})))
}

d <- parse_file()
c(part1(d), part2(d))
