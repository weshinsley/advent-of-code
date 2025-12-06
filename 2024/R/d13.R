parse_file <- function(f = "../inputs/input_13.txt") {
  d <- as.data.frame(matrix(ncol = 6, byrow = TRUE, as.numeric(strsplit(gsub(",,", ",", 
    gsub("[^0-9,]*","",paste0(readLines(f), collapse=","))), ",")[[1]])))
  names(d) <- c("ax", "ay", "bx", "by", "px", "py")
  d
}

part1 <- function(d) {
  d$b1 <- d$py * d$ax - d$px * d$ay
  d$b2 <- d$by * d$ax - d$bx * d$ay
  d <- d[(d$b1 %% d$b2) == 0,]
  d$b <- d$b1 %/% d$b2
  d$a1 <- d$px - d$bx * d$b
  d <- d[(d$a1 %% d$ax) == 0, ]
  a <- d$a1 %/% d$ax
  sum((3 * a) + d$b)
}

part2 <- function(d) {
  d$px <- d$px + 10000000000000
  d$py <- d$py + 10000000000000
  part1(d)
}

options(digits=16)
d <- parse_file()
c(part1(d), part2(d))
