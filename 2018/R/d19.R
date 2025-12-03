exec <- function(regs, code, codes) {
       if (code == 0) regs[codes[3]+1] <- regs[codes[1] + 1] + regs[codes[2]+1]                 # ADDR
  else if (code == 1) regs[codes[3]+1] <- regs[codes[1] + 1] + codes[2]                         # ADDI
  else if (code == 2) regs[codes[3]+1] <- regs[codes[1] + 1] * regs[codes[2]+1]                 # MULR
  else if (code == 3) regs[codes[3]+1] <- regs[codes[1] + 1] * codes[2]                         # MULI
  else if (code == 4) regs[codes[3]+1] <- bitwAnd(regs[codes[1] + 1], regs[codes[2]+1])         # BANR
  else if (code == 5) regs[codes[3]+1] <- bitwAnd(regs[codes[1] + 1], codes[2])                 # BANI
  else if (code == 6) regs[codes[3]+1] <- bitwOr(regs[codes[1] + 1], regs[codes[2]+1])          # BORR
  else if (code == 7) regs[codes[3]+1] <- bitwOr(regs[codes[1] + 1], codes[2])                  # BORI
  else if (code == 8) regs[codes[3]+1] <- regs[codes[1] + 1]                                    # SETR
  else if (code == 9) regs[codes[3]+1] <- codes[1]                                              # SETI
  else if (code == 10) regs[codes[3]+1] <- as.integer(codes[1] > regs[codes[2] + 1])            # GTIR
  else if (code == 11) regs[codes[3]+1] <- as.integer(regs[codes[1] + 1] > codes[2])            # GTRI
  else if (code == 12) regs[codes[3]+1] <- as.integer(regs[codes[1] + 1] > regs[codes[2] + 1])  # GTRR
  else if (code == 13) regs[codes[3]+1] <- as.integer(codes[1] == regs[codes[2] + 1])           # EQIR
  else if (code == 14) regs[codes[3]+1] <- as.integer(regs[codes[1] + 1] == codes[2])           # EQRI
  else if (code == 15) regs[codes[3]+1] <- as.integer(regs[codes[1] + 1] == regs[codes[2] + 1]) # EQRR
  regs
}

ops <- c("addr", "addi", "mulr", "muli", "banr", "bani", "borr", "bori", 
         "setr", "seti", "gtir", "gtri", "gtrr", "eqir", "eqri", "eqrr")

parse_input <- function(input) {
  program <- lapply(input[-1], function(x) unlist(strsplit(x, " ")))
  for (p in seq_len(length(program))) {
    program[[p]][1] <- which(program[[p]][1] == ops) - 1
  }
  program <- lapply(program, as.numeric)
  ip_reg <- as.numeric(strsplit(input[1], " ")[[1]][2])
  list(program, ip_reg)
}

advent19a <- function(data) {
  ip_reg <- data[[2]][1] + 1
  regs <- rep(0,6)
  while (regs[ip_reg] < length(data[[1]])) {
    line <- data[[1]][[regs[ip_reg] + 1]]
    regs <- exec(regs, line[1], line[2:4])
    regs[ip_reg] <- regs[ip_reg] + 1
  }
  regs[1]              
}

advent19b <- function(data) {
  dest_reg <- data[[1]][[34]][4]
  regs <- rep(0,6)
  regs[1] <- 1;
  ip_reg <- data[[2]][1] + 1
  
  while (regs[ip_reg] !=1) {
    line <- data[[1]][[regs[ip_reg] + 1]]
    regs <- exec(regs, line[1], line[2:4])
    regs[ip_reg] <- regs[ip_reg] + 1
  }
  
  big_num <- regs[dest_reg + 1]
  res <- (big_num + 1)
  x <- 2
  while (x < (big_num / 2)) {
    if ((big_num %% x) == 0) res <- res + x;
    x <- x + 1
  }
  res
}

data <- parse_input(readLines("../inputs/input_19.txt"))
c(advent19a(data), advent19b(data))
