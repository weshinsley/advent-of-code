prog <- read.csv(text = gsub("inc ","inc z ",gsub("dec ", "dec z ", 
  readLines("../AtariBasic/d12/INPUT.TXT"))), sep = " ", header = FALSE,
  col.names = c("op", "arg1", "arg2"))

solve <- function(part2 = FALSE) {
  intish <- function(i) {
    !is.na(suppressWarnings(as.integer(i)))
  }
  
  inc <- function(b, x, y, delta = 1L) {
    b[[y]] <- b[[y]] + delta
    b$pc <- b$pc + 1L
    b
  }
  
  dec <- function(b, x, y) {
    inc(b, x, y, -1L)
  }
  
  jnz <- function(b, x, y) {
    b$pc <- b$pc + ifelse(ifelse(intish(x), as.integer(x), b[[x]]) != 0L, 
                          as.integer(y), 1L)
    b
  }
  
  cpy <- function(b, x, y) {
    b[[y]] <- ifelse(intish(x), as.integer(x), b[[x]])
    b$pc <- b$pc + 1L
    b
  }
  
  bunny <- list(pc = 1L, a = 0L, b = 0L, c = ifelse(part2, 1L, 0L), d = 0L)
  while (bunny$pc <= nrow(prog)) {
    line <- prog[bunny$pc, ]
    bunny <- do.call(line$op, list(b = bunny, x = line$arg1, y = line$arg2))
  }
  bunny$a
}

c(solve(), solve(TRUE))
