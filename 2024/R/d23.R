parse_file <- function(f = "../inputs/input_23.txt") {
  d <- read.csv(f, sep = "-", header = FALSE, col.names = c("x", "y"))
  comps <- sort(unique(c(d$x, d$y)))
  nc <- length(comps)
  m <- matrix(0, nrow = nc, ncol = nc)
  for (i in seq_len(nrow(d))) {
    x <- which(comps == d$x[i])
    y <- which(comps == d$y[i])
    m[x, y] <- 1
    m[y, x] <- 1
  }
  list(m = m, comps = comps)
}

part1 <- function(m, comps, nc = length(comps)) {  
  tot <- 0
  copt <- which(substring(comps, 1, 1) == "t")
  net <- new.env()
  for (c1 in copt) {
    neigh <- which(m[c1, ] == 1)
    for (i in 1:(length(neigh) - 1)) {
      for (j in (i + 1):length(neigh)) {
        c2 <- neigh[i]
        c3 <- neigh[j]
        if (m[c2, c3] == 1) {
          hash <- sort(c(c1, c2, c3))
          hash <- hash[1] + (hash[2] * nc) + (hash[3] * nc * nc)
          assign(as.character(hash), 1, envir = net)
        }
      }
    }
  }
  length(ls(envir = net))
}
  
part2 <- function(m, comps, nc = length(comps)) {
  biggest <- 0
  pw <- ""
  hist <- new.env()

  grow <- function(net) { 
    done <- paste0(sort(net), collapse="_")
    if (exists(done, envir = hist)) {
      return()
    }
    assign(done, 1, envir = hist)
    opt <- m[cbind(net), ]
    if (class(opt)[1] == "numeric") {
      neigh <- which(opt == 1)
    } else {
      neigh <- which(colSums(opt) == length(net))
    }
    if (length(neigh) == 0) {
      size <- length(net)
      if (size > biggest) {
        biggest <<- size
        pw <<- paste0(sort(comps[net]), collapse=",")
      }
    }
    if (length(net) + length(neigh) < biggest) {
      return()
    }
    for (n in neigh) {
      grow(c(net, n))
    }
  }
  
  for (c1 in seq_len(nc)) {
     grow(c1)
   }
  pw
}

d <- parse_file()
c(part1(d$m, d$comps), part2(d$m, d$comps))
