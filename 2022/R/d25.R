parse <- function(f) {
  readLines(f)
}

snafu_to_normal <- function(n) {
  n <- strsplit(n, "")[[1]]
  x <- 1
  t <- 0
  for (j in length(n):1) {
    if (n[[j]] == "2")  t <- t + (x * 2)
    else if (n[[j]] == "1") t <- t + (x * 1)
    else if (n[[j]] == "-") t <- t - x
    else if (n[[j]] == "=") t <- t - (x * 2)
    x <- x * 5
  }
  t
}

normal_to_snafu <- function(n) {
  if (n == 0) ""
  else if ((n %% 5) == 0) paste0(normal_to_snafu(n %/% 5), "0")
  else if ((n %% 5) == 1) paste0(normal_to_snafu(n %/% 5), "1")
  else if ((n %% 5) == 2) paste0(normal_to_snafu(n %/% 5), "2")
  else if ((n %% 5) == 3) paste0(normal_to_snafu((n + 2) %/% 5), "=")
  else if ((n %% 5) == 4) paste0(normal_to_snafu((n + 1) %/% 5), "-")
}

part1 <- function(d) {
  tot <- sum(unlist(lapply(d, snafu_to_normal)))
  normal_to_snafu(tot)
}

test <- function() {
  stopifnot(snafu_to_normal("1") == 1)
  stopifnot(snafu_to_normal("2") == 2)
  stopifnot(snafu_to_normal("1=") == 3)
  stopifnot(snafu_to_normal("1-") == 4)
  stopifnot(snafu_to_normal("10") == 5)
  stopifnot(snafu_to_normal("11") == 6)
  stopifnot(snafu_to_normal("12") == 7)
  stopifnot(snafu_to_normal("2=") == 8)
  stopifnot(snafu_to_normal("2-") == 9)
  stopifnot(snafu_to_normal("20") == 10)
  stopifnot(snafu_to_normal("1=0") == 15)
  stopifnot(snafu_to_normal("1-0") == 20)
  stopifnot(snafu_to_normal("1=11-2") == 2022)
  stopifnot(snafu_to_normal("1-0---0") == 12345)
  stopifnot(snafu_to_normal("1121-1110-1=0") == 314159265)

  stopifnot(normal_to_snafu(1747) == "1=-0-2")
  stopifnot(normal_to_snafu(906) == "12111")
  stopifnot(normal_to_snafu(198) == "2=0=")
  stopifnot(normal_to_snafu(11) == "21")
  stopifnot(normal_to_snafu(201) == "2=01")
  stopifnot(normal_to_snafu(31) == "111")
  stopifnot(normal_to_snafu(1257) == "20012")
  stopifnot(normal_to_snafu(32) == "112")
  stopifnot(normal_to_snafu(353) == "1=-1=")
  stopifnot(normal_to_snafu(107) == "1-12")
  stopifnot(normal_to_snafu(7) == "12")
  stopifnot(normal_to_snafu(3) == "1=")
  stopifnot(normal_to_snafu(37) == "122")

}

test()
d <- parse("../inputs/d25-input.txt")
part1(d)
