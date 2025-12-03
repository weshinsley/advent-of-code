d <- readLines("../inputs/input_24.txt")

moves <- data.frame(p = c("se", "sw", "ne", "nw", "e", "w"),
                    dx = c(1, -1, 1,-1, 2, -2),
                    dy = c(1, 1, -1, -1, 0, 0),
                    di <- c(2, 2, 2, 2, 1 ,1))

coord <- function(x,y) {
  sprintf("%d_%d", x, y)
}

solve <- function(d) {
  pattern <- new.env()
  tot <- 0
  for (route in d) {
    i <- 1
    x <- 0
    y <- 0
    while (i <= nchar(route)) {
      for (m in seq_len(nrow(moves))) {
        if (substring(route, i, (i - 1) + nchar(moves$p[m])) == moves$p[m]) {
          x <- x + moves$dx[m]
          y <- y + moves$dy[m]
          i <- i + moves$di[m]
          break
        }
      }
    }
    state <- coord(x, y)
    value <- 1
    if (exists(state, envir = pattern)) {
      value <- get(state, envir = pattern)
      tot <- ifelse(value == 0, tot + 1, tot - 1)
      value <- 1 - value
    } else {
      value <- 1
      tot <- tot + 1
    }
    assign(state, value, envir = pattern)
  }
  p1 <- tot
  
  #################
  
  for (days in 1:100) {
    # For all black tiles, fill in any missing neighbours with white
    tiles <- ls(envir = pattern)
    for (tile in tiles) {
      tile_xy <- as.integer(strsplit(tile, "_")[[1]])
      if (get(tile, envir = pattern) == 1) {
        for (m in seq_len(nrow(moves))) {
          xy <- coord(tile_xy[1] + moves$dx[m], tile_xy[2] + moves$dy[m])
          if (!exists(xy, envir = pattern)) {
            assign(xy, 0, envir = pattern)
          }
        }
      }
    }
    
    tiles <- ls(envir = pattern)
    pattern2 <- new.env()
    for (tile in tiles) {
      col <- get(tile, envir = pattern)
      tile_xy <- as.integer(strsplit(tile, "_")[[1]])
      neigh <- 0
      for (m in seq_len(nrow(moves))) {
        xy <- coord(tile_xy[1] + moves$dx[m], tile_xy[2] + moves$dy[m])
        if (exists(xy, envir = pattern)) {
          neigh <- neigh + (get(xy, envir = pattern) == 1)
        }
      }
      if ((col == 1) && (!neigh %in% c(1, 2))) {
        col <- 0
      } else if ((col == 0) && (neigh == 2)) {
        col <- 1
      } 
      if (col == 1) {
        assign(tile, 1, envir = pattern2)
      }
    }
    pattern <- pattern2
    rm(pattern2)
  }
  
  p2 <- length(ls(envir = pattern))
  
  c(p1, p2)
}

solve(d)
