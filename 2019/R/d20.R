analyse_maze <- function(maze, hei, wid) {
  
  # Because we're in R, we'll index from 1... top left is (1,1)
  # Outer perimeter is always (3,3) - (wid-2, hei-2).
  # Inner perimeter: start at middle and fan outwards.

  wmid <- floor(wid/2)
  lmid <- wmid
  rmid <- wmid
  tmid <- floor(hei/2)
  bmid <- floor(hei/2)
  while (!maze[[tmid]][lmid] %in% c('.', '#')) lmid <- lmid - 1
  while (!maze[[tmid]][rmid] %in% c('.', '#')) rmid <- rmid + 1
  while (!maze[[tmid]][wmid] %in% c('.', '#')) tmid <- tmid - 1
  while (!maze[[bmid]][wmid] %in% c('.', '#')) bmid <- bmid + 1
  
  # Inner perimeter is now (lmid, tmid) - (rmid, bmid)
  
  ports <- NULL
  
  # Find "vertical" portals, then "horizontal" portals.
  
  nport <- function(ports, ch1, ch2, i, j) {
    if (ch1 %in% LETTERS) {
      ports <- rbind(ports, data.frame(stringsAsFactors = FALSE,
        name = paste0(ch1,ch2), x = i, y = j))
    }
    ports
  }
  
  for (i in 3:(wid-2)) {
    ports <- nport(ports, maze[[1]][i],        maze[[2]][i], i, 3)
    ports <- nport(ports, maze[[tmid + 1]][i], maze[[tmid + 2]][i], i, tmid)
    ports <- nport(ports, maze[[bmid - 2]][i], maze[[bmid - 1]][i], i, bmid)
    ports <- nport(ports, maze[[hei - 1]][i],  maze[[hei]][i], i, hei - 2)
  }
  
  for (j in 3:(hei-2)) {
    ports <- nport(ports, maze[[j]][1], maze[[j]][2], 3, j)
    ports <- nport(ports, maze[[j]][lmid + 1], maze[[j]][lmid + 2], lmid, j)
    ports <- nport(ports, maze[[j]][rmid - 2], maze[[j]][rmid - 1], rmid, j)
    ports <- nport(ports, maze[[j]][wid - 1], maze[[j]][wid], wid - 2, j)
  }
  
  ports[order(ports$name),]
}

solve <- function(fn, part1 = TRUE) {
  dx <- c(0,1,0,-1)
  dy <- c(-1,0,1,0)
  maze <- lapply(readLines(fn), function(x) strsplit(x, "")[[1]])
  hei <- length(maze)
  wid <- length(maze[[1]])
  ports <- analyse_maze(maze, hei, wid)
  queuemax <- 500
  queuex <- rep(-1, queuemax)
  queuey <- rep(-1, queuemax)
  queuel <- rep(-1, queuemax)
  queuehead <- 1
  queuetail <- 1
  
  max_level <- 220
  dist <- array(99999, c(max_level, wid, hei))

  queuex[queuetail] <- ports$x[ports$name == 'AA']
  queuey[queuetail] <- ports$y[ports$name == 'AA']
  queuel[queuetail] <- 0
  
  dist[1, queuex[queuetail], queuey[queuetail]] <- 0
  queuetail <- (queuetail %% queuemax) + 1
  
  best_distance <- 999999
  
  while (queuetail != queuehead) {
    x <- queuex[queuehead]
    y <- queuey[queuehead]
    lev <- queuel[queuehead]
    queuehead <- (queuehead %% queuemax) + 1
    
    current_dist <- dist[lev + 1, x, y]
    if (current_dist < best_distance) {
      for (dir in seq_along(dx)) {
        if (maze[[y + dy[dir]]][x + dx[dir]] == '.') {
          next_dist <- dist[lev + 1, x + dx[dir], y + dy[dir]]
          if (next_dist > current_dist + 1) {
            queuex[queuetail] <- x + dx[dir]
            queuey[queuetail] <- y + dy[dir]
            queuel[queuetail] <- lev
            queuetail <- (queuetail %% queuemax) + 1
            dist[lev + 1, x + dx[dir], y + dy[dir]] <- current_dist + 1
          }
        }
      }
      
      pname <- ports$name[ports$x == x & ports$y == y]
      if (length(pname) == 1) {
        if (!pname %in% c("AA", "ZZ")) {
          pindex <- which(ports$name == pname & ((ports$x !=x) | (ports$y != y)))
          px <- ports$x[pindex]
          py <- ports$y[pindex]
          plev <- lev
          if (!part1) {
            if ((x %in% c(3, wid-2)) || (y %in% c(3, hei-2))) plev <- plev - 1
            else plev <- plev + 1
          }
          if (plev >= 0) {
            if (dist[plev + 1, px, py] > (current_dist + 1)) {
              dist[plev + 1, px, py] <- current_dist + 1
              queuex[queuetail] <- px
              queuey[queuetail] <- py
              queuel[queuetail] <- plev
              queuetail <- (queuetail %% queuemax) + 1
            }
          }
        } else if ((pname == 'ZZ') && (lev == 0)) {
          best_distance <- current_dist
        }  
      }
    }
  }
  zx <- ports$x[ports$name == 'ZZ']
  zy <- ports$y[ports$name == 'ZZ']
  dist[1, zx, zy]
}

c(solve("../inputs/input_20.txt"),
  solve("../inputs/input_20.txt", FALSE))
