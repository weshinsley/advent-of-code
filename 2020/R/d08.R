load <- function(f) {
  d <- strsplit(readLines(f), " ")
  data.frame(stringsAsFactors = FALSE,
    cmd = unlist(lapply(d, "[", 1)),
    arg = as.integer(unlist(lapply(d, "[", 2))),
    visit = FALSE)
}

compute <- function(x, acc, line) {
  list(
    line = ifelse(x$cmd != 'jmp', line + 1, line + x$arg),
    acc = ifelse(x$cmd == 'acc', acc + x$arg, acc)
  )
}

solve <- function(p) {
  acc <- 0
  line <- 1
  while (TRUE) {
    if (line > nrow(p)) {
      return(list(acc, TRUE))
    } else if (p$visit[line]) {
      return(list(acc, FALSE))
    } else {
      p$visit[line] <- TRUE
      res <- compute(p[line, ], acc, line)
      acc <- res$acc
      line <- res$line
    }
  }
}

solve2 <- function(p) {
  changes <- which(p$cmd != 'acc')
  for (i in changes) {
    p$cmd[i] <- ifelse(p$cmd[i] == 'jmp', 'nop', 'jmp')
    res <- solve(p)
    if (res[[2]]) {
      return(res)
    }
    p$cmd[i] <- ifelse(p$cmd[i] == 'jmp', 'nop', 'jmp')
  }
}

c(solve(load("../inputs/input_8.txt"))[[1]],
  solve2(load("../inputs/input_8.txt"))[[1]])
