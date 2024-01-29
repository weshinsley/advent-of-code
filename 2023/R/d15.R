parse_input <- function(f) {
  strsplit(readLines(f), ",")[[1]]
}

hash <- function(s, p = 17, m = 256, ss = strsplit(s, "")[[1]]) {
  Reduce(function(x, y) ((x + utf8ToInt(y)) * p) %% m, ss, 0)
}

part1 <- function(d, pt = 1) {
  sum(unlist(lapply(d, hash)))
}

part2 <- function(d) {
  boxes <- rep(list(list()), 256)
  for (line in d) {
    sym <- if (grepl("-", line)) "-" else "="
    bits <- strsplit(line, sym)[[1]]
    box_no <- 1 + hash(bits[1])
    boxes[[box_no]][bits[1]] <- if (sym == "=") as.numeric(bits[[2]]) else NULL
  }

  sum(unlist(lapply(1:256,
    function(x) as.integer(boxes[[x]]) * x * seq_along(boxes[[x]]))))
}

test <- function() {
  d <- parse_input("../inputs/d15-test.txt")
  stopifnot(hash("HASH") == 52)
  stopifnot(part1(d) == 1320)
  stopifnot(part2(d) == 145)
}

test()
d <- parse_input("../inputs/d15-input.txt")
part1(d)
part2(d)
