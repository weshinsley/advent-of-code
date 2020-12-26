test <- function(x, y) { if (x==y) "PASS" else "FAIL" }

make_tree <- function(data) {
  df <- data.frame(stringsAsFactors = FALSE)
  for (line in data) {
    bits <- unlist(strsplit(gsub("\\(|\\)|,|-|>","",line), split="\\s+"))
    if (length(bits)==2) {
      df <- rbind(df, data.frame(parents = bits[1],
                                 children = NA,
                                 weight = as.integer(bits[2]),
                                 stringsAsFactors = FALSE))
    } else {
      for (i in seq_len(length(bits)-2)) {
        df <- rbind(df, data.frame(parents = bits[1],
                                   weight = as.integer(bits[2]),
                                   children = bits[2+i], 
                                   stringsAsFactors = FALSE))
      }
    }
  }
  df
}

advent7a <- function(data) {
  df <- make_tree(data)
  parents <- unique(df$parents)
  children <- unique(df$children)
  matches <- match(parents, children)
  parents[which(is.na(matches))]
}

get_children <- function(df, p) {
  kids <- unique(df$children[df$parents==p])
  kids <- kids[!is.na(kids)]
}

get_weight <- function(df, p) {
  my_weight <- df$weight[df$parents==p][1]
  if (is.na(my_weight)) my_weight <- 0
  kids <- get_children(df,p)
  for (k in kids) {
    if (!is.na(k)) {
      my_weight <- my_weight + get_weight(df, k)
    }
  }
  my_weight
}

advent7b <- function(data) {
  msg <- ""
  df <- make_tree(data)
  the_parent <- advent7a(data)
  kids <- get_children(df, the_parent)
  continue <- 1

  while (continue == 1) { 
    weights <- unlist(lapply(kids, function(x) get_weight(df, x)))
    freqs <- unlist(lapply(weights, function(x) sum(x==weights)))
    new_kids <- get_children(df, kids[which(freqs == 1)])

    if (length(new_kids)>0) {
      new_weight <- weights[which(freqs!=1)][1]
      kids <- new_kids
    } else {
      new_weight <- new_weight - sum(weights)
      the_parent <- unique(df$parents[df$children==kids[1]])
      the_parent <- the_parent[!is.na(the_parent)]
      msg <- sprintf("%s needs to change weight to %d", the_parent, new_weight)
      continue <- 0
    }
  }
  msg
}

example <- readLines("example.txt")
data <- readLines("input.txt")

test(advent7a(example),"tknk")
advent7a(data)

test(advent7b(example), "ugml needs to change weight to 60")
advent7b(data)
