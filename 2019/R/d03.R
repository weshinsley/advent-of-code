parse_input <- function(s) {
  bits <- unlist(strsplit(s, ","))
  df <- data.frame(stringsAsFactors = FALSE,
    dir = substring(bits, 1, 1),
    steps = as.integer(substring(bits, 2)),
    fromx = 0L,
    fromy = 0L,
    tox = 0L, 
    toy = 0L
  )
  for (i in seq_len(nrow(df))) {
    df$tox[i] <- df$fromx[i] + (df$steps[i] * ((as.integer(df$dir[i] == 'R') - as.integer(df$dir[i] == 'L'))))
    df$toy[i] <- df$fromy[i] + (df$steps[i] * ((as.integer(df$dir[i] == 'D') - as.integer(df$dir[i] == 'U'))))
    if (i < nrow(df)) {
      df$fromx[i + 1] <- df$tox[i]
      df$fromy[i + 1] <- df$toy[i]
    }
  }
  df$cum_steps = as.integer(c(0, cumsum(df$steps)[1:nrow(df)-1]))
  df$horiz = (df$dir %in% c("L", "R"))
  
  df
}

intersects <- function(w1, w2) {
  if (w1$horiz & w2$horiz) {
    if (w1$fromy == w2$fromy) {
      return(data.frame(y = w1$fromy, x = intersect(w1$fromx:w1$tox, w2$fromx:w2$tox)))
    } else {
      return(NULL)
    }
  } 
  
  if (!w1$horiz & !w2$horiz) {
    if (w1$fromx == w2$fromx) {
      return(data.frame(x = w1$fromx, y = intersect(w1$fromy:w1$toy, w2:fromy:w2$toy)))
    } else {
      return(NULL)
    }
  }
  
  min1x <- min(w1$fromx, w1$tox)
  min2y <- min(w2$fromy, w2$toy)
  max1x <- max(w1$fromx, w1$tox)
  max2y <- max(w2$fromy, w2$toy)
  
  if ((w1$horiz) & (min1x <= w2$fromx) & (max1x >= w1$fromx) &&
                   (min2y <= w1$fromy) & (max2y >= w1$fromy)) { 
    return(data.frame(y = w1$fromy, x = w2$fromx))
  }
  
  min2x <- min(w2$fromx, w2$tox)
  min1y <- min(w1$fromy, w1$toy)
  max2x <- max(w2$fromx, w2$tox)
  max1y <- max(w1$fromy, w1$toy)
  
  if ((!w1$horiz) & (min2x <= w1$fromx) & (max2x >= w1$fromx) &&
                     (min1y <= w2$fromy) & (max1y >= w2$fromy)) { 
    return(data.frame(y = w2$fromy, x = w1$fromx))
  }
  NULL
}

solve1 <- function(wire1, wire2) {
  min_dist <- 1E10
  for (w1 in seq_len(nrow(wire1))) {
    for (w2 in seq_len(nrow(wire2))) {
      if ((w1>1) & (w2>1)) {
        inters <- intersects(wire1[w1, ], wire2[w2, ])
        if (!is.null(inters)) {
          dist <- abs(inters$x) + abs(inters$y)
          min_dist <- min(min_dist, dist)
        }
      }
    }
  }
  min_dist
}

solve2 <- function(wire1, wire2) {
  min_steps <- 1E10
  for (w1 in seq_len(nrow(wire1))) {
    for (w2 in seq_len(nrow(wire2))) {
      if ((w1>1) & (w2>1)) {
        inters <- intersects(wire1[w1, ], wire2[w2, ])
        if (!is.null(inters)) {
          dist <- wire1$cum_steps[w1] + wire2$cum_steps[w2]
          if (wire1$horiz[w1]) dist <- dist + abs(inters$x - wire1$fromx[w1])
          else dist <- dist + abs(inters$y - wire1$fromy[w1])
          
          if (wire2$horiz[w2]) dist <- dist + abs(inters$x - wire2$fromx[w2])
          else dist <- dist + abs(inters$y - wire2$fromy[w2])
          
          
          min_steps <- min(min_steps, dist)
        }
      }
    }
  }
  min_steps
}

input <- readLines("../inputs/input_3.txt")
wire1 <- parse_input(input[1])
wire2 <- parse_input(input[2])
c(solve1(wire1, wire2),
  solve2(wire1, wire2))
