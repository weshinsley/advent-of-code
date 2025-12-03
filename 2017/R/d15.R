advent15a <- function(g1, g2, n) {
  score <- 0
  while (n > 0) {
    g1 <- (g1 * 16807) %% 2147483647
    g2 <- (g2 * 48271) %% 2147483647
    if ((g1 %% 65536) == (g2 %% 65536)) {
      score <- score + 1
    }
    n <- (n-1)
  }
  score
}

advent15b <- function(g1, g2, n) {
  score <- 0
  while (n > 0) {
    while (TRUE) {
      g1 <- (g1 * 16807) %% 2147483647
      if (g1 %% 4 == 0) break
    }
    while (TRUE) {
      g2 <- (g2 * 48271) %% 2147483647
      if (g2 %% 8 == 0) break
    }
    if ((g1 %% 65536) == (g2 %% 65536)) {
      score <- score + 1
    }
    n <- (n-1)
  }
  score
}

input <- readLines("../inputs/input_15.txt")
gen_a <- as.numeric(gsub("Generator A starts with ","", input[1]))
gen_b <- as.numeric(gsub("Generator B starts with ","", input[2]))

c(advent15a(gen_a,gen_b,40000000), advent15b(gen_a,gen_b,5000000))
