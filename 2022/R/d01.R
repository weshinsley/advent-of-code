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

test <- function() {
  test_input <- parse("../inputs/d01-test.txt")
  stopifnot(part1(test_input) == 24000)
  stopifnot(part2(test_input) == 45000)
}

test()
input <- parse("../inputs/d01-input.txt")
part1(input)
part2(input)
