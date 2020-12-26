test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

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

input <- readLines("input.txt")
gen_a <- as.numeric(gsub("Generator A starts with ","", input[1]))
gen_b <- as.numeric(gsub("Generator B starts with ","", input[2]))

test(advent15a(65, 8921, 40000000), 588)
advent15a(gen_a,gen_b,40000000)
test(advent15b(65, 8921, 5000000), 309)
advent15b(gen_a,gen_b,5000000)
