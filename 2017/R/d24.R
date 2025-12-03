remove_from <- function(lists, lis) {
  z <- length(lists)
  for (i in seq_len(length(lists))) {
    if (sum(lists[[i]] == lis) == length(lis)) {
      lists[[i]]<-NULL
      break
    }
  }
  lists
}

get_potentials <- function(pins, parts) {
  pots <- list()
  for (part in parts) {
    if (pins %in% part) {
      pots <- c(pots, list(part))
    }
  }
  pots
}

explore_options <- function(last_dig, parts2, strength, max_strength, best_length) {
  if (best_length) {
    strength <- strength + 100000
  }
  potentials <- get_potentials(last_dig, parts2)
  for (p2 in seq_len(length(potentials))) {
    pot <- potentials[[p2]]
    left_overs <- remove_from(parts2, pot)
    link <- pot[1]
    if (link == last_dig) link <- pot[2]
    max_strength <- max(max_strength, strength + sum(pot))
    max_strength <- explore_options(link, left_overs, strength + sum(pot),
                                    max_strength, best_length)
  }
  max_strength
}

advent24a <- function(parts, best_length = FALSE) {
  parts <- lapply(parts, function (x) as.numeric(unlist(strsplit(x,"/"))))
  best_strength <- 0
  for (p in seq_len(length(parts))) {
    part <- parts[[p]]
    if (0 %in% part) {
      left_overs <- remove_from(parts,part)
      link <- part[1]
      if (link==0) link <- part[2]
      strength <- explore_options(link, left_overs, sum(part), sum(part), best_length)
      best_strength <- max(strength, best_strength)
    }
  }
  best_strength
}

advent24b <- function(parts) {
  res <- advent24a(parts, TRUE)
  message(sprintf("Length: %d, Strength: %d",floor(res/100000), res %% 100000))
}

input <- readLines("../inputs/input_24.txt")
c(advent24a(input), advent24b(input))
