source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_15.txt", p2 = FALSE) {
  d <- readLines(f)
  if (p2) {
    d <- gsub("@", "@\\.", gsub("O", "[]", gsub("\\.", "\\.\\.", gsub("#", "##", d))))
  }
  space <- which(d == "")
  list(grid = strings_to_char_matrix((d[1:(space - 1)])),
       moves = strsplit(paste0(d[(space + 1):length(d)], collapse = ""), "")[[1]])
}

print <- function(m) {
  for (j in 1:nrow(m)) {
    cat(paste0(m[j,] , collapse = ""))
    cat("\n")
  }
  cat("\n")
}

dx <- c(0, 1, 0, -1)
dy <- c(-1, 0, 1, 0)
dc <- c("^", ">", "v", "<")

part1 <- function(d) {
  rxy <- rev(as.integer(which(d$grid == "@", arr.ind = TRUE)))
  for (move in d$moves) {
    dir <- which(dc == move)
    nxy <- rxy + c(dx[dir], dy[dir])
    first <- nxy
    while (d$grid[nxy[2], nxy[1]] == "O") {
      nxy <- nxy + c(dx[dir], dy[dir])
    }
    
    if (d$grid[nxy[2], nxy[1]] != "#") {
      for (xx in (nxy[1]:first[1])) {
        for (yy in (nxy[2]:first[2])) {
          swap <- d$grid[yy, xx]
          d$grid[yy, xx] <- d$grid[yy - dy[dir], xx - dx[dir]]
          d$grid[yy - dy[dir], xx - dx[dir]] <- swap
        }
      }
      rxy <- rxy + c(dx[dir], dy[dir])
    }
  }
  
  res <- which(d$grid == "O", arr.ind = TRUE)
  sum(((res[, 1] -1) * 100) + (res[, 2] - 1))
}

can_push_box <- function(d, bxy, dir) {
  ch1 <- d[bxy[2] + dy[dir], bxy[1]]
  ch2 <- d[bxy[2] + dy[dir], bxy[1] + 1]
  if ((ch1 == "#") || (ch2 == "#")) return(FALSE)
  if ((ch1 == ".") && (ch2 == ".")) return(TRUE)
  if (ch1 == "[") return(can_push_box(d, c(bxy[1], bxy[2] + dy[dir]), dir))
  left <- TRUE
  if (ch1 == "]") {
    left <- can_push_box(d, c(bxy[1] - 1, bxy[2] + dy[dir]), dir)
  }
  right <- TRUE
  if (ch2 == "[") {
    right <- can_push_box(d, c(bxy[1] + 1, bxy[2] + dy[dir]), dir)
  }
  return(left && right)
}

push_box <- function(d, bxy, dir) {
  queue <- list(bxy)
  i <- 0
  n <- 1
  while (i < n) {
    i <- i + 1
    bxy <- queue[[i]]
    ch1 <- d[bxy[2] + dy[dir], bxy[1]]
    ch2 <- d[bxy[2] + dy[dir], bxy[1] + 1]
    if (ch1 == "[") {
      n <- n + 1
      queue[[n]] <- c(bxy[1], bxy[2] + dy[dir])
    }
    if (ch1 == "]") {
      n <- n + 1
      queue[[n]] <- c(bxy[1] - 1, bxy[2] + dy[dir])
    }
    if (ch2 == "[") {
      n <- n + 1
      queue[[n]] <- c(bxy[1] + 1, bxy[2] + dy[dir])
    }
  }
  df <- data.frame(x = unlist(lapply(queue, `[[`, 1)),
                   y = unlist(lapply(queue, `[[`, 2)))
  df <- df[order(df$y, decreasing = dc[dir] == "v"), ]
  for (r in seq_len(nrow(df))) {
    row <- df[r, ]
    d[row$y + dy[dir], row$x] <- "["
    d[row$y + dy[dir], row$x + 1] <- "]"
    d[row$y, row$x] <- "."
    d[row$y, row$x + 1] <- "."
  }
  d
}

part2 <- function(d) {
  #d <- parse_file("test3.txt", p2 = TRUE)
  rxy <- rev(as.integer(which(d$grid == "@", arr.ind = TRUE)))
  for (move in d$moves) {
    dir <- which(dc == move)
    nxy <- rxy + c(dx[dir], dy[dir])
    first <- nxy
    if (move %in% c("<", ">")) {
      while (d$grid[nxy[2], nxy[1]] %in% c("[", "]")) {
        nxy <- nxy + c(dx[dir], dy[dir])
      }
      if (d$grid[nxy[2], nxy[1]] != "#") {
        for (xx in (nxy[1]:first[1])) {
          for (yy in (nxy[2]:first[2])) {
            swap <- d$grid[yy, xx]
            d$grid[yy, xx] <- d$grid[yy - dy[dir], xx - dx[dir]]
            d$grid[yy - dy[dir], xx - dx[dir]] <- swap
          }
        }
        rxy <- rxy + c(dx[dir], dy[dir])
      }
    } else { # up/down... 
      if (d$grid[nxy[2], nxy[1]] == "#") next
      if (d$grid[nxy[2], nxy[1]] == ".") {
        d$grid[nxy[2], nxy[1]] <- "@"
        d$grid[rxy[2], rxy[1]] <- "."
        rxy <- nxy
        next
      }
      bx <- nxy[1] - (d$grid[nxy[2], nxy[1]] == "]")
      if (can_push_box(d$grid, c(bx, nxy[2]), dir)) {
        d$grid <- push_box(d$grid, c(bx, nxy[2]), dir)
        d$grid[nxy[2], nxy[1]] <- "@"
        d$grid[rxy[2], rxy[1]] <- "."
        rxy <- nxy
      }
    }
  }
  
  res <- which(d$grid == "[", arr.ind = TRUE)
  sum(((res[, 1] -1) * 100) + (res[, 2] - 1))
}

c(part1(parse_file()), part2(parse_file(p2 = TRUE)))