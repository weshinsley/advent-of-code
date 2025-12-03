advent14a <- function(input) {
  recipes <- c(3L, 7L, rep(0L, length(input + 10L)))
  used <- 2L
  elf_pos1 <- 0L
  elf_pos2 <- 1L
  r <- 0L
  iters <- 10L + as.integer(input)

  while (r < iters) {
    elf1 <- recipes[elf_pos1 + 1L]
    elf2 <- recipes[elf_pos2 + 1L]
    combine <- elf1 + elf2

    if (combine >= 10L) {
      used <- used + 1L
      recipes[used] <- 1L
      combine <- combine - 10L
    }
    used <- used + 1L
    recipes[used] <- combine

    elf_pos1 <- (elf_pos1 + 1L + elf1) %% used
    elf_pos2 <- (elf_pos2 + 1L + elf2) %% used
    r <- r + 1L
  }
  paste(recipes[(input+1L):(input+10L)], collapse="")
}

advent14b <- function(input) {
  block_size <- 1000000L
  recipes <- c(3L, 7L, rep(0L, block_size - 2L))
  capacity <- block_size
  used <- 2L

  input_len <- nchar(input)
  input_len_m1 <- input_len - 1L
  overflow = as.integer(10 ^ (input_len))
  input_int = as.integer(input)
  compare <- 37L

  elf_pos1 <- 0L
  elf_pos2 <- 1L
  pre <- 2L

  while (pre < input_len) {
    elf1 <- recipes[elf_pos1 + 1L]
    elf2 <- recipes[elf_pos2 + 1L]
    combine <- elf1 + elf2
    if (combine >= 10L) {
      used <- used + 1L
      recipes[used] <- 1L
      combine <- combine - 10L
      pre <- pre + 1L

      compare <- compare * 10L + 1L
      if (used > input_len) compare <- compare - (recipes[used - input_len] * overflow)
      if (used > input_len_m1) 
        if (compare == input_int) return(used - input_len_m1)
    }

    used <- used + 1L
    recipes[used] <- combine
    pre <- pre + 1L
    compare <- compare * 10L + combine
    if (used > input_len) compare <- compare - (recipes[used - input_len] * overflow)
    if (used > input_len_m1)
      if (compare == input_int) return(used - input_len_m1)

    elf_pos1 <- (elf_pos1 + 1L + elf1) %% used
    elf_pos2 <- (elf_pos2 + 1L + elf2) %% used
  }

  while (TRUE) {
    elf1 <- recipes[elf_pos1 + 1L]
    elf2 <- recipes[elf_pos2 + 1L]
    combine <- elf1 + elf2

    if (used >= capacity) {
      recipes <- c(recipes, rep(0, block_size))
      capacity <- capacity + block_size
      block_size <- block_size * 2
    }

    if (combine >= 10L) {
      used <- used + 1L
      recipes[used] <- 1L
      compare <- compare * 10L + 1L - (recipes[used - input_len] * overflow)
      if (compare == input_int) return (used - input_len)
      combine <- combine - 10L
    }
    used <- used + 1L
    recipes[used] <- combine
    compare <- compare * 10L + combine - (recipes[used - input_len] * overflow)
    if (compare == input_int) return (used - input_len)

    elf_pos1 <- (elf_pos1 + 1L + elf1) 
    if (elf_pos1 >= used) elf_pos1 <- elf_pos1 - used
    elf_pos2 <- (elf_pos2 + 1L + elf2)
    if (elf_pos2 >= used) elf_pos2 <- elf_pos2 - used
  }
}

input <- readLines("../inputs/input_14.txt")
c(advent14a(as.integer(input)), advent14b(input))
