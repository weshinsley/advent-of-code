parse <- function(f) {
  d <- read.csv(text = gsub(" -> ", " ", 
    gsub("NOT", "0 NOT", readLines(f))), sep = " ",
    header = FALSE, col.names = c("arg1", "op", "arg2", "dest"))
  assigns <- which(d$dest == "")
  d$dest[assigns] <- d$op[assigns]
  d$op[assigns] <- "EQ"
  d$arg2[assigns] <- 0
  d$stage <- 0
  d$stage[numberish(d$arg1) & numberish(d$arg2)] <- 1
  d[, c("dest", "op", "arg1", "arg2", "stage")]
}

numberish <- function(s) suppressWarnings(!is.na(as.numeric(s)))
RSHIFT <- function(x, y) bitwShiftR(as.numeric(x), as.numeric(y))
LSHIFT <- function(x, y) bitwShiftL(as.numeric(x), as.numeric(y)) 
NOT <- function(x, y) bitwNot(as.numeric(y))
AND <- function(x, y) bitwAnd(as.numeric(x), as.numeric(y))
OR <- function(x, y) bitwOr(as.numeric(x), as.numeric(y))
EQ <- function(x, y) as.numeric(x)

solve <- function(d) {
  while(any(d$stage < 2)) {
    is <- which(d$stage == 1)
    for (i in is) {
      res <- do.call(d$op[i], list(d$arg1[i], d$arg2[i]))
      d$arg1[d$arg1 == d$dest[i]] <- res
      d$arg2[d$arg2 == d$dest[i]] <- res
      d$stage[i] <- 2
    }
    d$stage <- ifelse(d$stage == 0, numberish(d$arg1) & numberish(d$arg2),
                      d$stage)
  }
  res <- which(d$dest == "a")
  do.call(d$op[res], list(d$arg1[res], d$arg2[res]))
}

d <- parse("../inputs/input_7.txt")
p1 <- solve(d)
d$arg1[d$dest == 'b'] <- p1
c(p1, solve(d))
                  

