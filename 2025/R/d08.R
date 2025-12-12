parse_file <- function(f = "../inputs/input_8.txt") {
  read.csv(f, sep = ",", header = FALSE, col.names = c("x", "y", "z"))
}

dists <- function(d) {
  m <- as.data.frame(data.table::rbindlist(lapply(1:(nrow(d) - 1), function(i) {
    range <- (i+1):nrow(d)
    dx <- as.numeric(d$x[range] - d$x[i])
    dy <- as.numeric(d$y[range] - d$y[i])
    dz <- as.numeric(d$z[range] - d$z[i])    
    dist <- sqrt((dx * dx) + (dy * dy) + (dz * dz))
    data.frame(a = i, b = range, dist = dist)
  })))
  m <- m[order(m$dist),]
}

calc <- function(d, max_con = Inf) { 
  m <- dists(d)
  d$con <- 0
  circuits <- 0
  i <- 0
  while (TRUE) {
    i <- i + 1
    already <- c(d$con[m$a[i]], d$con[m$b[i]])
    if (all(already == 0)) {
      circuits <- circuits + 1
      current <- circuits
    } else if (any(already == 0)) {
      current <- max(already)
    } else {
      current <- already[1]
      d$con[d$con == already[2]] <- current
    }
    d$con[m$a[i]] <- current
    d$con[m$b[i]] <- current
    if (i == max_con) {
      res1 <- prod(sort(table(d$con[d$con > 0]), decreasing = TRUE)[1:3])
    }
    if ((all(d$con != 0)) && (all(d$con == d$con[1]))) {
      lastx <- d$x[m$a[i]] * d$x[m$b[i]]
      break
    }
  }
  c(res1, lastx)
}

part1 <- function(d) { d[1] }
part2 <- function(d) { d[2] }
  
d <- parse_file()
res <- calc(d, 1000)
c(part1(res), part2(res))

