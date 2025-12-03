parse <- function(f) {
  unlist(lapply(readLines(f), function(x) {
    as.integer(strsplit(x, "")[[1]])}))
}

get_neigh <- function(pos, size) {
  y <- (pos-1) %/% size
  x <- (pos-1) %% size
  
  ifn <- function(b, v) {
    if (b) v else NULL
  }
  
  c(ifn((x > 0)         &&   (y > 0),          pos - (size + 1)),
    ifn(                     (y > 0),          pos - size),
    ifn((x < size - 1)  &&   (y > 0),          pos - (size - 1)),
    ifn((x > 0),                               pos - 1),
    ifn((x < size - 1),                        pos + 1),
    ifn((x > 0)         &&   (y < size - 1),   pos + (size - 1)),
    ifn(                     (y < size - 1),   pos + size),
    ifn((x < size-1)    &&   (y < size - 1),   pos + (size + 1)))
}

steps <- function(grid, nsteps) {
  fcount <- 0
  size <- sqrt(length(grid))
  neighs <- lapply(seq_along(grid), get_neigh, size)
  p2 <- 0
  i <- 0
  while(TRUE) {
    i <- i + 1
    p2 <- p2 + 1
    grid <- grid + 1
    flashes <- which(grid == 10)
    grid[flashes] <- 0
    
    while (length(flashes) > 0) {
      fcount <- fcount + 1
      flash <- flashes[1]
      flashes <- flashes[-1]
      
      changes <- neighs[[flash]]
      changes <- changes[grid[changes] != 0]
      grid[changes] <- grid[changes] + 1
      new_flashes <- changes[which(grid[changes] == 10)]

      if (length(new_flashes) > 0) {
        grid[new_flashes] <- 0
        flashes <- unique(c(flashes, new_flashes))
      }
    }
    if (i == nsteps) p1 <- fcount
    if (sum(grid) == 0) return(c(p1, p2))
  }
}

part1 <- function(res) { res[1] }
part2 <- function(res) { res[2] }

d <- parse("../inputs/input_11.txt")
res <- steps(d, 100)
c(part1(res), part2(res))
