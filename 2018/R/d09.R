play <- function(n_players, n_marbles) {

  marbles <- rep(NULL, n_marbles)
  next_marble <- rep(NULL, n_marbles)
  previous_marble <- rep(NULL, n_marbles)

  scores <- rep(0, n_players)
  max_score <- 0

  # Add the first two marbles (special case)

  marbles[1] <- 0
  marbles[2] <- 1
  next_marble[1] <- 2
  next_marble[2] <- 1
  previous_marble[1] <- 2
  previous_marble[2] <- 1
  count_marbles <- 2
  current <- 2
  m <- 2
  current_player <- 1

  while (m <= n_marbles) {
    if ((m %% 23) == 0) {
      for (i in 1:7) current <- previous_marble[current]

      scores[current_player] <- scores[current_player] + marbles[current] + m
      next_marble[previous_marble[current]] <- next_marble[current]
      previous_marble[next_marble[current]] <- previous_marble[current]
      deleted <- current
      current <- next_marble[current]

      # Move last marble in raw list to the freed up spot.

      marbles[deleted] <- marbles[count_marbles]
      previous_marble[next_marble[count_marbles]] <- deleted
      next_marble[previous_marble[count_marbles]] <- deleted
      next_marble[deleted] <- next_marble[count_marbles]
      previous_marble[deleted] <- previous_marble[count_marbles]
      count_marbles <- count_marbles - 1

    } else {

      current <- next_marble[current]
      count_marbles <- count_marbles + 1
      marbles[count_marbles] <- m
      previous_marble[count_marbles] <- current
      next_marble[count_marbles] <- next_marble[current]
      previous_marble[next_marble[current]] <- count_marbles
      next_marble[current] <- count_marbles
      current <- count_marbles

    }
    current_player <- (current_player %% n_players) + 1
    m <- m + 1
  }
  max(scores)
}

input <- readLines("../inputs/input_9.txt")
n_players <- as.integer(substring(input, 0, 3))
n_marbles <- as.integer(substring(input, 35, 39))
c(play(n_players, n_marbles), play(n_players, n_marbles * 100))
