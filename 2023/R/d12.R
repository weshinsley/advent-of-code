parse_input <- function(f) {
  lapply(readLines(f), function(x) {
    bits <- strsplit(x, " ")[[1]]
    list(lhs = strsplit(bits[1], "")[[1]],
         rhs = as.integer(strsplit(bits[2], ",")[[1]]))
  })
}

solve_single <- function(lhs, block_sizes, p2 = FALSE) {
  memo <- new.env()

  solve2 <- function(block_no = 1, start_pos = 1,
                     block_pos = rep(0, length(block_sizes))) {

    memo_name <- sprintf("x_%s_%s", block_no, start_pos)
    if (exists(memo_name, envir = memo)) {
      return(get(memo_name, envir = memo))
    }

    return_set <- function(x) {
      assign(memo_name, x, envir = memo)
      return(x)
    }

    res <- 0
    last <- (1 + length(lhs)) -
      (sum(1 + block_sizes[block_no:length(block_sizes)]) - 1)

    if (last < start_pos) return_set(0)    # Off the right-hand side

    for (start in start_pos:last) {
      end <- start + block_sizes[block_no] - 1

      ## 1. Can't replace . with #
      ## 2. Can't leave unmatched # behind us
      if ((any(lhs[start:end] == ".")) ||
          ((start > start_pos) && (any(lhs[start_pos:(start - 1)] == "#")))) {
        next
      }

      if (block_no == length(block_sizes)) {
        if ((end  < length(lhs)) && (any(lhs[(end + 1):length(lhs)] == "#"))) {
          next   # All done - can't be any leftover # to the right of us
        }
        res <- res + 1   # Success
      } else {
        if (lhs[end + 1] == "#") next   # If a # immediately after us, fail
        block_pos[block_no] <- start    # Otherwise, accept, and next block
        res <- res + solve2(block_no + 1, start + block_sizes[block_no] + 1,
                              block_pos)

      }
    }
    return_set(res)
  }

  if (p2) {
    lhs <- rep(c("?", lhs), 5)[-1]
    block_sizes <- rep(block_sizes, 5)
  }

  solve2()
}

solve_all <- function(d, p2 = FALSE) {
  sum(unlist(lapply(d, function(x) {
    solve_single(x$lhs, x$rhs, p2)
  })))
}

part1 <- function(d) {
  solve_all(d)
}

part2 <- function(d) {
  format(solve_all(d, TRUE), digits = 12)
}

d <- parse_input("../inputs/input_12.txt")
c(part1(d), part2(d))
