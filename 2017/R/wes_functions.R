test <- function(x,y) { if (x==y) "PASS" else "FAIL" }

get_wrap <- function(lst, start, lgth) {
  while (start + lgth > length(lst)) {
    lst <- c(lst,lst)
  }
  lst[start:((start+lgth)-1)]
}

set_wrap <- function(lst, start, repl) {
  if (((start + length(repl)) - 1) <= length(lst)) {
    lst[start:(start+length(repl)-1)] <- repl
  } else {
    lst[start:length(lst)] <- repl[1:((length(lst)-start)+1)]
    repl <- repl[((length(lst)-start)+2):length(repl)]
    while (length(repl) > length(lst)) {
      lst[1:length(lst)] <- repl[1:length(lst)]
      repl <- repl[(length(lst)+1):length(repl)]
    }
    lst[1:length(repl)] <- repl
  }
  lst
}

advent10a_run <- function(knots, lengths, repeats = 1) {
  circle <- seq(0, knots - 1, 1)
  current_position <- 1
  skip_size <- 0
  for (r in seq_len(repeats)) {
    for (length in lengths) {
      section <- get_wrap(circle, current_position, length)
      circle <- set_wrap(circle, current_position, rev(section))
      current_position <- current_position + length + skip_size
      while (current_position > knots) {
        current_position <- current_position - knots
      }
      skip_size <- skip_size + 1
    }
}

  circle
}

advent10a <- function (knots, lengths) {
  circle <- advent10a_run(knots, lengths)
  circle[1] * circle[2]
}

xor16 <- function(lst, start) {
  x <- lst[start]
  for (i in 1:15) x <- bitwXor(x, lst[start+i])
  x
}

advent10b <- function (knots, string) {
  bytes <- c(utf8ToInt(string), c(17,31,73,47,23))
  circle <- advent10a_run(knots, bytes, repeats = 64)

  s <- ""
  for (i in seq(1,255,16)) {
    x <- xor16(circle,i)
    if (x<16) s <- paste0(s,"0")
    s <- paste0(s, as.hexmode(x))
  }
  s

}
