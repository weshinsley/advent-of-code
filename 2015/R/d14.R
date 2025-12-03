d <- read.csv("../inputs/input_14.txt", header = FALSE, sep = " ")[, c(1, 4, 7,14)]
names(d) <- c("reindeer", "speed", "time", "rest")

solve1 <- function(d, t) {
  max(((t %/% (d$time + d$rest)) * d$time * d$speed) + 
       pmin(d$time, (t %% (d$time + d$rest))) * d$speed)
}

solve2 <- function(d, t) {
  d$score <- 0
  for (i in seq_len(t)) {
    d$dist <- ((i %/% (d$time + d$rest)) * d$time * d$speed) + 
          pmin(d$time, (i %% (d$time + d$rest))) * d$speed
    d$score[d$dist == max(d$dist)] <- d$score[d$dist == max(d$dist)] + 1
  }
  max(d$score)
}

c(solve1(d, 2503), solve2(d, 2503))
