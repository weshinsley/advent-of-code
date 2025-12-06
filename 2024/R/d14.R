source("../../shared/R/pix.R")

parse_file <- function(f = "../inputs/input_14.txt") {
  read.csv(text = gsub("p=", "", gsub(" v=", ",", readLines(f))),
           header = FALSE, col.names = c("px", "py", "vx", "vy"))
}

part1 <- function(d, w = 101, h = 103, t = 100,
                  mw = w %/% 2, mh = h %/% 2) {
  for (time in seq_len(t)) {
    d$px <- d$px + d$vx
    d$py <- d$py + d$vy
    d$px[d$px < 0] <- d$px[d$px < 0] + w
    d$py[d$py < 0] <- d$py[d$py < 0] + h
    d$px[d$px >= w] <- d$px[d$px >= w] - w
    d$py[d$py >= h] <- d$py[d$py >= h] - h
    if (sd(d$px) + sd(d$py) <  40) {
      return(time)
    }
  }
  sum(d$px < mw & d$py < mh) * sum(d$px > mw & d$py < mh) *
  sum(d$px < mw & d$py > mh) * sum(d$px > mw & d$py > mh)
}

part2 <- function(d) {
  part1(d, t = 10000)
}


d <- parse_file()
c(part1(d), part2(d))
