library(testthat)

solve1 <- function(input, iters) {
  input <- as.numeric(strsplit(input, "")[[1]])
  output <- rep(0, length(input))
  base <- c(0, 1, 0, -1)
  
  while (iters > 0) {
    for (row in seq_along(input)) {
      val <- 0
      base_pointer <- 1
      freq <- row
      count <- 0
      col <- 1

      # Skip (freq - 1) zeroes at the start.
    
      if (count != freq) col <- 1 + (freq - 1)

      count <- 0
      base_pointer <- base_pointer + 1

      while (col <= length(input)) {
        val <- val + (input[col] * base[base_pointer])
        col <- col + 1
        count <- count + 1
        if (count == freq) {
          count <- 0
          base_pointer <- (base_pointer %% 4) + 1

          if (base[base_pointer] == 0) {
            col <- col + freq
            base_pointer <- base_pointer + 1
          }
        }
      }

      output[row] = abs(val) %% 10
    }
    iters <- iters - 1
    input <- output
  }
  paste(input[1:8], collapse = "")
}

# solve2 only works when the offset is in the second half of the list...
# (hence all the pattern elements are 1)

solve2 <- function(input, phases) {
  offset <- as.numeric(substring(input,1,7))
  input <- as.numeric(strsplit(input, "")[[1]])
  expanded <- rep(input, 10000)
  while (phases > 0) {
    phases <- phases - 1
    total <- 0
    j <- length(expanded)
    while (j > offset) {
      total <- total + expanded[j]
      expanded[j] = total %% 10
      j <- j - 1
    }
  }
  paste(expanded[(offset+1):(offset+8)], collapse = "")
}

test <- function() {
  expect_equal(solve1("12345678", 1), "48226158")
  expect_equal(solve1("12345678", 2), "34040438")
  expect_equal(solve1("12345678", 3), "03415518")
  expect_equal(solve1("12345678", 4), "01029498")
  expect_equal(solve1("80871224585914546619083218645595", 100),"24176176")
  expect_equal(solve1("19617804207202209144916044189917", 100),"73745418")
  expect_equal(solve1("69317163492948606335995924319873", 100),"52432133")
  expect_equal(solve2("03036732577212944063491565474664", 100), "84462026")
  expect_equal(solve2("02935109699940807407585447034323", 100), "78725270")
  expect_equal(solve2("03081770884921959731165446850517", 100), "53553731")
}

test()
message(sprintf("Part 1: %s", solve1(readLines("d16/wes-input.txt")[1], 100)))
message(sprintf("Part 2: %s", solve2(readLines("d16/wes-input.txt")[1], 100)))
