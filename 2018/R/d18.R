OPEN <- 0
TREES <- 1
LUMBERYARD <- 2

dump <- function(m) {
  ch <- c('.','|','#')
  for (j in seq_len(nrow(m))) {
    for (i in seq_len(ncol(m))) {
      cat(ch[m[j, i] + 1])
    }
    cat("\n")
  }
  cat("\n")
}

parse_input <- function(input) {
  map <- matrix(nrow = length(input), ncol = nchar(input[1]), byrow = TRUE,
    data = as.integer(unlist(strsplit(
      gsub("[#]","2",gsub("[|]", "1", gsub("[.]","0", input))), ""))))
  
  nr <- nrow(map)
  nc <- ncol(map)
  
  lookup <- rep(list(NULL), nc*nr)
  
  for (x in seq_len(nc)) {
    for (y in seq_len(nr)) {
      cell <- y + ((x-1) * nr)
      for (xx in (x-1):(x+1)) {
        for (yy in (y-1):(y+1)) {
          if ((x!=xx) || (y!=yy)) {
            if ((xx>=1) && (xx<=nc) && (yy>=1) && (yy<=nr)) {
              lookup[[cell]] <- c(lookup[[cell]], (yy + (xx-1) * nr))
            }
          }
        }
      }
    }
  }
  list(map, lookup)
}

turn <- function(map, lookup) {
  nc <- ncol(map)
  nr <- nrow(map)
  new_map <- matrix(ncol = nc, nrow = nr, data = 0L)
  for (y in seq_len(nr)) {
    for (x in seq_len(nc)) {
      cell <- y + (x-1) * nc
      count_trees <- sum(map[lookup[[cell]]] == TREES)
      count_open <- sum(map[lookup[[cell]]] == OPEN)
      count_lumber <- sum(map[lookup[[cell]]] == LUMBERYARD)

      if (map[y, x] == OPEN) {
        new_map[y, x] <- (count_trees >= 3)
        
      } else if (map[y, x] == TREES) {
        if (count_lumber >= 3) new_map[y, x] <- LUMBERYARD
        else new_map[y, x] <- TREES
        
      } else {
        if ((count_lumber >=1) && (count_trees>=1)) new_map[y, x] <- LUMBERYARD
        else new_map[y, x] <- OPEN
      }
    }
  }
  new_map
}

advent18a <- function(map, lookup, turns) {
  while (turns>0) {
    map <- turn(map, lookup)
    turns <- turns - 1
  }
  sum(map == LUMBERYARD) * sum(map == TREES)
}

advent18b <- function(map, lookup, n, burn_in = 1000, max_len = 100) {
  if (n<burn_in) advent18a(n)
  else {
    for (i in seq_len(burn_in)) {
      map <- turn(map, lookup)
    }
    buf <- rep(0,max_len)
    for (i in seq_len(max_len)) {
      map <- turn(map, lookup)
      buf[i] <- sum(map == LUMBERYARD) * sum(map == TREES)
    }

    if (all(which(buf == buf[2]) == which(buf == buf[1])+1) &&
        (all(which(buf == buf[3]) == which(buf == buf[2])+1))) {
          seq_length <- which(buf == buf[2])[2] - which(buf == buf[2])[1]
          
          return(buf[1 + ((n - burn_in - 1) %% seq_length)])
    }
  }
}

bits <- parse_input(readLines("../inputs/input_18.txt"))
c(advent18a(bits[[1]], bits[[2]], 10), 
  advent18b(bits[[1]], bits[[2]], 1000000000, 600, 100))
  