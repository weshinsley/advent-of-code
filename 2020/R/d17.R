d <- readLines("../inputs/input_17.txt")
ysize <- length(d)
xsize <- nchar(d[1])
d <- data.frame(
  x = seq_len(xsize),
  y = rep(seq_len(ysize), each = xsize),
  z = 1, w = 1,
  status = (unlist(strsplit(d, "")) == '#')
)

iter <- function(d) {
  d2 <- NULL
  d <- d[d$status, ]
  for (i in seq_len(nrow(d))) {
    for (x in (d$x[i]-1):(d$x[i]+1)) {
      for (y in (d$y[i]-1):(d$y[i]+1)) {
        for (z in (d$z[i]-1):(d$z[i]+1)) {
          if (nrow(d[d$x == x & d$y == y & d$z == z,]) == 0) {
            d <- rbind(d, data.frame(x = x, y = y, z = z, w = 1, status = FALSE))
          }
        }
      }
    }
  }
 
  for (i in seq_len(nrow(d))) {
    neigh <- nrow(d[(d$x %in% (d$x[i] - 1):(d$x[i] + 1)) &
                      (d$y %in% (d$y[i] - 1):(d$y[i] + 1)) &
                      (d$z %in% (d$z[i] - 1):(d$z[i] + 1)) &
                      d$status, ]) -
             nrow(d[(d$x == d$x[i]) & (d$y == d$y[i]) &
                    (d$z == d$z[i]) & d$status, ])
    
    if ((d$status[i] && (neigh %in% c(2,3))) ||
        (!d$status[i] && (neigh == 3))) {
      d2 <- rbind(d2, data.frame(x = d$x[i], y = d$y[i], 
                                 z = d$z[i], w = 1, status = TRUE))
    }
  }
  d2
}

iter2 <- function(d) {
  d2 <- NULL
  d <- d[d$status, ]
  for (i in seq_len(nrow(d))) {
    for (x in (d$x[i]-1):(d$x[i]+1)) {
      for (y in (d$y[i]-1):(d$y[i]+1)) {
        for (z in (d$z[i]-1):(d$z[i]+1)) {
          for (w in (d$w[i]-1):(d$w[i]+1)) {
            if (nrow(d[d$x == x & d$y == y & d$z == z & d$w == w,]) == 0) {
              d <- rbind(d, data.frame(x = x, y = y, z = z, w = w, status = FALSE))
            }
          }
        }
      }
    }
  }
  for (i in seq_len(nrow(d))) {
    neigh <- nrow(d[(d$x %in% (d$x[i] - 1):(d$x[i] + 1)) &
                    (d$y %in% (d$y[i] - 1):(d$y[i] + 1)) &
                    (d$z %in% (d$z[i] - 1):(d$z[i] + 1)) &
                    (d$w %in% (d$w[i] - 1):(d$w[i] + 1)) &
                    d$status, ]) -
             nrow(d[(d$x == d$x[i]) & (d$y == d$y[i]) &
                    (d$z == d$z[i]) & (d$w == d$w[i]) & d$status, ])
                    
    if ((d$status[i] && (neigh %in% c(2,3))) ||
        (!d$status[i] && (neigh == 3))) {
            d2 <- rbind(d2, data.frame(x = d$x[i], y = d$y[i], 
                                       z = d$z[i], w = d$w[i], status = TRUE))
    }
  }
  d2
}


solve <- function(d, part2 = FALSE) {
  for (i in 1:6) {
    if (!part2) d <- iter(d)
    else d <- iter2(d)
  }
  nrow(d)
}

c(solve(d), solve(d, TRUE))
