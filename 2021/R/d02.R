parse_input <- function(d) {
  read.csv(d, header = FALSE, sep = " ", col.names = c("dir", "val"))
}

summer <- function(d,x) {
  sum(d$val[d$dir == x])
}

part1 <- function(d) {
  summer(d, "forward") * (summer(d, "down") - summer(d, "up"))
}

part2 <- function(d) {
  dep <- 0
  aim <- 0
  for (i in seq_len(nrow(d))) {
    if (d$dir[i] == "forward") {
      dep <- dep + (aim * d$val[i])
    } else {
      aim <- aim + (d$val[i] * ifelse(d$dir[i] == "down", 1, -1))
    }
  }
  summer(d, "forward") * dep
}

d <- parse_input("../inputs/d02-test.txt")
stopifnot(part1(d) == 150)
stopifnot(part2(d) == 900)

d <- parse_input("../inputs/d02-input.txt")

part1(d)
part2(d)
