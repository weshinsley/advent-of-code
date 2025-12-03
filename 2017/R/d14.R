source("wes_functions.R")

hex2bin <- function(s) {
  hex <- c("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")
  bin <- c("0000","0001","0010","0011","0100","0101","0110","0111",
           "1000","1001","1010","1011","1100","1101","1110","1111")
  r <-""
  for (ch in unlist(strsplit(s,""))) {
    r <- paste0(r, bin[which(ch == hex)])
  }
  r
}

advent14a <- function(input) {
  grid<-NULL
  for (r in 0:127) {
    circle <- advent10b(256, paste0(input,"-",r))
    grid <- c(grid, hex2bin(circle))
  }
  grid
}

flood_fill <- function(grid, i, j, group) {
  if ((i>=1) && (i<=128) && (j>=1) && (j<=128)) {
    if (grid[[j]][[i]] == '#') {
      grid[[j]][[i]] <- as.character(group)
      grid <- flood_fill(grid, i-1, j, group)
      grid <- flood_fill(grid, i+1, j, group)
      grid <- flood_fill(grid, i, j-1, group)
      grid <- flood_fill(grid, i, j+1, group)
    }
  }
  grid
}

advent14b <- function(grid) {
  grid <- unlist(lapply(grid, function(x) gsub("0", ".", x)))
  grid <- unlist(lapply(grid, function(x) gsub("1", "#", x)))
  grid <- lapply(grid, function(x) unlist(strsplit(x,"")))
  group <- 0
  for (j in seq_len(128)) {
    for (i in seq_len(length(grid[[j]]))) {
      if (grid[[j]][[i]] == '#') {
        group <- group + 1
        grid <- flood_fill(grid, i, j, group)
      }
    }
  }
  group
}

input <- readLines("../inputs/input_14.txt")

grid <- advent14a(input)

c(sum(unlist(lapply(grid, 
                  function(x) { sum(as.numeric(unlist(strsplit(x,"")))) }))),
advent14b(grid))
