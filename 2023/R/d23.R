parse_input <- function(f) {
  d <- lapply(readLines(f), function(x) strsplit(x, "")[[1]])
  d
}

dump <- function(d) {
  for (y in seq_along(d)) {
    message(paste0(d[[y]], collapse = ""))
  }
}

junctions <- function(d) {
  juncs <- data.frame(x = 2, y = 1)
  for (j in 2:(length(d) - 1)) {
    for (i in 2:length(d[[1]]) - 1) {
      if (d[[j]][i] == "#") next
      count <- (d[[j]][i - 1] != "#") + (d[[j]][i + 1] != "#") +
               (d[[j + 1]][i] != "#") + (d[[j - 1]][i] != "#")
      if (count > 2) {
        juncs <- rbind(juncs, data.frame(x = i, y = j))
      }
    }
  }
  juncs <- rbind(juncs, data.frame(x = length(d[[1]]) - 1, y = length(d)))
  jhash <- new.env()
  for (i in seq_len(nrow(juncs))) {
    assign(paste0("x", juncs$x[i], "_", juncs$y[i]), 1, envir = jhash)
  }
  list(juncs = juncs, jhash = jhash)
}

explore <- function(x, y, d, jhash, p1 = TRUE) {
  links <- list()
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)
  queue <- list(c(x, y, 0))
  hist <- new.env()
  i <- 1
  n <- 1
  while (i <= n) {
    state <- queue[[i]]
    i <- i + 1
    hash <- paste0("x", state[1], "_", state[2])
    if (exists(hash, envir = hist)) {
      next
    }
    assign(hash, 1, envir = hist)

    if (exists(hash, envir = jhash)) {
      if ((state[1] != x) || (state[2] != y)) {
        links[[length(links) + 1]] <- state
        next
      }
    }
    ch <- d[[state[2]]][state[1]]
    for (dir in 1:4) {
      if ((p1) && (ch == ">") && (dir != 1)) break
      if ((p1) && (ch == "v") && (dir != 2)) next
      nx <- state[1] + dx[dir]
      ny <- state[2] + dy[dir]
      if ((nx == 0) || (ny == 0) || (nx > length(d[[1]])) || (ny > length(d))) {
        next
      }
      if (d[[ny]][nx] == "#") next
      n <- n + 1
      queue[[n]] <- c(nx, ny, state[3] + 1)
    }
  }
  links
}

part1 <- function(d, p1 = TRUE) {
  network <- data.frame()
  juncs <- junctions(d)
  for (i in seq_len(nrow(juncs$juncs))) {
    links <- explore(juncs$juncs$x[i], juncs$juncs$y[i], d, juncs$jhash, p1)
    for (j in seq_along(links)) {
      network <- rbind(network, data.frame(
        x1 = juncs$juncs$x[i], y1 = juncs$juncs$y[i],
        x2 = links[[j]][1], y2 = links[[j]][2], dist = links[[j]][3]))
    }
  }

  # DFS on the network

  max_dist <<- 0
  visited <- new.env()

  dfs <- function(x, y, tx, ty, dist) {
    hash <- paste0("x", x, "_", y)
    if (exists(hash, envir = visited)) {
      return()
    }

    assign(hash, 1, envir = visited)
    if ((x == tx) && (y == ty)) {
      max_dist <<- max(dist, max_dist)
    } else {
      dests <- which((network$x1 == x) & (network$y1 == y))
      for (i in dests) {
        dfs(network$x2[i], network$y2[i], tx, ty, dist + network$dist[i])
      }
    }
    remove(list = hash, envir = visited)
  }

  dfs(2, 1, length(d[[1]]) - 1, length(d), 0)
  max_dist
}

part2 <- function(d) {
  part1(d, FALSE)
}

d <- parse_input("../inputs/input_23.txt")
c(part1(d), part2(d))
