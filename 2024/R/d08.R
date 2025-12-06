parse_file <- function(f = "../inputs/input_8.txt") {
  grid <- readLines(f)
  h <- length(grid)
  w <- nchar(grid[1])
  txt <- strsplit(paste0(grid, collapse = ""), "")[[1]]
  things <- names(table(txt))
  things <- things[things != "."]
  df <- data.frame()
  for (n in things) {
    df <- rbind(df, data.frame(name = n, pos = which(txt == n) - 1))
  }
  df$y <- 1 + (df$pos %/% w)
  df$x <- 1 + (df$pos %% w)
  list(df = df, w = w, h = h)
}

part1 <- function(d, p2 = FALSE) {
  m <- matrix(0, nrow = d$h, ncol = d$w)
  anten <- unique(d$df$name)
  for (n in anten) {
    p <- which(d$df$name == n)
    for (i in p) {
      for (j in p[p != i]) {
        dx <- d$df$x[j] - d$df$x[i]
        dy <- d$df$y[j] - d$df$y[i]
        nx1 <- d$df$x[i]
        ny1 <- d$df$y[i]
        nx2 <- d$df$x[j]
        ny2 <- d$df$y[j]
        if (p2) {
          m[ny2, nx2] <- 1
          m[ny1, nx1] <- 1
        }
        done <- FALSE
        while (!done) {
          nx1 <- nx1 - dx
          ny1 <- ny1 - dy
          nx2 <- nx2 + dx
          ny2 <- ny2 + dy
          done <- TRUE
          if ((nx1 >= 1) && (nx1 <= d$w) && (ny1 >= 1) && (ny1 <= d$h)) {
            m[ny1, nx1] <- 1
            done <- !p2
          }
          if ((nx2 >= 1) && (nx2 <= d$w) && (ny2 >= 1) && (ny2 <= d$h)) {
            m[ny2, nx2] <- 1
            done <- !p2
          }
        }
      }
    }
  }
  sum(m)
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_file()
c(part1(d), part2(d))
