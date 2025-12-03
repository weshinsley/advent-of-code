d <- strsplit(readLines("../inputs/input_11.txt"), "")[[1]]
lets <- letters[!letters %in% c("i", "o", "l")]
pairs <- unlist(lapply(lets, function(x) paste(rep(x, 2), collapse = "")))
inc <- function(d) {
  x <- 8
  while(TRUE) {
    d[x] <- ifelse(d[x] == 'z', 'a', lets[which(lets == d[x]) + 1])
    if (d[x] != 'a') {
      break
    }
    x <- x - 1
  }
  d
}

ok <- function(d) {
  if (sum(unlist(lapply(pairs, grepl, paste(d, collapse = "")))) < 2) {
    return(FALSE)
  }
  if (!1 %in% diff(which(diff(utf8ToInt(paste(d, collapse = ""))) == 1))) {
    return(FALSE)
  }
  TRUE
}

nxt <- function(d) {
  while (!ok(d)) {
    d <- inc(d)
  }
  d
}

d1 <- nxt(inc(d))
d2 <- nxt(inc(d1))
c(paste(d1, collapse=""), paste(d2, collapse=""))
