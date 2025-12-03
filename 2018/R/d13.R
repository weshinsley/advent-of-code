UP <- 0
RIGHT <- 1
DOWN <- 2
LEFT <- 3

slash_dir <- c(RIGHT, UP, LEFT, DOWN)
bslash_dir <- c(LEFT, DOWN, RIGHT, UP)
cart_ch <- c('^','>','v','<')

init_carts <- function(map) {

  add_carts <- function(row, r, d, ch) {
    ind <- which(row == cart_ch[d + 1])
    if (length(ind)>0)
      data.frame(x = ind, y = rep(r, length(ind)), d = rep(d, length(ind)), i = rep(0, length(ind)), 
               ch = rep(ch, length(ind)), stringsAsFactors = FALSE)
    else NULL
  }

  carts <- data.frame()
  for (r in seq_len(length(map))) {
    carts <- rbind(carts, add_carts(map[[r]], r, UP, '|'))
    carts <- rbind(carts, add_carts(map[[r]], r, RIGHT, '-'))
    carts <- rbind(carts, add_carts(map[[r]], r, DOWN, '|'))
    carts <- rbind(carts, add_carts(map[[r]], r, LEFT, '-'))
  }
  carts
}

drive <- function(map, carts, remove_crashes) {
  done <- FALSE
  while (!done) {
    carts <- carts[order(carts$y, carts$x),]
    i <- 1
    while (i <= nrow(carts)) {
      crash_flag <- FALSE
      map[[carts$y[i]]][carts$x[i]] <- carts$ch[i]
      carts$x[i] <- carts$x[i] + (carts$d[i] == RIGHT) - (carts$d[i] == LEFT)
      carts$y[i] <- carts$y[i] + (carts$d[i] == DOWN) - (carts$d[i] == UP)
      new_ch <- map[[carts$y[i]]][carts$x[i]]

      if (new_ch %in% cart_ch) {
        if (!remove_crashes) {
          return(sprintf("Crash at %d,%d", carts$x[i]-1, carts$y[i]-1))
        } else {
          crash_flag <- TRUE
          x <- carts$x[i]
          y <- carts$y[i]
          carts <- carts[-i, ]
          j <- which((carts$x == x) & (carts$y == y))
          map[[carts$y[j]]][carts$x[j]] <- carts$ch[j]
          carts <- carts[-j, ]
          if (j<i) i <- i - 1
          if (nrow(carts) == 1) done <- TRUE
        }
      }

      if (!crash_flag) {
        carts$ch[i] <- new_ch
        if (new_ch == '/') {
          carts$d[i] <- slash_dir[carts$d[i] + 1]
        } else if (new_ch == '\\') {
          carts$d[i] <- bslash_dir[carts$d[i] + 1]
        } else if (new_ch == '+') {
          if (carts$i[i] == 0) {
            carts$d[i] <- (carts$d[i] + 3) %% 4
          } else if (carts$i[i] == 2) {
            carts$d[i] <- (carts$d[i] + 1) %% 4
          }
          carts$i[i] <- (carts$i[i] + 1) %% 3
        }
        map[[carts$y[i]]][carts$x[i]] <- cart_ch[carts$d[i] + 1]
        i <- i + 1
      }
    }
  }
  if (remove_crashes) {
    sprintf("Last cart at %d,%d",carts$x[1]-1, carts$y[1]-1)
  }
}

map <- lapply(readLines("../inputs/input_13.txt"), function(x) unlist(strsplit(x, NULL)))
carts <- init_carts(map)
c(drive(map, carts, FALSE), drive(map, carts, TRUE))
