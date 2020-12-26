test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

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

code <- as.numeric(readLines("input.txt"))

test(advent5a(c(0,3,0,1,-3)), 5)
advent5a(code)

test(advent5b(c(0,3,0,1,-3)), 10)
advent5b(code)
