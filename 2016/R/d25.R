prog <- read.csv(text = gsub("inc ","inc z ",gsub("dec ", "dec z ",
                        gsub("out ","out z ",
  readLines("../inputs/input_25.txt")))), sep = " ", header = FALSE,
  col.names = c("op", "arg1", "arg2"))

solve <- function(a_val) {
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
  
  res <- ""
  bunny <- list(pc = 1L, a = a_val, b = 0L, c = 0L, d = 0L)
  while (bunny$pc <= nrow(prog)) {
    line <- prog[bunny$pc, ]
    if (line$op == "out") {
      res <- paste0(res, ifelse(intish(line$arg2), as.integer(line$arg2),
                                bunny[[line$arg2]]))
      bunny$pc <- bunny$pc + 1
      if (nchar(res) == 8) return(res)
    } else {
      bunny <- do.call(line$op, list(b = bunny, x = line$arg1, y = line$arg2))
    }
  }
  res
}


i <- 1
while (solve(i) != "01010101") {
  i <- i + 1
}
i

