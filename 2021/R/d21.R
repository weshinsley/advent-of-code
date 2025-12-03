part1 <- function(p1, p2) {
  score <- c(0, 0)
  pos <- c(p1, p2)
  rolls <- 0
  dice <- 1
  
  while (TRUE) {
    for (player in c(1, 2)) {
      dv <- dice
      dice <- ifelse(dice == 100, 1, dice + 1)
      dv <- dv + dice
      dice <- ifelse(dice == 100, 1, dice + 1)
      dv <- dv + dice
      dice <- ifelse(dice == 100, 1, dice + 1)
      rolls <- rolls + 3
  
      pos[player] <- pos[player] + dv
      while (pos[player] > 10) pos[player] <- pos[player] - 10
      score[player] <- score[player] + pos[player] 
      if (score[player] >= 1000) {
        return(score[3 - player] * rolls)
      }
    }
  }
}

# 3 dice - how many times can you make each total:-

combs <- c(0,0,1,3,6,7,6,3,1)

# Global counters... yuk
options(digits = 15)
p1wins <- 0
p2wins <- 0

game <- function(p1, p2, s1, s2, rolls, player) {
  # Max q length turns out to be 343
  queue <- c(p1, p2, s1, s2, rolls, player, rep(NA, 500))
  tail <- 7
  while (tail > 1) {
    tail <- tail - 6
    p1 <- queue[tail]
    p2 <- queue[tail + 1]
    s1 <- queue[tail + 2]
    s2 <- queue[tail + 3]
    rolls <- queue[tail + 4]
    player <- queue[tail + 5]
    if (player == 1) {
      for (dice in 3:9) {
        next_p1 <- p1 + dice
        while (next_p1 > 10) next_p1 <- next_p1 - 10
        next_s1 <- s1 + next_p1
        if (next_s1 >= 21) {
          p1wins <<- p1wins + (rolls * combs[dice])   # How many times we got to this point
        } else {
          queue[tail] <- next_p1
          queue[tail+1] <- p2
          queue[tail+2] <- next_s1
          queue[tail+3] <- s2
          queue[tail+4] <- rolls * combs[dice]
          queue[tail+5] <- 2
          tail <- tail + 6
        }
      }
    } else {
      for (dice in 3:9) {
        next_p2 <- p2 + dice
        while (next_p2 > 10) next_p2 <- next_p2 - 10
        next_s2 <- s2 + next_p2
        if (next_s2 >= 21) {
          p2wins <<- p2wins + (rolls * combs[dice])   # How many times we got to this point
        } else {
          queue[tail] <- p1
          queue[tail+1] <- next_p2
          queue[tail+2] <- s1
          queue[tail+3] <- next_s2
          queue[tail+4] <- rolls * combs[dice]
          queue[tail+5] <- 1
          tail <- tail + 6
        }
      }
    }
  }
}

part2 <- function(p1, p2) {
  p1wins <<- 0
  p2wins <<- 0
  game(p1, p2, 0, 0, 1, 1)
  sort(c(p1wins, p2wins))
}

d <- as.integer(gsub("Player . starting position: ", "",readLines("../inputs/input_21.txt")))
c(part1(d[1], d[2]), max(part2(d[1], d[2])))
