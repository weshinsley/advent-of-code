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

parseInput <- function(lines) {
  before <- lapply(strsplit((gsub("[^0-9,]","",lines[substring(lines,1, 9)=="Before: ["])), ","), as.numeric)
  after <- lapply(strsplit((gsub("[^0-9,]","",lines[substring(lines,1, 9)=="After:  ["])), ","), as.numeric)
  codes <- lapply(strsplit(lines[(nchar(lines)>0) & (nchar(lines)<15)], " "), as.numeric)
  program <- codes[(length(before)+1):length(codes)]
  codes <- codes[seq_len(length(before))]
  list(before, after, codes, program)
}


advent16a <- function(before, after, codes) {
  samples <- 0
  for (r in seq_len(length(before))) {
    samples <- samples + (sum(unlist(lapply(0:15, 
      function(x) { identical(exec(before[[r]], x, codes[[r]][2:4]), after[[r]]) }))) >= 3)
  }
  samples
}

advent16b <- function(before, after, codes, program) {
  code_translate <- rep(-1, 16)
  options <- rep(list(seq(0,15)), 16)
  unknown <- 16
  
  while (unknown > 0) {
    for (code in 0:15) {
      if (length(options[[code + 1]]) >= 1) {
        for (j in seq_len(length(before))) {
          if (codes[[j]][1] == code) {
            op <- 1
            while (op <= length(options[[code + 1]])) {
              opcode <- options[[code + 1]][op]
              if (!identical(after[[j]], exec(before[[j]], opcode, codes[[j]][2:4]))) {
                options[[code + 1]] <- options[[code + 1]][options[[code + 1]]!=opcode]
              } else {
                op <- op + 1
              }
            }
            if (length(options[[code + 1]]) == 1) {
              opcode <- options[[code + 1]][1]
              code_translate[code + 1] <- opcode
              for (k in 0:15) {
                if ((code != k) && (length(options[[k + 1]] == opcode) > 0)) {
                  options[[k + 1]] <- options[[k + 1]][options[[k + 1]] != opcode]
                }
              }
              unknown <- unknown - 1
              options[[code + 1]] <- list()
            }
            break
          }
        }
      }
    }
  }
  
  regs <- c(0,0,0,0)
  for (line in program) regs <- exec(regs, code_translate[line[1] + 1], line[2:4]);
  regs[1]
}

vars <- parseInput(readLines("../inputs/input_16.txt"))
c(advent16a(vars[[1]], vars[[2]], vars[[3]]),
  advent16b(vars[[1]], vars[[2]], vars[[3]], vars[[4]]))
