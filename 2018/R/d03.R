parseInput <- function(input) {
  df <- NULL
  for (s in input) {
    s <- as.numeric(unlist(strsplit(gsub("[#@,:x]", " ", s), "\\s+")))
    df <- rbind(df, data.frame(x = (1+s[3]), y = (1+s[4]), w = (-1+s[5]), h=(-1+s[6])))
  }
  df
}

advent3a <- function(df, parta = TRUE) {
  max_x <- max(df$x + df$w)
  max_y <- max(df$y + df$h)
  mat <- matrix(nrow = max_y, ncol = max_x, data = 0)
  overlap <- rep(0, nrow(df))
  tot <- 0
  for (d in seq_len(nrow(df))) {
    for (y in df$y[d]:(df$y[d]+df$h[d])) {
      for (x in df$x[d]:(df$x[d]+df$w[d])) {

        if (parta) {
          tot <- tot + (mat[y, x] == 1)
          mat[y, x] <- mat[y, x] + 1

        } else {
          if (mat[y, x] != 0) {
            overlap[d] <- 1
            overlap[mat[y, x]] <- 1
          }
          mat[y, x] <- d
        }
      }
    }
  }
  if (parta) tot
  else which(!overlap)
}

input <- parseInput(readLines("../inputs/input_3.txt"))
c(advent3a(input), advent3a(input, parta = FALSE))
