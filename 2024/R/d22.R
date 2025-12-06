source("../../shared/R/bignums.R")

produce <- function(n) {
  n <- bigXor(n * 64, n) %% 16777216
  n <- bigXor(n %/% 32, n) %% 16777216
  bigXor(n * 2048, n) %% 16777216
}

parse_file <- function(f = "../inputs/input_22.txt") {
  seeds <- as.numeric(readLines(f))
  d <- matrix(0, nrow = length(seeds), ncol = 2001)
  d[, 1] <- seeds
  for (i in 2:2001) {
    d[, i] <- produce(d[, i - 1])
  }
  d
}

part1 <- function(d) {
  sum(d[, 2001])
}

part2 <- function(d) {
  d <- d %% 10
  df_all <- as.data.frame(data.table::rbindlist(lapply(seq_len(nrow(d)), function(x) {
    diffs <- c(NA, diff(d[x, ]))
    df <- data.frame(x1 = 9 + diffs[2:(length(diffs) - 3)],
                     x2 = 9 + diffs[3:(length(diffs) - 2)],
                     x3 = 9 + diffs[4:(length(diffs) - 1)],
                     x4 = 9 + diffs[5:(length(diffs))])
    df$hash <- df$x1 + (df$x2 * 19) + (df$x3 * 19 * 19) + (df$x4 * 19 * 19 * 19)
    df$val <- d[x, 5:(length(diffs))]
    df[!duplicated(df$hash), ]
  })))
  df_all <- split(df_all, df_all$hash)
  max(unlist(lapply(df_all, function(x) sum(x$val))))
}

d <- parse_file()
c(part1(d), part2(d))
