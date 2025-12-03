init <- function(serial) {
  grid1 <- matrix(nrow = 300, ncol = 300)
  grid2 <- matrix(nrow = 300, ncol = 300)
  for (j in 1:300)
    for (i in 1:300)
      grid1[j,i] <- (floor(((((i + 10) * j) + serial)
                            * (i + 10)) / 100) %% 10) - 5
  list(grid1, grid2)
}
  
  
iter <- function(max_size, search, grid1, grid2) {
  if (search) start <- 3
  else start <- max_size
  max <- -Inf
  max_i <- 0
  max_j <- 0
  best_size <- 0
  for (size in seq(start, max_size, by = 1))
    for (j in seq(1, (301 - size), by = 1))
      for (i in seq(1, (301 - size), by = 1)) {
        power <- 0
        if (size == start) {
          power <- sum(grid1[j:(j + size - 1), i:(i + size - 1)])
          grid2[j, i] <- power
          
        } else {
          power <- grid2[j, i]
          power <- power + sum(grid1[j + size -1, i:(i + (size - 1))])
          power <- power + sum(grid1[j:(j + (size - 2)), i + size - 1])
          grid2[j, i] <- power  
        }
        
        if (power > max) { 
          max <- power
          max_i <- i
          max_j <- j
          best_size <- size
        }
      }
  
  if (search) sprintf("%d,%d,%d",max_i, max_j, best_size)
  else sprintf("%d,%d", max_i, max_j)
}
  
input <- as.integer(readLines("../inputs/input_11.txt"))
grids <- init(input)
c(iter(3, FALSE, grids[[1]], grids[[2]]), 
  iter(300, TRUE, grids[[1]], grids[[2]]))
