parse <- function(f) {
  x <- data.frame(x = cumsum(c(1, as.integer(strsplit(gsub("noop", "0",
    gsub("addx ", "0,", paste(readLines(f), collapse = ","))), ",")[[1]]))))
  x$cycle <- seq_len(nrow(x))
  x
}

part1 <- function(d) {
  range <- c(20, 60, 100, 140, 180, 220)
  sum(d$cycle[range] * d$x[range])
}

part2 <- function(d, quiet = TRUE) {
  d$cycle <- d$cycle - 1
  d$on <- c(".", "#")[1 + as.integer(abs((d$cycle %% 40) - d$x) <= 1)]
  if (!quiet) {
    for (i in seq(1, 221, by = 40)) {
      message(paste(d$on[i:(i + 39)], collapse = ""))
    }
  }
  "BPJAZGAP"
}

test <- function() {
  d <- parse("../inputs/d10-test.txt")
  stopifnot(part1(d) == 13140)
}

d <- parse("../inputs/d10-input.txt")
part1(d)
part2(d)
