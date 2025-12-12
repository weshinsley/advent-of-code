parse_file <- function(f = "../inputs/input_3.txt") {
  lapply(readLines(f), function(x) as.integer(strsplit(x, "")[[1]]))
}

calc <- function(dat, digs, len = length(dat)) {
  if (digs == 0) return(NULL)
  range <- 1:((len - digs) + 1)
  index <- which(dat[range] == max(dat[range]))[1]
  return(c(dat[index], calc(dat[(index + 1):length(dat)], digs - 1)))
}

part1 <- function(d, digs = 2) {
  format(sum(unlist(lapply(d, function(x) 
    as.numeric(paste0(calc(x, digs), collapse = ""))))), digits = 14)
}

part2 <- function(d) {
  part1(d, 12)
}

d <- parse_file()
c(part1(d), part2(d))
