d <- readLines("../inputs/input_22.txt")
p1 <- which(d == "Player 1:")
p2 <- which(d == "Player 2:")
d1 <- as.integer(d[(p1 + 1):(p2 - 2)])
d2 <- as.integer(d[(p2 + 1):length(d)])

straighten <- function(d, h) {
  if (h != 1) {
    d <- c(d[h:length(d)], d[1:(h-1)])
  } 
  d[!is.na(d)]
}

game1 <- function(d1, d2) {
  n_cards <- length(c(d1, d2))
  head <- 1
  tails <- c(length(d1) + 1, length(d2) + 1)
  hands <- list(d1, d2)
  hands[[1]] <- c(hands[[1]], rep(NA, n_cards - length(hands[[1]])))
  hands[[2]] <- c(hands[[2]], rep(NA, n_cards - length(hands[[2]])))
  
  while (!is.na(hands[[1]][head]) & (!is.na(hands[[2]][head]))) {
    play <- c(hands[[1]][head], hands[[2]][head])
    hands[[1]][head] <- NA
    hands[[2]][head] <- NA
    head <- ifelse(head == n_cards, 1, head + 1)
    
    winner <- which(play == max(play))
    hands[[winner]][tails[winner]] <- play[winner]
    tails[winner] <- ifelse(tails[winner] == n_cards, 1, tails[winner] + 1)
    hands[[winner]][tails[winner]] <- play[3-winner]
    tails[winner] <- ifelse(tails[winner] == n_cards, 1, tails[winner] + 1)
  }
  
  sum(straighten(hands[[winner]], head) * (n_cards:1))
}

game2 <- function(d1, d2, depth = 1) {
  round <- 1
  n_cards <- length(c(d1, d2))
  head <- 1
  tails <- c(length(d1) + 1, length(d2) + 1)
  hands <- list(d1, d2)
  hands[[1]] <- c(hands[[1]], rep(NA, n_cards - length(hands[[1]])))
  hands[[2]] <- c(hands[[2]], rep(NA, n_cards - length(hands[[2]])))
  memory <- new.env()
  while (!is.na(hands[[1]][head]) & (!is.na(hands[[2]][head]))) {
    state <- paste0(c(
      "A", straighten(hands[[1]], head), 
      "B", straighten(hands[[2]], head)),
      collapse = "_")
    
    if (exists(state, envir = memory)) {
      return(1)
    }
    
    assign(state, 1, envir = memory)
    play <- c(hands[[1]][head], hands[[2]][head])
    hands[[1]][head] <- NA
    hands[[2]][head] <- NA
    head <- ifelse(head == n_cards, 1, head + 1)
    
    if ((sum(!is.na(hands[[1]])) >= play[1]) & 
        (sum(!is.na(hands[[2]])) >= play[2])) {
      winner <- game2(straighten(hands[[1]], head)[1:play[1]], 
                      straighten(hands[[2]], head)[1:play[2]], 
                      depth + 1)

    } else {
      winner <- which(play == max(play))
    }
    hands[[winner]][tails[winner]] <- play[winner]
    tails[winner] <- ifelse(tails[winner] == n_cards, 1, tails[winner] + 1)
    hands[[winner]][tails[winner]] <- play[3 - winner]
    tails[winner] <- ifelse(tails[winner] == n_cards, 1, tails[winner] + 1)
  }
  
  if (depth > 1) {
    return(winner)
  }
  sum(straighten(hands[[winner]], head) * (n_cards:1))
}

c(game1(d1,d2), game2(d1,d2))
