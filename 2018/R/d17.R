viapply <- function(X, FUN, ...) {
  vapply(X, FUN, integer(1), ...)
}

SAND <- 1
CLAY <- 2
DRIP <- 3
POOL <- 4
grid <- NULL

min_x <- NULL
max_x <- NULL
max_y <- NULL
min_y <- NULL

parseInput <- function(input) {
  vert <- lapply(gsub("[x=y ]", "", gsub("\\.\\.", ",", input[substr(input,1,1) == 'x'])),
                 function(x) as.integer(unlist(strsplit(x, ","))))
  horiz <- lapply(gsub("[x=y ]", "", gsub("\\.\\.", ",", input[substr(input,1,1) == 'y'])),
                function(x) as.integer(unlist(strsplit(x, ","))))

  min_x <<- min(viapply(vert, "[[", 1), viapply(horiz, "[[", 2)) - 2
  max_x <<- max(viapply(vert, "[[", 1), viapply(horiz, "[[", 3)) + 1
  min_y <<- min(viapply(horiz, "[[", 1), viapply(vert, "[[", 2))
  max_y <<- max(viapply(horiz, "[[", 1), viapply(vert, "[[", 3))
  grid <<- matrix(ncol = (max_x - min_x) + 1, nrow = (max_y), data = SAND)
  for (v in vert) grid[(v[2]:v[3]), v[1] - min_x] <<- CLAY
  for (h in horiz) grid[h[1], (h[2]:h[3]) - min_x] <<- CLAY
}

dump <- function(grid, fname = "wes-R-out.txt") {
  chars <- c('.', '#', '|', '~')
  f <- file(fname, "w")
  js <- seq_len(nrow(grid))
  is <- seq_len(ncol(grid))
  for (j in js) {
    for (i in is) {
      cat(chars[grid[j, i]], file = f)
    }
    cat("\n", file = f)
  } 
  close(f)
}

drip <- function(x, y) {

  if ((x >= 1) && (x <= ncol(grid)) && (y < nrow(grid))) {
    while ((y < nrow(grid)) && (grid[y + 1, x] == SAND)) {
      grid[y + 1, x] <<- DRIP
      y <- y + 1
    }

    if (y < nrow(grid)) {
      
      if ((grid[y + 1, x] == CLAY) || (grid[y + 1, x] == POOL)) {
      
        xl <- x
        xr <- x
      
        while ((xl > 1) & (grid[y, xl] != CLAY) && 
              ((grid[y + 1, xl] == CLAY) || (grid[y + 1, xl] == POOL))) {
          xl <- xl - 1
        }
      
        while ((xr < ncol(grid)) && (grid[y, xr] != CLAY) &&
              ((grid[y + 1, xr] == CLAY) || (grid[y + 1, xr] == POOL))) {
          xr <- xr + 1
        }
      
        while ((grid[y, xl] == CLAY) && (grid[y, xr] == CLAY)) { 
          grid[y, (xl + 1):(xr - 1)] <<- POOL
          y <- y - 1
          xl <- x
          xr <- x
          while ((xl > 1) && (grid[y, xl] != CLAY) &&
                ((grid[y + 1, xl] == CLAY) || (grid[y + 1, xl] == POOL))) {
            xl <- xl - 1
          }
        
          while ((xr < ncol(grid)) && (grid[y, xr] != CLAY) &&
                ((grid[y + 1, xr] == CLAY) || (grid[y + 1, xr] == POOL))) {
            xr <- xr + 1
          }
        }
      
        if (xr > xl) {
          grid[y, (xl + 1):(xr - 1)] <<- DRIP
        }
        if (grid[y, xr] != CLAY) drip(xr, y - 1)
        if (grid[y, xl] != CLAY) drip(xl, y - 1)
      }
    }
  }
}

parseInput(readLines("../inputs/input_17.txt"))
drip(500 - min_x, 0)
if (min_y>1) grid[seq_len(min_y - 1), seq_len(ncol(grid))] <- SAND
c(sum(grid == POOL) + sum(grid == DRIP), sum(grid == POOL))
