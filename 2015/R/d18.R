d <- strsplit(paste(readLines("../inputs/input_18.txt"), collapse=""), "")[[1]] == '#'
n <- sqrt(length(d))
neigh <- lapply(seq_along(d), function(x) {
  c((x-n)-1, x-n, (x-n)+1, x-1, x+1, (x+n)-1, x+n, x+n+1)
})
neigh[[1]] <- c(2, n + 1, n + 2)
neigh[[n]] <- c(n - 1, n + n - 1, n + n)
neigh[[((n-1)*n)+1]] <- c(((n-1)*n)+2, (n-2)*n, ((n-2)*n)+1)
neigh[[n*n]] <- c((n*n)-1, (n*n)-n, ((n*n)-n)-1)
for (i in 2:(n-1)) neigh[[i]] <- c(i-1, i+1, (i-1)+n, i+n, i+1+n)
for (i in (((n-1)*n)+2):((n*n)-1)) neigh[[i]] <- c(i-1, i+1, (i-1)-n, i-n, (i+1)-n)
for (j in seq(n+1, ((n-2)*n)+1, by = n)) neigh[[j]] <- c(j-n, (j-n)+1, j+1, j+1+n, j+n)
for (j in seq(n+n, (n*n)-n, by = n)) neigh[[j]] <- c(j-n, (j-n)-1, j-1, (j+n)-1, j+n)

update <- function(d, n, part2 = FALSE) {
  corners <- c(1, 100, 10000, 9901)
  part2 <- rep(part2, 4)
  d[corners] <- ifelse(part2, TRUE, d[corners])
  for (i in seq_len(n)) {
    d <- unlist(lapply(seq_along(neigh), function(x) {
      s <- sum(d[neigh[[x]]])
      ifelse(d[x], s %in% c(2,3), s == 3) 
    }))
    d[corners] <- ifelse(part2, TRUE, d[corners])
  }
  sum(d)
}

c(update(d, 100), update(d, 100, TRUE))
