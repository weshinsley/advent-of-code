suppressMessages(library(bit64))

DNEW <- 0
DINC <- 1
CUT <- 2

parse <- function(lines) {
  result <- list()
  for (line in lines) {
    if (grepl("new stack", line)) {
      result <- c(result, list(c(DNEW, 0)))
    } else if (grepl("increment", line)) {
      result <- c(result, list(c(DINC, as.integer(substring(line, 21)))))
    } else {
      result <- c(result, list(c(CUT, as.integer(substring(line, 5)))))
    }
  }
  result
}

solve1 <- function(input, follow, no_cards) {
  for (i in seq_along(input)) {
    op <- input[[i]]

    if (op[1] == DNEW) follow <- (no_cards - 1) - follow
    
    else if (op[1] == CUT) {
      follow <- follow - op[2]
      if (follow < 0) follow <- follow + no_cards
      if (follow >= no_cards) follow <- follow - no_cards
    
    } else if (op[1] == DINC) {
      follow <- (follow * op[2]) %% no_cards
    }
  }
  follow
}

solve2 <- function(input, no_cards, no_shuffles, pos) {
  "I'm going to ask James how to do the maths."
}

input <- parse(readLines("../inputs/input_22.txt"))
c(solve1(input, 2019, 10007),
  solve2(input, 119315717514047, 101741582076661, 2020))
