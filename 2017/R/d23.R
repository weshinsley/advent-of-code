numericable <- function(s) {
  (!is.na(suppressWarnings(as.numeric(s))))
}

get_val <- function(var, reg_values, reg_names) {
  x <- 0
  if (numericable(var)) {
    x <- as.numeric(var)
  } else {
    x <- reg_values[reg_names == var]
  }
  x
}

execute_maths <- function(reg_names, reg_values, line, line_no) {
  x <- get_val(line[2], reg_values, reg_names)
  y <- get_val(line[3], reg_values, reg_names)
  if (line[1] == 'set') {
    reg_values[reg_names == line[2]] <- y
  } else if (line[1] == 'sub') {
    reg_values[reg_names == line[2]] <- (x - y)
  } else if (line[1] == 'mul') {
    reg_values[reg_names == line[2]] <- (x * y)
  } else if ((line[1] == 'jnz') && ( x != 0)) {
    line_no <- (line_no + y) - 1
  }

  c(line_no, reg_values)
}

init_regs <- function(code) {
  reg_names <- NULL
  for (line in code) {
    line <- unlist(strsplit(line," "))

    if (!numericable(line[2])) {
      if (!(line[2] %in% reg_names)) {
        reg_names <- c(reg_names, line[2])
      }
    }
    if (!numericable(line[3])) {
      if (!(line[3] %in% reg_names)) {
        reg_names <- c(reg_names, line[3])
      }
    }
  }
  sort(reg_names)
}

advent23a <- function(code, part_b = FALSE) {
  reg_names <- init_regs(code)
  reg_values <- rep(0, length(reg_names))
  if (part_b) {
    reg_values[reg_names=='a'] <- 1
  }
  line_no <- 1
  mul_count <- 0

  while ((line_no>=1) && (line_no<=length(code))) {
    line <- unlist(strsplit(code[line_no]," "))
    if (!part_b) {
      if (line[1] == "mul") mul_count <- mul_count + 1
    }
    res <- execute_maths(reg_names, reg_values, line, line_no)
    line_no <- res[1]
    reg_values <- res[2:length(res)]
    line_no <- line_no + 1
  }
  res <- mul_count
  if (part_b) {
    res <- reg_values[reg_names=='h']
  }
  res
}

advent23b <- function(code) {
  advent23a(code, TRUE)
}

code <- readLines("../inputs/input_23.txt")
c(advent23a(code), advent23b(code))

# The advent23b(code) will work... eventually... (915)
# but the puzzle here is actually to work out what
# the code in day23_in.txt does. Analysing the 
# assembly code (redacted here as it's my puzzle input)
# gives something like this:-

#       for b=105700 to 122700 inclusive, step 17
#         for d=2 to b
#           for e=2 to b
#            if d*e == b, then h=h+1
#
# Or count the non-primes between 105700 and 122700 step 17
