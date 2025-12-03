ROCKY <- 0
WET <- 1
NARROW <- 2
NEITHER <- ROCKY
TORCH <- WET
CLIMB <- NARROW
SPLATTER <- 100

parse_input <- function(input) {
  list(as.integer(strsplit(input[1]," ")[[1]][2]), 
       as.integer(strsplit(strsplit(input[2], " ")[[1]][2], ",")[[1]]))
}


advent22a <- function(depth, tx, ty) {
  
  GI <- matrix(ncol = tx + SPLATTER, nrow = ty + SPLATTER, data = -1)
  EL <- GI
  GI[1, 1] <- 0
  EL[1, 1] <- depth %% 20183
  GI[1, 2:ncol(GI)] <- 16807 * seq(1:(ncol(GI)-1))
  EL[1, 2:ncol(EL)] <- (depth + (16807 * seq(1:(ncol(GI)-1)))) %% 20183
  GI[2:nrow(GI), 1] <- 48271 * seq(1:(nrow(GI)-1))
  EL[2:nrow(GI), 1] <- (depth + (48271 * seq(1:(nrow(GI)-1)))) %% 20183
  
  for (j in 2:nrow(GI)) {
    for (i in 2:ncol(GI)) {
      GI[j, i] <- EL[j, i - 1] * EL[j - 1, i]
      EL[j, i] <- (depth + GI[j, i]) %% 20183
    }
  }
  
  map <- EL %% 3
  GI[ty + 1, tx + 1] <- 0
  EL[ty + 1, tx + 1] <- (depth %% 20183)
  map[ty + 1, tx + 1] <- EL[ty + 1, tx + 1] %% 3
  list(res = sum(map[1:(ty + 1), 1:(tx+ 1 )]), map = map)
}

advent22b <- function(map, best_time, xrange, yrange, tx, ty) {
  dx <- c(0, 1, 0, -1)
  dy <- c(1, 0, -1, 0)
  stack <- rep(list(c(0,0,0,0)), 10000)
  
  
  best <- list(map, map, map)
  best[[1]][seq_len(nrow(map)), seq_len(ncol(map))] <- Inf
  best[[2]][seq_len(nrow(map)), seq_len(ncol(map))] <- Inf
  best[[3]][seq_len(nrow(map)), seq_len(ncol(map))] <- Inf
  
  # X, Y, Wearing, Distance
  sp <- 1
  stack[[sp]][1] <- 1
  stack[[sp]][2] <- 1
  stack[[sp]][3] <- TORCH
  stack[[sp]][4] <- 0

  while (sp > 0) {
    p_x <- stack[[sp]][1]
    p_y <- stack[[sp]][2]
    p_tool <- stack[[sp]][3]
    p_time <- stack[[sp]][4]
    sp <- sp - 1

    if (p_time > best[[p_tool + 1]][p_y, p_x]) next
    
    best[[p_tool + 1]][p_y, p_x] <- p_time
    
    if ((p_y == ty + 1) && (p_x == tx + 1) && (p_tool == TORCH) && (p_time < best_time)) {
      best_time <- p_time
      next
    }
      
    if (p_time >= best_time) next
      
    for (i in c(ROCKY, WET, NARROW)) {
      if ((map[p_y, p_x] != i) && (p_tool != i)) {
        if (best[[i + 1]][p_y, p_x] > p_time + 7) {
          sp <- sp + 1
          stack[[sp]][1] <- p_x
          stack[[sp]][2] <- p_y
          stack[[sp]][3] <- i
          stack[[sp]][4] <- p_time + 7
        }
      }
    }
    
    for (i in 1:4) {
      x2 <- p_x + dx[i]
      y2 <- p_y + dy[i]
      if ((x2 > 0) && (y2 > 0) && (x2 <= xrange) && (y2 <= yrange)) {
        if (map[y2, x2] != p_tool) {
          if (best[[p_tool + 1]][y2, x2] > p_time + 1)  {
            sp <- sp + 1
            stack[[sp]][1] <- x2
            stack[[sp]][2] <- y2
            stack[[sp]][3] <- p_tool
            stack[[sp]][4] <- p_time + 1
          }
        }
      }
    }
  }
  best_time
}

input <- parse_input(readLines("../inputs/input_22.txt"))
res <- advent22a(input[[1]], input[[2]][1], input[[2]][2])
estimate <- advent22b(res$map, Inf, input[[2]][1]+2, input[[2]][2]+2, input[[2]][1], input[[2]][2])
message(sprintf("Esimate = %d", estimate))
c(res$res, advent22b(res$map, estimate, input[[2]][1]+SPLATTER, input[[2]][2]+SPLATTER, input[[2]][1], input[[2]][2]))
