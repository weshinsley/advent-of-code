parse_input <- function(f) {
  d <- read.csv(f, sep = ",", header = FALSE, col.names = c("x1", "y1", "z1x2",
                                                       "y2", "z2"))
  d$z1 <- as.integer(unlist(lapply(strsplit(d$z1x2, "~"), `[[`, 1)))
  d$x2 <- as.integer(unlist(lapply(strsplit(d$z1x2, "~"), `[[`, 2)))
  d <- d[, c("x1", "y1", "z1", "x2", "y2", "z2")]
  d$x1 <- d$x1 + 1
  d$x2 <- d$x2 + 1
  d$y1 <- d$y1 + 1
  d$y2 <- d$y2 + 1
  d
}

make_array <- function(d) {
  w <- array(0, dim = c(max(d$x2), max(d$y2), max(d$z2) + 1))
  for (i in seq_len(nrow(d))) {
    b <- d[i, ]
    w[b$x1:b$x2, b$y1:b$y2, b$z1:b$z2] <- 1
  }
  w
}

can_fall <- function(w, b) {
  if (b$z1 == 1) return(FALSE)
  if (any(w[b$x1:b$x2, b$y1:b$y2, b$z1 - 1] == 1)) return(FALSE)
  TRUE
}

fall <- function(d) {
  w <- make_array(d)
  d <- d[order(d$z1), ]
  for (i in seq_len(nrow(d))) {
    b0 <- d[i, ]
    b <- d[i, ]
    while (can_fall(w, b)) {
      b$z1 <- b$z1 - 1
      b$z2 <- b$z2 - 1
    }
    if (b$z2 != b0$z2) {
      w[b0$x1:b0$x2, b0$y1:b0$y2, b0$z1:b0$z2] <- 0
      w[b$x1:b$x2, b$y1:b$y2, b$z1:b$z2] <- 1
      d$x1[i] <- b$x1
      d$x2[i] <- b$x2
      d$y1[i] <- b$y1
      d$y2[i] <- b$y2
      d$z1[i] <- b$z1
      d$z2[i] <- b$z2
    }
  }
  d
}

part1 <- function(d, w) {
  tot <- 0
  for (i in seq_len(nrow(d))) {
    b <- d[i, ]
    w[b$x1:b$x2, b$y1:b$y2, b$z1:b$z2] <- 0
    opts <- which(d$z1 == b$z2 + 1)
    free <- TRUE
    for (j in opts) {
      if (can_fall(w, d[j, ])) {
        free <- FALSE
        break
      }
    }
    w[b$x1:b$x2, b$y1:b$y2, b$z1:b$z2] <- 1
    tot <- tot + free
  }
  tot
}

part2 <- function(d, w) {

  disintegrate <- function(d, w, index) {
    d$gone <- FALSE
    tot <- 0
    i <- 1
    n <- 1
    queue <- list(index)
    tot <- 0
    while (i <= length(queue)) {
      index <- queue[[i]]
      i <- i + 1
      if (d$gone[index]) next
      d$gone[index] <- TRUE
      tot <- tot + 1
      b <- d[index, ]
      w[b$x1:b$x2, b$y1:b$y2, b$z1:b$z2] <- 0
      j <- index - 1
      while ((j >= 1) && (d$z1[j] != b$z2 + 1)) {
        j <- j - 1
      }
      while ((j >= 1) && (d$z1[j] == b$z2 + 1)) {
        if (!d$gone[j]) {
          if (can_fall(w, d[j, ])) {
            n <- n + 1
            queue[[n]] <- j
          }
        }
        j <- j - 1
      }
    }
    tot - 1
  }

  d <- d[order(d$z1, decreasing = TRUE), ]
  sum(unlist(lapply(seq_len(nrow(d)), function(x) disintegrate(d, w, x))))
}

d <- fall(parse_input("../inputs/input_22.txt"))
w <- make_array(d)
c(part1(d, w), part2(d, w))
