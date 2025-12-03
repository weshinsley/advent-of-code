beval <- function(v1, comp, v2) {
  b <- NA
  v1 <- as.numeric(v1)
  v2 <- as.numeric(v2)
  if (comp == '>') { b <- (v1 > v2) }
  else if (comp == '>=') { b <- (v1 >= v2) }
  else if (comp == '<') { b <- (v1 < v2) }
  else if (comp == '<=') { b <- (v1 <= v2) }
  else if (comp == '==') { b <- (v1 == v2) }
  else if (comp == '!=') { b <- (v1 != v2) }
  b
}

neval <- function(v1, op, v2) {
  v <- NA
  v1 <- as.numeric(v1)
  v2 <- as.numeric(v2)
  if (op == 'inc') v <- (v1 + v2)
  else if (op == 'dec') v <- (v1 - v2)
  v
}

advent8a <- function(code, track_highest = FALSE) {
  regs <- NULL
  highest_ever <- 0
  for (line in code) {
    bits <- unlist(strsplit(line," "))
    val <- 0
    if (!(bits[1] %in% regs$name)) {
      regs <- rbind(regs,
        data.frame(name = bits[1], value = 0, stringsAsFactors = FALSE))
    }
    if (!(bits[5] %in% regs$name)) {
      regs <- rbind(regs,
        data.frame(name = bits[5], value = 0, stringsAsFactors = FALSE))
    }

    if (beval(regs$value[regs$name == bits[5]], bits[6], bits[7])) {
      regs$value[regs$name == bits[1]] <-
        neval(regs$value[regs$name == bits[1]], bits[2], bits[3])
      
      highest_ever <- max(highest_ever, regs$value[regs$name == bits[1]])
    }
  }
  highest <- max(regs$value)
  if (track_highest) {
    highest <- max(highest, highest_ever)
  }
  sprintf("Largest value: %d", max(highest))
}

advent8b <- function(code) {
  advent8a(code, track_highest = TRUE)
}

input <- readLines("../inputs/input_8.txt")
c(advent8a(input), advent8b(input))
