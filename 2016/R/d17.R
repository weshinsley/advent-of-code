d <- readLines("../inputs/input_17.txt")

solve <- function(part2 = FALSE) {
  queue <- list(list(code = d, x = 1, y = 1))
  head <- 1
  tail <- 2
  dx <- c(0, 0, -1, 1)
  dy <- c(-1, 1 ,0, 0)
  dd <- c("U", "D", "L", "R")
  max_steps <- 0
  while (tail > head) {
    room <- queue[[head]]
    head <- head + 1
    if ((room$x == 4) && (room$y == 4)) {
      if (!part2) {
        return(substring(room$code, nchar(d) + 1))
      } else {
        max_steps <- nchar(room$code) - nchar(d)
      }
      next
    }
    md5 <- substring(digest::digest(room$code, algo="md5", serialize = FALSE), 1, 4)
    for (dir in 1:4) {
      if ((as.integer(room$x + dx[dir]) %in% 1:4) &&
          (as.integer(room$y + dy[dir]) %in% 1:4) &&
          (grepl(substring(md5, dir, dir), "bcdef"))) {
          queue[[tail]] <- list(code = paste0(room$code, dd[dir]),
                                   x = room$x + dx[dir],
                                   y = room$y + dy[dir])
          tail <- tail + 1
      }
    }
  }
  max_steps
}

c(solve(), solve(TRUE))
