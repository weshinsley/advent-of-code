# So, this does a shortest path through a grid.
# m is a matrix (indexes m[y, x]) - I'm assuming
# it is padded  (as in pad_matrix), starting
# distance is zero, all boundaries and blocks 
# are negative (hence we don't visit them).
# sxy and exy are start/end (x,y) co-ords.

shortest_path_bfs <- function(m, sxy, exy) {
  dx <- c(1, 0, -1, 0)
  dy <- c(0, 1, 0, -1)

  queue <- list(c(sxy[1], sxy[2], 0))
  i <- 0
  n <- 1
  best <- Inf
  m[sxy[2], sxy[1]] <- 0
  while (i < n) {
    i <- i + 1
    xys <- queue[[i]]
    x <- xys[1]
    y <- xys[2]
    s <- xys[3]
    if (x == exy[1] && y == exy[2]) {
      best <- min(best, s)
    }
    if (s >= best) {
      next
    }
      
    for (dir in 1:4) {
      if (m[y + dy[dir], x + dx[dir]] > s + 1) {
        n <- n + 1
        queue[[n]] <- c(x + dx[dir], y + dy[dir], s + 1)
        m[y + dy[dir], x + dx[dir]] <- s + 1
      }
    }
  }
  list(best = best, visited = m)
}
