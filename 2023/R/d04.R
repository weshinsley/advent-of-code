parse_file <- function(f) {
  d <- readLines(f)
  cards <- rep(0, length(d))
  for (i in seq_along(d)) {
    line <- d[i]
    line <- strsplit(line, ": ")[[1]][2]
    line <- strsplit(line, " \\| ")
    left <- as.integer(unlist(strsplit(trimws(line[[1]][1]), "\\s+")))
    right <- as.integer(unlist(strsplit(trimws(line[[1]][2]), "\\s+")))
    cards[i] <- sum(left %in% right)
  }
  cards
}

part1 <- function(d) {
  d <- d[d > 0]
  sum(2 ^ (d - 1))
}

part2 <- function(d) {
  count <- rep(1, length(d))
  for (i in seq_along(d)) {
    w <- d[i]
    j <- i
    while (w > 0) {
      j <- j + 1
      if (j > length(d)) {
        break
      }
      count[j] <- count[j] + count[i]
      w <- w - 1
    }
  }
  sum(count)
}


test <- function() {
  d <- parse_file("../inputs/d04-test.txt")
  stopifnot(part1(d) == 13)
  stopifnot(part2(d) == 30)
}

test()
d <- parse_file("../inputs/d04-input.txt")
part1(d)
part2(d)
