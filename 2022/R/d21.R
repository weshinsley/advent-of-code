parse <- function(f) {
  d <- read.csv(text = gsub(":", "", readLines(f)), header = FALSE, sep = " ",
                col.names = c("left", "arg1", "op", "arg2"))
  assigns <- which(d$op == "")
  d$op[assigns] <- "="
  d$eqval[assigns] <- as.integer(d$arg1[assigns])
  d$arg1[assigns] <- NA
  d$arg2[assigns] <- NA
  d
}

part1 <- function(d, lookup = "root") {
  x <- d[d$left == lookup, ]
  if (nrow(x) == 0) return(NA)
  if (x$op == "=") {
    return (as.integer(x$eqval))
  } else if (x$op == "+") {
    return(part1(d, x$arg1) + part1(d, x$arg2))
  } else if (x$op == "*") {
    return(part1(d, x$arg1) * part1(d, x$arg2))
  } else if (x$op == "-") {
    return(part1(d, x$arg1) - part1(d, x$arg2))
  } else if (x$op == "/") {
    return(part1(d, x$arg1) / part1(d, x$arg2))
  }
}


part2 <- function(d) {

  solve2 <- function(d, var, answer) {
    x <- d[d$left == var,]
    rleft <- part1(d, x$arg1)
    rright <- part1(d, x$arg2)
    if (is.na(rleft)) {
      if (x$op == "+") {
      next_answer = answer - rright
      } else if (x$op == "-") {
        next_answer = answer + rright
      } else if (x$op == "/") {
        next_answer = answer * rright
      } else if (x$op == "*") {
        next_answer = answer / rright
      }
      if (x$arg1 == "humn") return(next_answer)
      else return(solve2(d, x$arg1, next_answer))

    } else {
      if (x$op == "+") {
        next_answer = answer - rleft
      } else if (x$op == "-") {
        next_answer = rleft - answer
      } else if (x$op == "/") {
        next_answer = rleft / answer
      } else if (x$op == "*") {
        next_answer = answer / rleft
      }
      if (x$arg2 == "humn") return(next_answer)
      else return(solve2(d, x$arg2, next_answer))
    }
  }

  x <- d[d$left == "root", ]
  d <- d[!d$left %in%  c("root", "humn"), ]
  rleft <- part1(d, x$arg1)
  rright <- part1(d, x$arg2)
  if (is.na(rleft)) return(solve2(d, x$arg1 ,rright))
  else return(solve2(d, x$arg2, rleft))

}

d <- parse("../inputs/input_21.txt")
c(format(part1(d), digits = 15), format(part2(d), digits = 15))
