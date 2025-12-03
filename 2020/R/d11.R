scan <- function(grid, i, j, dx, dy, part) {
  while ((i >= 1) && (j >= 1) && 
         (j <= length(grid)) && (i <= length(grid[[1]]))) {
    if (grid[[j]][i] == '#') return(1)
    if ((part == 1) || (grid[[j]][i] == 'L')) return(0)
    i <- i + dx;
    j <- j + dy;
  }
  0
}

update <- function(grid, part) {
  grid2 <- grid
  for (j in seq_along(grid)) {
    for (i in seq_along(grid[[j]])) {
      count <- 0
      for (dx in c(-1, 0, 1)) {
        for (dy in c(-1, 0, 1)) {
          if ((dx != 0) || (dy != 0)) {
            count <- count + scan(grid, i + dx, j + dy, dx, dy, part)
          }
        }
      }
      if ((grid[[j]][i] == 'L') && (count == 0)) {
        grid2[[j]][i] <- '#'
      } else if ((grid[[j]][i] =='#') && (count >= 3 + part)) {
        grid2[[j]][i] <- 'L'
      }
    }
  }
  grid2
}


solve <- function(grid, part) {
  while(TRUE) {
    grid2 <- update(grid, part)
    if (identical(grid, grid2)) {
      return(sum(unlist(grid2) == '#'))   
    }
    grid <- grid2
  }
}


map <- strsplit(readLines("../inputs/input_11.txt"), "")
c(solve(map, 1), solve(map, 2))
