parse_file <- function(f = "../inputs/input_3.txt") {
  paste0(readLines(f), collapse = "")
}

scan <- function(d) {
  places <- gregexpr("mul\\(\\d+,\\d+\\)", d)[[1]]
  starts <- as.integer(places)
  lengths <- attr(places, "match.length")
  sum(unlist(lapply(seq_along(starts), function(i) {
    str <- substr(d, starts[i] + 4, starts[i] + lengths[i] - 2)
    prod(as.integer(strsplit(str, ",")[[1]]))
  })))
}

reduce <- function(d) {
  gsub("N.*?(D|$)", "", gsub("do()", "D", gsub("don't()", "N", d)))
}

part1 <- function(d) {
  scan(d)
}

part2 <- function(d) {
  scan(reduce(d))
}

d <- parse_file()
c(part1(d), part2(d))
