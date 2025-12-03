int_to_base <- function(v) {
  chars <- unlist(strsplit("0123456789ABCDEF",""))
  b <- length(chars)
  paste0(chars[1 + (v%/%b)], chars[1 + (v %% b)])
}

advent6a <- function(blocks, reps=0) {
  mem <- paste(unlist(lapply(blocks, int_to_base)),collapse="")
  result <- 0
  steps <- 0
  while ((result == 0) && (reps>=0)) {
    steps <- steps + 1
    redist <- max(blocks)
    start <- min(which(blocks == redist))
    blocks[start] <- 0
    while (redist > 0) {
      start <- start + 1
      if (start > length(blocks)) start <- 1
      blocks[start] <- blocks[start] + 1
      redist <- redist - 1
    }
    hval <- paste(unlist(lapply(blocks, int_to_base)),collapse="")
    if (sum(mem == hval)==0) mem = c(mem, hval)
    else {
      if (reps == 0) {
        result <- steps
      } else {
        mem <- paste(unlist(lapply(blocks, int_to_base)),collapse="")
        steps <- 0
      }
      reps <- reps - 1
    }
  }
  result
}

advent6b <- function(blocks) {
  advent6a(blocks, reps = 1)
}

blocks <- as.numeric(unlist(strsplit(readLines("../inputs/input_6.txt"), "\t")))
c(advent6a(blocks), advent6b(blocks))
