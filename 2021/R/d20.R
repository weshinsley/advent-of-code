read_input <- function(f) {
  d <- gsub("#", 1, gsub("\\.", 0, readLines(f)))
  matrix <- matrix(as.integer(unlist(strsplit(d[3:length(d)], ""))), nrow = length(d) - 2)
  list(alg = as.integer(strsplit(d[[1]], "")[[1]]),
       img = matrix)
}

enhance <- function(alg, img, steps) {
  S4 <- steps * 4L
  S2 <- steps * 2L
  big <- matrix(0L, nrow = nrow(img) + S4, ncol = ncol(img) + S4)
  big[(S2+1L):(S2 + ncol(img)), (S2+1L):(S2 + nrow(img))] <- img
  mat2 <- big
  pows <- c(256L,128L,64L,32L,16L,8L,4L,2L,1L)
  for (i in 0L:(steps - 1L)) {
    for (x in 2L:(ncol(mat2) - 1L)) {
      for (y in 2L:(ncol(mat2) - 1L)) {
        val <- sum(as.integer(big[(x - 1L):(x + 1L), (y - 1L):(y + 1L)]) * pows)
        mat2[x, y] <- alg[val + 1L]
      }
    }
    
    if ((i %% 2L) == 1L) {
      mat2[2L, ] <- 0L
      mat2[ncol(mat2) - 1L, ] <- 0L
    }
    big <- mat2
  }
  sum(mat2)
}
  
part1 <- function(d, n = 2) { enhance(d$alg, d$img, n) }
part2 <- function(d) { part1(d, 50) }

d <- read_input("../inputs/input_20.txt")
c(part1(d), part2(d))
