p0 <- function(x) paste0(x, collapse = "")

ss <- function(x) {
  x <- strsplit(x, "")[[1]]
  repeat {
    nums <- !x %in% c("[", "]", ",")
    reps <- which(diff(nums) == 0)
    reps <- reps[nums[reps]][1]
    if (is.na(reps[1])) break
    x[reps] <- p0(c(x[reps], x[reps + 1]))
    x <- x[-(reps + 1)]
  }
  x
}

read <- function(x) {
  lapply(readLines(x), ss)
}


explode <- function(x, test_single = FALSE) {
  leaf_depth <- x
  leaf_depth[leaf_depth %in% c(",", 0:9)] <- 0
  leaf_depth[leaf_depth == "["] <- 1
  leaf_depth[leaf_depth == "]"] <- -1
  leaf_depth <- cumsum(as.integer(leaf_depth))
  while (any(leaf_depth == 5)) {
    nums <- which(!x %in% c("[", "]", ","))
    start <- which(leaf_depth == 5)[[1]]
    left <- as.integer(x[start + 1])
    right <- as.integer(x[start + 3])
    next_right <- nums[nums > start + 3]
    prev_left <- nums[nums < start + 1]
    if (length(next_right) > 0) {
      next_right <- min(next_right)
      x[next_right] <- as.integer(x[start + 3]) + as.integer(x[next_right])
    }
    if (length(prev_left) > 0) {
      prev_left <- max(prev_left)
      x[prev_left] <- as.integer(x[start + 1]) + as.integer(x[prev_left])
    }
    
    x[start] <- "0"
    x <- x[-c((start + 1):(start+4))]
    leaf_depth[start] <- leaf_depth[start] - 1
    leaf_depth <- leaf_depth[-c((start + 1):(start+4))]
    if (test_single) break
  }
  x
}

split <- function(x) {
  nums <- which(!x %in% c("[", "]", ","))
  big <- nums[as.integer(x[nums]) >= 10]
  
  if (length(big) == 0) return(x)
  big <- min(big)
  v <- as.integer(x[big])
  x <- c(x[(1:(big-1))], "[", v %/% 2, ",", (v - (v %/% 2)), "]", 
         x[(big+1):length(x)])
  x
}

add <- function(x, y) {
  c("[", x, ",", y, "]")
}

reduce <- function(x) {
  repeat {
    x2 <- explode(x)
    x2 <- split(x2)
    if (identical(x, x2)) break
    x <- x2
  }
  x2
}

assemble <- function(x) {
  res <- reduce(x[[1]])
  for (i in 2:length(x)) {
    res <- reduce(add(res, x[[i]]))
  }
  res
}

magnitude <- function(x) {
  res <- 0
  x <- x[2:(length(x) - 1)]
  leaf_depth <- x
  leaf_depth[leaf_depth %in% c(",", 0:9)] <- 0
  leaf_depth[leaf_depth == "["] <- 1
  leaf_depth[leaf_depth == "]"] <- -1
  leaf_depth <- cumsum(as.integer(leaf_depth))
  comma <- which(x == "," & leaf_depth == 0)
  left <- x[1:(comma - 1)]
  right <- x[(comma + 1):length(x)]
  res <- res + 3 * (if ("," %in% left) magnitude(left) else as.integer(left))
  res <- res + 2 * (if ("," %in% right) magnitude(right) else as.integer(right))
  res
}

part1 <- function(d) { 
  magnitude(assemble(d)) 
}

part2 <- function(d) {
  max(unlist(lapply(seq_len(length(d)), function(x)
    lapply(seq_len(length(d)), function(y)
      if (x==y) 0 else magnitude(assemble(list(d[[x]], d[[y]])))))))
}

###############################################

d <- lapply(readLines("../inputs/input_18.txt"), ss)
c(part1(d), part2(d))
