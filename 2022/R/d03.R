parse <- function(input) {
  lapply(readLines(input), function(x) {
    x <- utf8ToInt(x)
    x[x >= 97] <- x[x >= 97] - 96
    x[x >= 65] <- x[x >= 65] - 38
    x
  })
}

part1 <- function(input) {
  score <- 0
  for (x in seq_along(input)) {
    d <- input[[x]]
    left <- d[1:(length(d) / 2)]
    right <- d[((length(d) / 2) + 1):length(d)]
    score <- score + unique(left[left %in% right])
  }
  score
}

part2 <- function(input) {
  score <- 0
  for (n in  seq(from = 1, by = 3, to = length(input))) {
    common <- unique(input[[n]][input[[n]] %in% input[[n + 1]]])
    score <- score + unique(common[common %in% input[[n + 2]]])
  }
  score
}

test <- function() {
  input <- parse("../inputs/d03-test.txt")
  stopifnot(part1(input) == 157)
  stopifnot(part2(input) == 70)
}

test()
input <- parse("../inputs/d03-input.txt")
part1(input)
part2(input)
