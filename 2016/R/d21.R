d <- strsplit(gsub(" through ", ",", gsub(" to position ", ",", gsub(" step", "", 
     gsub(" steps", "", gsub(" with position ", ",", gsub(" with letter ", ",",
     gsub("swap position ", "swap_pos,", gsub("swap letter ", "swap_let,",
     gsub("move position ", "move_pos,", gsub("rotate left ", "rot_left,,",
     gsub("rotate right ", "rot_right,,",
     gsub("rotate based on position of letter ", "rot_base,,",
     gsub("reverse positions ", "rev_pos,",
          readLines("../inputs/input_21.txt")))))))))))))), ",")

swap_pos <- function(x, arg1, arg2, rev) {
  a <- x[as.integer(arg1) + 1]
  x[as.integer(arg1) + 1] <- x[as.integer(arg2) + 1]
  x[as.integer(arg2) + 1] <- a
  x
}

swap_let <- function(x, arg1, arg2, rev) {
  swap_pos(x, which(x == arg1) - 1, which(x == arg2) - 1, rev)
}

rot_left_ <- function(x, arg1, arg2) {
  L <- length(x)
  n <- as.integer(arg2) %% L
  if (n == 0) {
    return(x)
  }
  x[c((n+1):L, 1:n)]
}

rot_right_ <- function(x, arg1, arg2) {
  L <- length(x)
  n <- as.integer(arg2) %% L
  if (n == 0) {
    return(x)
  }
  x[c(((L - n) + 1):L, 1:(L - n))]
}

rot_left <- function(x, arg1, arg2, rev) {
  if (!rev) rot_left_(x, arg1, arg2)
  else rot_right_(x, arg1, arg2)
}

rot_right <- function(x, arg1, arg2, rev) {
  rot_left(x, arg1, arg2, !rev)
}

rev_pos <- function(x, arg1, arg2, rev) {
  range <- (as.integer(arg1) + 1):(as.integer(arg2) + 1)
  x[range] <- rev(x[range])
  x
}

move_pos <- function(x, arg1, arg2, rev) {
  from <- ifelse(!rev, as.integer(arg1) + 1, as.integer(arg2) + 1)
  to <- ifelse(!rev, as.integer(arg2) + 1, as.integer(arg1) + 1)
  L <- x[from]
  x <- x[-from]
  if (to == 1) c(L,x)
  else if (to > length(x)) c(x, L)
  else c(x[1:(to - 1)], L, x[to:length(x)])
}

rot_base_ <- function(x, arg1, arg2) {
  i <- which(x == arg2)
  rot <- 1 + (i - 1) + ifelse(i - 1 >= 4, 1, 0)
  rot_right_(x, 0, rot)
}

rot_base <- function(x, arg1, arg2, rev) {
  if (!rev) return(rot_base_(x, arg1, arg2))
  opts <- lapply(seq_len(length(x)), function(y) rot_left_(x, 0, y))
  res <- lapply(opts, function(y) rot_base_(y, arg1, arg2))
  opts[unlist(lapply(res, identical, x))][[1]]
}

scramble <- function(x, rev = FALSE) {
  x <- strsplit(x, "")[[1]]
  lines <- seq_len(length(d))
  if (rev) lines <- rev(lines)
  for (i in lines) {
    x <- do.call(d[[i]][1], list(x, d[[i]][2], d[[i]][3], rev))
  }
  paste(x, collapse = "")
}

c(scramble("abcdefgh"), scramble("fbgdceah", TRUE))
