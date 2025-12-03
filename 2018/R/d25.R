close <- function(p1, p2) {
  sum(abs(p1 - p2)) <= 3
}

advent25a <- function(points) {
  cons <- NULL
  for (p in points) {
    found <- rep(FALSE, length(cons))
    for (i in seq_len(length(cons))) {
      for (j in seq_len(length(cons[[i]]))) {
        if (close(p, cons[[i]][[j]])) {
          found[i] <- TRUE
          break
        }
      }
    }
    count <- sum(found)
    if (count == 0) {
      cons <- c(cons, list(list(p)))
    } else if (count == 1) {
      index <- which(found)
      cons[[index]] <- c(cons[[index]], list(p))
    } else {
      indexes <- which(found)
      first <- indexes[1]
      indexes <- indexes[2:length(indexes)]
      cons[[first]] <- c(cons[[first]], list(p))
      for (i in indexes) {
        cons[[first]] <- c(cons[[first]], cons[[i]])
      }
      cons[indexes] <- NULL
    }
  }
  length(cons)

}

points <- lapply(readLines("../inputs/input_25.txt"), function(x) as.numeric(unlist(strsplit(x, ","))))
advent25a(points)
