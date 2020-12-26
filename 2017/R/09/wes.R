test <- function(x, y) { if (x==y) "PASS" else "FAIL" }

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

input <- readLines("input.txt")
test(advent9a("{}"),1)
test(advent9a("{{{}}}"),6)
test(advent9a("{{},{}}"),5)
test(advent9a("{{{},{},{{}}}}"),16)
test(advent9a("{<a>,<a>,<a>,<a>}"),1)
test(advent9a("{{<ab>},{<ab>},{<ab>},{<ab>}}"),9)
test(advent9a("{{<!!>},{<!!>},{<!!>},{<!!>}}"),9)
test(advent9a("{{<a!>},{<a!>},{<a!>},{<ab>}}"),3)
advent9a(input)

test(advent9b("<>"),0)
test(advent9b("<random characters>"),17)
test(advent9b("<<<<>"),3)
test(advent9b("<{!>}>"),2)
test(advent9b("<!!>"),0)
test(advent9b("<!!!>>"),0)
test(advent9b("<{o\"i!a,<{i<a>"),10)
advent9b(input)
