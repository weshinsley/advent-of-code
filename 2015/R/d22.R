solve <- function(part2 = FALSE) {
  boss <- read.csv("../inputs/input_22.txt", sep=":", header = FALSE)
  boss <- data.frame(hp = boss$V2[boss$V1 == "Hit Points"], 
                     dmg = boss$V2[boss$V1 == "Damage"])
  best <- 9999
  
  cost <- c(53, 73, 113, 173, 229)
  duration <- c(0, 0, 6, 6, 5)
  damage <- c(4, 2, 0, 3, 0)
  armour <- c(0, 0, 7, 0, 0)
  heal <- c(0, 2, 0, 0, 0)
  mana <- c(0, 0, 0, 0, 101)
  
  # Mana, spent, hp, boss hp, shield_left, poison_left, recharge_left
  
  MANA <- 1
  SPENT <- 2
  HP <- 3
  BOSSHP <- 4
  SHIELD <- 5
  POISON <- 6
  RECHARGE <- 7
  
  state <- c(500, 0, 50, boss$hp, 0, 0, 0) 
  max_queue <- 10000
  Q <- rep(list(state), max_queue)
  head <- 1
  next_free <- 2
  tot <- 1
  
  while (tot > 0) {
    tot <- tot - 1
    
    if (part2) {
      Q[[head]][HP] <- Q[[head]][HP] - 1
      if (Q[[head]][HP] <= 0) {
        head <- ifelse(head == max_queue, 1, head + 1)
        next
      }
    }
    
    for (i in 3:5) {
      if (Q[[head]][i+2] > 0) {
        Q[[head]][i+2] <- Q[[head]][i+2] - 1
        Q[[head]][BOSSHP] <- Q[[head]][BOSSHP] - damage[i]
        Q[[head]][MANA] <- Q[[head]][MANA] + mana[i]
      }
    }
    
    if (Q[[head]][BOSSHP] <= 0) {
      best <- min(best, Q[[head]][SPENT])
      head <- ifelse(head == max_queue, 1, head + 1)
      next
    }
    
    for (i in 1:5) {
      if (Q[[head]][MANA] >= cost[i]) {
        if ((i<3) || ((i>=3) && (Q[[head]][i+2] == 0))) {
          Q[[next_free]][SPENT] <- Q[[head]][SPENT] + cost[i]
          if (Q[[next_free]][SPENT] >= best) {
            next
          }
          Q[[next_free]][MANA] <- Q[[head]][MANA] - cost[i]
          Q[[next_free]][HP] <- ifelse(i < 3, Q[[head]][HP] + heal[i], Q[[head]][HP])
          Q[[next_free]][BOSSHP] <- ifelse(i < 3, Q[[head]][BOSSHP] - damage[i], Q[[head]][BOSSHP])
          Q[[next_free]][SHIELD] <- ifelse(i == 3, duration[i], Q[[head]][SHIELD])
          Q[[next_free]][POISON] <- ifelse(i == 4, duration[i], Q[[head]][POISON])
          Q[[next_free]][RECHARGE] <- ifelse(i == 5, duration[i], Q[[head]][RECHARGE])
          
          # Boss turn
          
          for (j in 3:5) {
            if (Q[[next_free]][j+2] > 0) {
              Q[[next_free]][j+2] <- Q[[next_free]][j+2] - 1
              Q[[next_free]][BOSSHP] <- Q[[next_free]][BOSSHP] - damage[j]
              Q[[next_free]][MANA] <- Q[[next_free]][MANA] + mana[j]
            }
          }
          
          if (Q[[next_free]][BOSSHP] <= 0) {
            best <- min(best, Q[[next_free]][SPENT])
            next
          }
          
          Q[[next_free]][HP] <- (Q[[next_free]][HP] - 
            max(1, boss$dmg - ifelse(Q[[next_free]][SHIELD] > 0, armour[3], 0)))
          
          if (Q[[next_free]][HP] <= 0) {
            next
          }
          
          next_free <- ifelse(next_free == max_queue, 1, next_free + 1)
          tot <- tot + 1
        }
      }
    }
    head <- ifelse(head == max_queue, 1, head + 1)
  }
  best
}

c(solve(), solve(TRUE))
