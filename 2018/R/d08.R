build_tree <- function() {
  node <- NULL
  no_children <- input[pointer]
  no_metadata <- input[pointer + 1]
  node$children = rep(list(0), no_children)
  node$metadata = rep(0, no_metadata)
  pointer <<- pointer + 2
  for (i in seq_len(no_children))
    node$children[[i]] <- build_tree()

  for (i in seq_len(no_metadata)) {
    node$metadata[[i]] <- input[pointer]
    pointer <<- pointer + 1
  }
  node
}

advent8a <- function(node) {
  tot <- sum(node$metadata)
  for (child in seq_len(length(node$children)))
    tot <- tot + advent8a(node$children[[child]])
  tot  
}

advent8b <- function(node) {
  tot <- 0
  n_children <- length(node$children)
  if (n_children == 0) tot <- sum(node$metadata)
  else
    for (m in node$metadata)
      if (m <= n_children) tot <- tot + advent8b(node$children[[m]])
  tot
}

input <- as.numeric(strsplit(readLines("../inputs/input_8.txt"),"\\s+")[[1]])
pointer <- 1
tree <- build_tree()
c(advent8a(tree), advent8b(tree))


