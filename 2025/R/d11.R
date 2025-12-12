parse_file <- function(f = "../inputs/input_11.txt") {
  d <- readLines(f)
  as.data.frame(data.table::rbindlist(lapply(readLines(f), function(x) {
    x <- strsplit(x, ": ")[[1]]
    data.frame(from = x[1], to = strsplit(x[2], " ")[[1]])
  })))
}

part1 <- function(d, start = "you", end = "out") {
  memo <- new.env()
  count_paths <- function(current, d) {
    if (current == end) return(1)
    if (exists(current, envir = memo, inherits = FALSE)) {
      return(get(current, envir = memo))
    }
    total <- 0
    dests <- d$to[d$from == current]
    for(dest in dests) {
      n <- count_paths(dest, d)
      total <- total + n
    }
    assign(current, total, envir = memo)
    return(total)
  }
  count_paths(start, d)
}

part2 <- function(d) {
  svr_fft  <- part1(d, "svr", "fft")
  fft_dac  <- part1(d, "fft", "dac")
  dac_out  <- part1(d, "dac", "out")
  svr_dac  <- part1(d, "svr", "dac")
  dac_fft  <- part1(d, "dac", "fft")
  fft_out  <- part1(d, "fft", "out")
  (svr_fft * fft_dac * dac_out) + (svr_dac * dac_fft * fft_out)
}

options(digits=14)
d <- parse_file()
c(part1(d), part2(d))
