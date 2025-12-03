parse <- function(lines) {
  # dep must be finished before let can start.
  deps <- substr(lines, 6, 6)
  lets <- substr(lines, 37, 37)
  steps <- rep(list(''), 26)
  done <- (!(LETTERS %in% c(lets, deps)))
  
  for (i in 1:26) {
    steps[[i]] <- deps[lets == LETTERS[i]]
  }
  list(steps, done)
}

advent7a <- function(steps, done) {
  res <- NULL
  while (any(!done)) {
    for (i in 1:26) {
      if ((length(steps[[i]]) == 0) && (!done[i])) {
        done[i] <- TRUE
        res <- c(res, LETTERS[i])
        for (j in 1:26)
          steps[[j]] <- steps[[j]][steps[[j]] != LETTERS[i]]
        break
      }
    }
  }
  paste(res, collapse="")
}

advent7b <- function(steps, done) {
  in_progress <- NULL
  finishes <- NULL
  busy_workers <- 0
  max_workers <- 5
  time <- 0
  while (TRUE) {
    
    # Load up workers
    
    if (any(!done)) {
      while (busy_workers < max_workers) {
        i <- 1
        while ((i <= 26) && ((length(steps[[i]]) != 0) || (done[i]))) i <- i + 1
        if (i>26) break
        done[i] <- TRUE
        in_progress <- c(in_progress, i)
        finishes <- c(finishes, 60 + i)
        busy_workers <- busy_workers + 1
      }
    }
    
    # Do some work
    
    elapsed <- min(finishes)
    finishes <- finishes - elapsed
    time <- time + elapsed
    index <- which(finishes == 0)[1]
    for (j in 1:26)
      steps[[j]] <- steps[[j]][steps[[j]] != LETTERS[in_progress[index]]]
    in_progress <- in_progress[-index]
    finishes <- finishes[-index]
    busy_workers <- busy_workers - 1

    if ((all(done)) && (busy_workers == 0)) break
  }
    
  time
}

data <- parse(readLines("../inputs/input_7.txt"))
c(advent7a(data[[1]], data[[2]]), advent7b(data[[1]], data[[2]]))

