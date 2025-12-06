source("../../shared/R/bignums.R")

parse_file <- function(f = "../inputs/input_17.txt") {
  d <- gsub("[^0-9,]", "", readLines(f))
  list(A = as.integer(d[1]), B = as.integer(d[2]), C = as.integer(d[3]),
       prog = as.integer(strsplit(d[5], ",")[[1]])
  )
}

execute <- function(d, p2 = FALSE) {
  if (is.null(d$ip)) d$ip <- 0
  cmd <- d$prog[d$ip + 1]
  op <- d$prog[d$ip + 2]
  litop <- op
  combo <- op
  if (combo == 4) combo = d$A
  else if (combo == 5) combo = d$B
  else if (combo == 6) combo = d$C
  out <- NULL
  if (cmd == 0)      d$A <- d$A %/% (2 ^ combo)
  else if (cmd == 1) d$B <- bigXor(d$B, litop)
  else if (cmd == 2) d$B <- combo %% 8
  else if (cmd == 4) d$B <- bigXor(d$B, d$C)
  else if (cmd == 5) out <- combo %% 8
  else if (cmd == 6) d$B <- d$A %/% (2 ^ combo)
  else if (cmd == 7) d$C <- d$A %/% (2 ^ combo)
  else if ((cmd == 3) && (d$A !=0) && (!p2)) {
    d$ip <- litop - 2
  }
  d$ip <- d$ip + 2
  list(d = d, out = out)
}

part1 <- function(d, p2 = FALSE) {
  d$ip <- 0
  out <- if (!p2) NULL else 0
  while ((d$ip + 1) <= length(d$prog)) {
    res <- execute(d, p2)
    d <- res$d
    if (!is.null(res$out)) {
      out <- if (!p2) paste0(out, res$out, ",") else 
                      (10 * out + as.integer(res$out))
    }
  }
  if (!p2) substring(out, 1, nchar(out) - 1) else out
}

part2 <- function(d) {
  target <- d$prog
  queue <- list(0, 1, 2, 3, 4, 5, 6, 7)
  best <- Inf
  for (i in rev(seq_along(d$prog))) {
    dig <- d$prog[i]
    nextq <- list()
    n <- 0
    for (entry in queue) {
      d$A <- as.numeric(entry)
      d2 <- part1(d, TRUE)
      if ((d2 %% 8) == dig) {
        if (i == 1) {
          best <- min(best, entry)
        } else {
          for (j in 0:7) {
            n <- n + 1
            nextq[[n]] <- (entry * 8) + j
          }
        }
      }
    }
    queue <- nextq
  }
  best
}

d <- parse_file()
c(part1(d), format(part2(d), digits = 16))