d <- as.integer(readLines("../inputs/input_20.txt"))

part1 <- function(d) {
  houses <- rep(0, d/10)
  elf <- 1
  while (elf < d / 10) {
    pick <- seq(elf, d/10, by = elf)
    houses[pick] <- houses[pick] + (10 * elf)
    elf <- elf + 1
  }
  which(houses >= d)[1]
}

part2 <- function(d) {
  houses <- rep(0, d/10)
  elf <- 1
  while (elf < d / 10) {
    pick <- seq(elf, by = elf, length.out = 50)
    houses[pick] <- houses[pick] + (11 * elf)
    elf <- elf + 1
  }
  which(houses >= d)[1]
}
c(part1(d), part2(d))
