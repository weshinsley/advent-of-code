parse <- function(filename) {
  input <-  unlist(lapply(
    lapply(strsplit(paste(readLines(filename), collapse = "\t"), "\t\t"),
      function(x) strsplit(x, "\t"))[[1]],
        function(x) sum(as.integer(x))))
}


part1 <- function(input) {
  max(input)
}

part2 <- function(input) {
  sum(sort(input, decreasing = TRUE)[1:3])
}

input <- parse("../inputs/input_1.txt")
c(part1(input), part2(input))
