advent9a <- function(stream, show_garbage = FALSE) {
  stream <- unlist(strsplit(stream,""))
  i <- 1
  current_group <- 0
  current_garbage <- FALSE
  score <- 0
  remove_garbage <- 0

  while (i <= length(stream)) {
    if (stream[i] == '!') { i <- i + 1
    } else if ((stream[i] == '<') && (!current_garbage)) {
      current_garbage <- TRUE
    } else if (stream[i] == '>') { current_garbage <- FALSE

    }  else if ((stream[i] == '{') && (!current_garbage)) {
      current_group <- current_group + 1
      score <- score + current_group

    } else if ((stream[i] == '}') && (!current_garbage)) {
      current_group <- current_group - 1

    } else if (current_garbage) {
      remove_garbage <- remove_garbage + 1
    }

    i <- i + 1
  }
  if (show_garbage) {
    result <- remove_garbage
  } else {
    result <- score
  }
  result
}

advent9b <- function(code) {
  advent9a(code, TRUE)
}

input <- readLines("../inputs/input_9.txt")
c(advent9a(input), advent9b(input))
