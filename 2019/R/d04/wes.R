library(testthat)

valid1 <- function(num) {
  chars <- strsplit(as.character(num), "")[[1]]
  dup <- FALSE
  dec <- FALSE
  for (j in seq_len(length(chars)-1)) {
    dup <- dup | (chars[j] == chars[j+1])
    dec <- dec | (chars[j + 1] < chars[j])
  }
  (dup && !dec)
}

valid2 <- function(num) {
  chars <- strsplit(as.character(num), "")[[1]]
  dup <- FALSE
  dec <- FALSE
  for (j in seq_len(length(chars)-1)) {
    ch_prev <- "!"
    ch_next <- "!"
    if (j > 1) ch_prev <- chars[j - 1]
    if (j + 2 <= length(chars)) ch_next <- chars[j + 2]
    dup <- dup | ((chars[j] == chars[j+1]) && 
                  (chars[j+1] != ch_next) && 
                  (chars[j] != ch_prev))
    dec <- dec | (chars[j + 1] < chars[j])
  }
  (dup && !dec)
}

test <- function() {
  expect_true(valid1(111111))
  expect_false(valid1(223450))
  expect_false(valid1(123789))
  expect_true(valid2(112233))
  expect_false(valid2(123444))
  expect_true(valid2(111122))
}

test()
range <- strsplit(readLines("d04/wes-input.txt"), "-")[[1]]
sum(unlist(lapply(range[1]:range[2], valid1)))
sum(unlist(lapply(range[1]:range[2], valid2)))
