options(digits = 16)
parse_file <- function(f = "../inputs/input_7.txt") {
  lapply(readLines(f), function(x) as.numeric(strsplit(gsub(":", "", x), "\\s+")[[1]]))
}

part1 <- function(d, p2 = FALSE) {
  tot <- 0L
  for (i in seq_along(d)) {
    res <- d[[i]][1]
    nums <- d[[i]][-1]
    op <- rep(0, length(nums) - 1)
    done <- FALSE
    while (!done) {
      calc <- nums[1]
      for (j in seq_len(length(nums) - 1)) {
        if (op[j] == 0) {
          calc <- calc + nums[j + 1]
        } else if (op[j] == 1) {
          calc <- calc * nums[j + 1]
        } else if (op[j] == 2) {
          calc <- calc * (10 ^ nchar(nums[j + 1])) + nums[j + 1]
        }
        if (calc > res) {
          break
        }
      }
      if (calc == res) {
        tot <- tot + res
        break
      }
      
      dig <- 1
      while(TRUE) {
        op[dig] <- op[dig] + 1
        if (op[dig] == p2 + 2) {
          op[dig] <- 0
          dig <- dig + 1
          if (dig > length(op)) {
            done <- TRUE
            break
          }
        } else {
          break
        }
      }
    }
  }
  tot
}

part2 <- function(d) {
 part1(d, TRUE)
}

d <- parse_file()
c(part1(d), part2(d))
