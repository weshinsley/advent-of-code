advent16a <- function(script, n_dancers, dancers = NULL) {
  if (is.null(dancers)) {
    dancers <- letters[seq_len(n_dancers)]
  } else {
    dancers <- unlist(strsplit(dancers,""))
  }
  index <- 1
  for (move in script) {
    move <- unlist(strsplit(move, ""))
    
    if (move[1] == 's') {
      x <- as.numeric(paste(move[2:length(move)], collapse=""))
      for (i in seq_len(x)) {
        dancers <- c(dancers[n_dancers], dancers[1:(n_dancers-1)])
      }
      
    } else if (move[1] == 'x') {
    
      swaps <- 1 + as.numeric(unlist(
        strsplit(paste0(move[2:length(move)],collapse = ""),"/")))
      d <- dancers[swaps[1]]
      dancers[swaps[1]] <- dancers[swaps[2]]
      dancers[swaps[2]] <- d
       
    } else if (move[1] == 'p') {
      d1 <- which(dancers == move[2])
      d2 <- which(dancers == move[4])
      dancers[d1] <- move[4]
      dancers[d2] <- move[2]
      
    }
  }
  paste0(dancers, collapse="")
}

advent16b <- function (script, n_dancers, n) {
  step_zero <- paste(letters[seq_len(n_dancers)], collapse="")
  next_step <- advent16a(script, n_dancers, step_zero)
  steps <- 1
  while (step_zero != next_step) {
    next_step <- advent16a(script, n_dancers, next_step)
    steps <- steps + 1
  }
  steps <- n %% steps
  for (i in seq_len(steps)) {
    next_step <- advent16a(script, n_dancers, next_step)
  }
  next_step
  
}

script <- unlist(strsplit(readLines("../inputs/input_16.txt"), ","))
c(advent16a(script, 16), advent16b(script, 16, 1000000000))
