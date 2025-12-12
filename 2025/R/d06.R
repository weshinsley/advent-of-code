parse_file1 <- function(f = "../inputs/input_6.txt") {
  d <- lapply(readLines(f), function(x) strsplit(trimws(x), "\\s+")[[1]])
  for (i in 1:(length(d) - 1)) {
    d[[i]] <- as.integer(d[[i]])
  }
  ops <- d[[length(d)]]
  d[[length(d)]] <- NULL
  list(nums = d, ops = ops)
}

parse_file2 <- function(f = "../inputs/input_6.txt") {
  lapply(readLines(f), function(x) strsplit(x, "")[[1]])
}

part1 <- function(d) {
  tot <- 0
  for (i in seq_len(length(d$nums[[1]]))) {
    nums <- unlist(lapply(d$nums, `[[`, i))
    tot <- tot + if (d$ops[i] == "*") prod(nums) else sum(nums)
  }
  tot
}

part2 <- function(d) {
  grand_tot <- 0
  tot <- 0
  op <- length(d)
  for (i in seq_along(d[[1]])) {
    chars <- unlist(lapply(d, `[[`, i))
    if (all(chars == " ")) {
      grand_tot <- grand_tot + tot
      next
    }
    if (chars[op] %in% c("*", "+")) {
      tot <- if (chars[op] == "*") 1 else 0
      func <- if (chars[op] == "*") prod else sum
    }
    num <- as.integer(trimws(paste0(chars[1:(op - 1)], collapse = "")))
    tot <- func(tot, num)
  }
  grand_tot + tot
}

options(digits=16)
c(part1(parse_file1()), part2(parse_file2()))
