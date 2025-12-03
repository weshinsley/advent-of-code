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

c(solve1(readLines("../inputs/input_16.txt")[1], 100),
  solve2(readLines("../inputs/input_16.txt")[1], 100))
