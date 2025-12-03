part1 <- function(d) {
  gam <- 0
  eps <- 0
  maxpow <- ceiling(max(log(d, 2))) - 1
  for (p in 2^(maxpow:0)) {
    gam <- gam + ifelse(sum(bitwAnd(d, p) > 0) >= length(d) / 2, p, 0)
    eps <- eps + ifelse(sum(bitwAnd(d, p) > 0) <= length(d) / 2, p, 0)
  }
  gam * eps
}

part2 <- function(d) {
  oxy <- d
  co2 <- d
  p <- 2 ^ (ceiling(max(log(d, 2))) - 1)
  while (p >= 1) {
    ox <- ifelse(sum(bitwAnd(oxy, p) > 0) >= (length(oxy) / 2), p, 0)
    oxy <- oxy[bitwAnd(oxy, p) == ox]
    if (length(co2) > 1) {
      co <- ifelse(sum(bitwAnd(co2, p) > 0) < (length(co2) / 2), 0, p)
      co2 <- co2[bitwAnd(co2, p) != co]
    }
    p <- p / 2
  }
  oxy * co2
}

d <- strtoi(readLines("../inputs/input_3.txt"), base = 2)
c(part1(d), part2(d))