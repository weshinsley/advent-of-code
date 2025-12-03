parse_input <- function(input) {
  input <- lapply(input, function(x) unlist(strsplit(gsub("[pos=<>r ]", "", x), ",")))
  
  bots <- data.frame(stringsAsFactors = FALSE,
                     x = as.integer(unlist(lapply(input, "[[", 1))),
                     y = as.integer(unlist(lapply(input, "[[", 2))),
                     z = as.integer(unlist(lapply(input, "[[", 3))),
                     r = as.integer(unlist(lapply(input, "[[", 4))))
 
  bots
}

advent23a <- function(bots) {
  N <- bots[which(bots$r == max(bots$r)),]
  sum(abs(bots$x - N$x) + abs(bots$y - N$y) + abs(bots$z - N$z) < N$r)
}

inRangeOf <- function(x, y, z, bots)  {
  sum(abs(bots$x - x) + abs(bots$y - y) + abs(bots$z - z) <= bots$r)
}

advent23b <- function(bots) {
  best <- -1
  stride <- 100000000
  search <- 10
  max <- -Inf
  hits <- NULL
  base_x <- 0
  base_y <- 0
  base_z <- 0
  while (stride >= 1) {
    for (x in (-search):(search-1)) {
      for (y in (-search):(search-1)) {
        for (z in (-search):(search-1)) {
          score <- inRangeOf((base_x + (x * stride)), 
                             (base_y + (y * stride)), 
                             (base_z + (z * stride)), bots)
          if (score >= max) {
            if (score > max) { 
              max <- score
              hits <- NULL
            }
            hits <- c(hits, list(list(base_x + (x * stride), 
                                      base_y + (y * stride), 
                                      base_z + (z * stride))))
          }
        }
      }
    }
    
    dists <- unlist(lapply(hits, function(x) abs(x[[1]]) + abs(x[[2]]) + abs(x[[3]])))
    index <- which(dists == min(dists))[1]
    base_x <- hits[[index]][[1]]
    base_y <- hits[[index]][[2]]
    base_z <- hits[[index]][[3]]
    hits <- NULL
    stride <- stride / 10
  }
  min(dists)
}

bots <- parse_input(readLines("../inputs/input_23.txt"))
bots <- bots[order(bots$x),]
c(advent23a(bots), advent23b(bots))
