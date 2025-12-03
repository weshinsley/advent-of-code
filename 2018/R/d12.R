parse_input <- function(input) {
  state <- strsplit(substring(input[1], 16),"")[[1]] == '#'
  rules <- rep(FALSE, 32)
  for (i in 3:length(input)) {
    s <- unlist(strsplit(input[i], " => "))
    s2 <- strsplit(s[1], "")[[1]]
    s2 <- (s2 == '#')
    rules [1 + sum(s2*c(16, 8, 4, 2, 1))] <- s[2] == '#'
  }
  list(state, rules)
}

advent12a <- function(gens, state, rules) {
  i <- 0
  first_pot <- 0
  while (i < gens) {
    while (sum(state[1:4]>0)) { 
      state <- c(FALSE, state)
      first_pot <- first_pot - 1
    }
    while (sum(state[(length(state)-4):length(state)]>0)) state <- c(state, FALSE)
    next_state <- state
    for (j in seq_len(length(state)-5)) {
      next_state[j + 2] <- 
        rules[1 + (state[j]*16) + (state[j+1]*8) + 
        (state[j+2]*4) + (state[j+3]*2) + state[j+4]]
    }
    state <- next_state
    i <- i + 1
  }
  sum((first_pot:(length(state)+first_pot-1)) * state)
}
  
advent12b <- function(gens, state, rules) {
  arb <- 250
  if (gens < arb) advent12a(gens, state, rules)
  else {
    d1 <- advent12a(arb, state, rules)
    d2 <- advent12a(arb + 1, state, rules);
    d1 + ((d2 - d1) * (gens - arb));
  }
}

input <- parse_input(readLines("../inputs/input_12.txt"))
c(advent12a(20, input[[1]], input[[2]]),
  format(advent12b(50000000000, input[[1]], input[[2]]), scientific = FALSE))
