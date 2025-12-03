d <- read.csv(text = readLines("../inputs/input_20.txt"), sep = "-",
              col.names = c("from", "to"), header = FALSE)
d <- d[order(d$from), ]
i <- 1

while (i <= (nrow(d) - 1)) {
  if (d$from[i + 1] <= 1 + d$to[i]) {
    d$to[i] <- max(d$to[i], d$to[i + 1])
    d <- d[-(i + 1), ]
  } else {
    i <- i + 1
  }
}

d$diff <- 0
d$diff[2:nrow(d)] <- (d$from[2:nrow(d)] - d$to[1:(nrow(d)-1)]) - 1
c(d$to[1] + 1, sum(d$diff))
