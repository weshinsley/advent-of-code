d <- strsplit(readLines("../inputs/input_24.txt"), "")
maxn <- -1
while (as.character(maxn+1) %in% unlist(d)) { maxn <- maxn + 1 }

bfs <- function(d, n) {
  for (y in seq_len(length(d))) {
    if (n %in% d[[y]]) {
      x <- which(d[[y]] == n)
      break
    }
  }
  dist <- lapply(d, function(x) rep(99999, length(x)))
  queue <- list()
  head <- 1
  queue[[head]] <- c(x,y)
  dist[[y]][x] <- 0
  tail <- 1
  found <- 0
  best <- rep(999999, maxn + 1)
  best[as.integer(n) + 1] <- 0
  dx <- c(1, 0, -1, 0)
  dy <- c(0, -1, 0, 1)
  while (any(best == 999999)) {
    h <- queue[[head]]
    head <- head + 1
    bd <- dist[[h[2]]][h[1]]
    for (dir in 1:4) {
      ch <- d[[h[2] + dy[dir]]][h[1] + dx[dir]]
      if (ch == '#') next
      if (dist[[h[2] + dy[dir]]][h[1] + dx[dir]] <= bd + 1) next
      if (ch != '.') {
        best[as.numeric(ch)+1] <- min(best[as.numeric(ch)+1], bd + 1)
      }
      tail <- tail + 1
      queue[[tail]] <- c(h[1] + dx[dir], h[2] + dy[dir])
      dist[[h[2]+dy[dir]]][h[1]+dx[dir]] <- bd + 1
    }
  }
  best
}

mat <- list()
for (i in 0:maxn) {
  mat[[i+1]] <- bfs(d, as.character(i))
}

dfs <- function(mat, part2 = FALSE) {
  bestd <- 999999
  if (part2) {
    mat[[9]] <- mat[[1]]
    for (i in 1:8) {
      mat[[i]][9] <- mat[[1]][i]
    }
    mat[[9]][9] <- 0
  }
  
  dfs2 <- function(sofar, current, left, part2) {
    if ((part2) && (!9 %in% left) && (length(left) > 0)) {
      return()
    }
    if (length(left) == 0) {
      bestd <<- min(bestd, sofar)
    } else {
      for (move in seq_along(left)) {
        dfs2(sofar + mat[[current]][left[move]], left[move], left[-move], part2)
      }
    }
  }
  dfs2(0, 1, 2:length(mat), part2)
  bestd
}

c(dfs(mat), dfs(mat, TRUE))
