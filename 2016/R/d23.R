prog <- read.csv(text = gsub("inc ","inc z ",gsub("dec ", "dec z ", 
  readLines("../inputs/input_23.txt"))), sep = " ", header = FALSE,
  col.names = c("op", "arg1", "arg2"))

trans <- data.frame(op1 = c("inc", "dec", "jnz", "cpy", "tgl"),
                    op2 = c("dec", "inc", "cpy", "jnz", "inc"))

solve <- function(part2 = FALSE, init_a = 7L) {
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
                          ifelse(intish(y), as.integer(y), b[[y]]), 1L)
    b
  }
  
  cpy <- function(b, x, y) {
    if (!intish(y)) {
      b[[y]] <- ifelse(intish(x), as.integer(x), b[[x]])
    }
    b$pc <- b$pc + 1L
    b
  }
  
  tgl <- function(p, b, x) {
    adr <- b$pc + ifelse(intish(x), as.integer(x), b[[x]])
    if (adr > nrow(p)) {
      return(p)
    }
    p$op[adr] <- trans$op2[trans$op1 == p$op[adr]]
    p
  }
  
  bunny <- list(pc = 1L, a = init_a, b = 0L, c = ifelse(part2, 1L, 0L), d = 0L)
  while (bunny$pc <= nrow(prog)) {
    line <- prog[bunny$pc, ]
    #message(sprintf("%s %s %s", line$op, line$arg1, line$arg2))
    if (line$op == "tgl") {
      prog <- tgl(prog, bunny, line$arg1)
      bunny$pc <- bunny$pc + 1
    } else {
      bunny <- do.call(line$op, list(b = bunny, x = line$arg1, y = line$arg2))
    }
  }
  bunny$a
}

# See readme for the Atari part 2 for breakdown

c(solve(), as.integer(factorial(12)) +
           (as.integer(prog$arg1[20]) * as.integer(prog$arg1[21])))

