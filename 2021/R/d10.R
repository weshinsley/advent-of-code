score_leftover <- function(x) {
  close <- c(")", "]", "}", ">")
  score <- 0
  
  for (i in seq_len(length(x))) {
    score <- (score * 5) + which(close == x[i])
  }
  score
}

invalid <- function(x) {
  stack <- rep(NA, length(x))
  top <- 1
  i <- 1
  open <- c("(", "[", "{", "<")
  close <- c(")", "]", "}", ">")
  scores <- c(3, 57, 1197, 25137)
  while (i <= length(x)) {
    if (x[i] %in% open) {
      stack[top] <- close[which(open == x[i])]
      top <- top + 1
    } else {
      if ((top > 1) && (x[i] != stack[top - 1])) {
        return (scores[which(close == x[i])])
      } else if (top > 1) {
        top <- top - 1
        stack[top] <- NA
      }
    }
    i <- i + 1
  }
  -score_leftover(rev(stack[1:(top-1)]))
}

ss <- function(x) {
  strsplit(x, "")[[1]]
}

solve <- function(d) {
  corrupt <- unlist(lapply(d, invalid))
  c(sum(corrupt[corrupt > 0]), -median(corrupt[corrupt < 0]))
}

part1 <- function(res) { res[1] }
part2 <- function(res) { res[2] }

d <- strsplit(readLines("../inputs/input_10.txt"), "")
res <- solve(d)
c(part1(res), part2(res))
