advent5a <- function(code) {
  i <- 1
  steps <- 0
  while ((i >= 1) && (i <= length(code))) {
    oldi <- i
    i <- i + code[i]
    code[oldi] <- code[oldi] + 1
    steps <- steps + 1
  }
  steps
}

advent5b <- function(code) {
  i <- 1
  steps <- 0
  while ((i >= 1) && (i <= length(code))) {
    oldi <- i
    i <- i + code[i]
    if (code[oldi]>=3) {
      code[oldi] <- code[oldi] - 1
    } else {
      code[oldi] <- code[oldi] + 1
    }
    steps <- steps + 1
  }
  steps
}

code <- as.numeric(readLines("../inputs/input_5.txt"))
c(advent5a(code), advent5b(code))
