test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

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

code <- readLines("input.txt")
advent23a(code)
advent23b(code)

# The advent23b(code) will work... eventually... (915)
# but the puzzle here is actually to work out what
# the code in day23_in.txt does...

# reg a is the debug switch...

# First 9 lines:       => rewrite            => and some more as a = const 1

# 1 set b 57           c = b = 57
# 2 set c b
# 3 jnz a 2            if a!=0 goto 5
# 4 jnz 1 5            if a==0 goto 9
# 5 mul b 100          b = b * 100
# 6 sub b -100000      b = b + 100000             b = 105700
# 7 set c b            c = b
# 8 sub c -17000       c = c + 17000              c = 122700

# 9  set f 1           f = 1                      Outer Loop  is between b and c.
# 10 set d 2           d = 2                        step 17 - see lines 28-32
# 11 set e 2           e = 2                          *do (e=2 set here...
# 12 set g d                                           **do 
# 13 mul g e                                             .
# 14 sub g b           g = (d * e) - b                   .
# 15 jnz g 2                                             .
# 16 set f 0           if (g==0) f=0                   if ((d*e) == b), then f=0
# 17 sub e -1          e = e + 1                       e=e+1
# 18 set g e
# 19 sub g b           g = e - b
# 20 jnz g -8          if (g<>0) goto  12            **until e=b
# 21 sub d -1          d = d + 1                     d = d + 1
# 22 set g d
# 23 sub g b           g = d - b
# 24 jnz g -13         if (g<>0) goto 11             *until d=b goto 11 (which sets e=2)
# 25 jnz f 2           if (f==0) h = h + 1           if (d*e == b ) occurred earlier...
# 26 sub h -1                                               then h = h + 1
# 27 set g b
# 28 sub g c           g = b - c
# 29 jnz g 2
# 30 jnz 1 3           if (g==0) END                  if (b=c) stop
# 31 sub b -17         else b=b+17                    otherwise, b=b+17, end of loop
# 32 jnz 1 -23              goto 9                    go back to 9, reset f, d=2 and b=2

# So... for b=105700 to 122700 inclusive, step 17
#         for d=2 to b
#           for e=2 to b
#            if d*e == b, then h=h+1
#
# Or count the non-primes between 105700 and 122700 step 17
