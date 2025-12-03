d <- readLines("../inputs/input_20.txt")
ids <- as.integer(gsub("Tile ", "", gsub(":", "", d[seq(1, length(d), by = 12)])))
tiles <- list()
for (i in seq_along(ids)) {
  tiles[[i]] <- matrix(as.integer(unlist( 
    strsplit(d[((i * 12)- 10):((i * 12)-1)], "")) == "#"),
      ncol = 10, nrow = 10, byrow = TRUE)
}

can_place <- function(tiles, tile, placed, no) {
  # 1. top-left. 2. top. 3. left of grid. 4. any other - top+left
  if (no == 1) return(TRUE)
  if (no < 13) return(identical(tile[, 1], tiles[[placed[no - 1]]][, 10]))
  if (((no - 1) %% 12) == 0) 
    return(identical(tile[1, ], tiles[[placed[no - 12]]][10, ]))
  
  return ((identical(tile[, 1], tiles[[placed[no - 1]]][, 10])) &&
          (identical(tile[1, ], tiles[[placed[no - 12]]][10, ])))
}

rotate <- function(tile) {
  tile2 <- tile
  size <- nrow(tile)
  for (i in 1:size) {
    for (j in 1:size) {
      tile2[i,j] <- tile[(size+1) - j,i]
    }
  }
  tile2
}

got_result <<- NA
got_tiles <<- NA
recurse <- function(tiles, results, spares, no) {
  if (no == 145) {
    got_result <<- results
    got_tiles <<- tiles
    return(TRUE)
  }
  
  for (index in seq_along(spares)) {
    if (is.na(spares[index])) next
    
    for (turn in 0:7) {
      if (can_place(tiles, tiles[[index]], results, no)) {
        results[no] <- index
        spares[index] <- NA
        done <- recurse(tiles, results, spares, no + 1)
        if (done) return(TRUE)
        spares[index] <- index
        results[no] <- NA
      }
      tiles[[index]] <- rotate(tiles[[index]])
      if (turn %in% c(3, 7)) tiles[[index]] <- tiles[[index]][10:1, ]
    }
  }
  FALSE
}

invisible(recurse(tiles, rep(NA, 144), 1:144, 1))
options(digits=14)
p1 <- prod(ids[got_result[c(1, 12, 133, 144)]])

## Part 2...

new_grid <- matrix(nrow = 96, ncol = 96, data = 0)

for (i in 1:144) {
  x <- ((i - 1) %% 12)
  y <- as.integer((i - 1) / 12)
  new_grid[(1+(y*8)):(8+(y*8)), (1+(x*8)):(8+(x*8))] <- 
    got_tiles[[got_result[i]]][2:9, 2:9]
}

# 0 #....................#. 
# 1 #..#....##....##....###
# 2 #...#..#..#..#..#..#...
    #  012345678901234567890

offset_x <- c(0, 1, 4, 5, 6, 7, 10, 11, 12, 13, 16, 17, 18, 18, 19)
offset_y <- c(1, 2, 2, 1, 1, 2, 2,  1,  1,  2,  2,  1,  1,  0,  1)

is_monster <- function(new_grid, x, y) {
  hashes <- 0
  for (i in seq_along(offset_x)) {
    if (new_grid[y + offset_y[i], x + offset_x[i]] > 0) {
      hashes <- hashes + 1
    }
  }
  if (hashes == length(offset_x)) {
    for (i in seq_along(offset_x)) {
      new_grid[y + offset_y[i], x + offset_x[i]] <- 2
    }
  }
  new_grid
}

for (turn in 1:8) {
  for (x in 1:77) {
    for (y in 1:94) {
      new_grid <- is_monster(new_grid, x, y)
    }
  }
  if (any(new_grid == 2)) {
    p2 <- sum(new_grid == 1)
    break
  }
  new_grid <- rotate(new_grid)
  if (turn %in% c(3, 7)) new_grid <- new_grid[96:1, ]
}

c(p1, p2)
