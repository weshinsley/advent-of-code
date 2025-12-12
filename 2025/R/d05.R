parse_file <- function(f = "../inputs/input_5.txt") {
  d <- readLines(f)
  ranges <- lapply(strsplit(d[1:(which(d == "") - 1)], "-"), as.numeric)
  ranges <- data.frame(from = unlist(lapply(ranges, `[[`, 1)),
                       to = unlist(lapply(ranges, `[[`, 2)))
  changes <- TRUE
  while (changes) {
    ranges <- ranges[order(ranges$from, ranges$to), ]
    changes <- FALSE
    for (r in 1:(nrow(ranges) - 1)) {
      if (ranges$from[r + 1] <= ranges$to[r]) {
        ranges$from[r + 1] <- ranges$to[r] + 1
        changes <- TRUE
      }
    }
    ranges <- ranges[ranges$to >= ranges$from, ]
  }
  
  ranges$count <- 1 + ((ranges$to) - (ranges$from))
  ingreds <- as.numeric(d[(which(d == "") + 1):length(d)])
  list(ranges = ranges, ingreds = ingreds)
}

part1 <- function(d) {
  sum(unlist(lapply(d$ingreds, function(x) {
    any((x >= d$ranges$from) & (x <= d$ranges$to))})))
}

part2 <- function(d) {
  sum(d$ranges$count)
}

options(digits=16)
d <- parse_file()
c(part1(d), part2(d))
