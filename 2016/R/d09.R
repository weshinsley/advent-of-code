d <- strsplit(readLines("../inputs/input_9.txt"), "")[[1]]

solve <- function(d, part2 = FALSE) {
  b <- which(d == "(")
  cb <- which(d == ")")
  ct <- 0
  i <- 1
  while (i <= length(d)) {
    if (i %in% b) {
      j <- min(cb[cb > i])
      s <- as.integer(strsplit(paste(d[(i+1):(j-1)], collapse = ""), "x")[[1]])
      ct <- ct + ifelse(!part2, s[1] * s[2], s[2] * solve(d[(j+1):(j+s[1])], part2))
      i <- j + 1 + s[1]
    } else {
      j <- ifelse(length(b[b > i]) == 0, length(d) + 1, min(b[b > i]))
      ct <- ct + (j - i)
      i <- j
    }
  }
  ct
}

c(solve(d), solve(d, TRUE))
