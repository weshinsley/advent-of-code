parse_input <- function(f, p2 = FALSE) {
  d <- lapply(readLines(f), function(x) strsplit(x, "")[[1]])
  c(rep(".", 7), d[[3]][4], d[[3]][6], d[[3]][8], d[[3]][10],
    if (p2) c("D", "C", "B", "A", "D", "B", "A", "C") else NULL,
      d[[4]][4], d[[4]][6], d[[4]][8], d[[4]][10])
}

dump <- function(d) {
  message("#############")
  message(sprintf("#%s%s.%s.%s.%s.%s%s#", d[1], d[2], d[3], d[4], d[5], d[6],d[7]))
  message(sprintf("###%s#%s#%s#%s###", d[8], d[9], d[10], d[11]))
  message(sprintf("###%s#%s#%s#%s###", d[12], d[13], d[14], d[15]))
  if (length(d) > 15) {
    message(sprintf("###%s#%s#%s#%s###", d[16], d[17], d[18], d[19]))
    message(sprintf("###%s#%s#%s#%s###", d[20], d[21], d[22], d[23]))
  }
  message("  #########")
  message("")
}


solve <- function(amph, p2 = FALSE) {
  env <- new.env()
  best <<- 99999
  ABCD <- c("A", "B", "C", "D")
  target <- c(rep(".", 7), rep(ABCD, 2 * (p2 + 1)))

  hallwayx <- c(2, 3, 5, 7, 9, 11, 12)
  htohpos <- c(NA, 1, 2, NA, 3, NA, 4, NA, 5, NA, 6, 7)
  colx <- c(4, 6, 8, 10)
  weight <- c(1, 10, 100, 1000)

  dfs <- function(amph, steps) {

    if (identical(amph, target)) { # Check for solution
      best <<- min(best, steps)
      return()
    }

    if (steps >= best) { # Already too many steps
      return()
    }

    # Check if we've seen this state before but got here quicker

    squish <- paste0(amph, collapse = "")
    if (exists(squish, envir = env)) {
      prev <- get(squish, envir = env)
      if (prev <= steps) {
     #   message("HIST PRUNE!!!!!!!!!!!!!!")
    #    message()
        return()
      }
    }

    assign(squish, steps, envir = env)

    # See if any columns are ready to receive - ie, they are empty, or
    # they contain only some of the correct things

    can_recv <- rep(FALSE, 4)

    for (col in 1:4) {    # Top slots: 8,9,10,11. Next, 12,13,14,15
      col_letter <- ABCD[col]
      can_recv[col] <- (amph[7 + col] == ".") &&
                       (amph[11 + col] %in% c(col_letter, "."))
      if (p2) {
        can_recv[col] <- can_recv[col] &&
                       (amph[15 + col] %in% c(col_letter, ".")) &&
                       (amph[19 + col] %in% c(col_letter, "."))
      }
    }

    # For each hallway position that's got something in it, see if
    # we can move it to a slot. We need to DFS here, because if
    # we have two of the same in different hallway positions, order will
    # matter for shortest distance. Plus, moving things out of the way will
    # enable different moves.

    for (hpos in 1:7) {          # 7 hallway positions
      if (amph[hpos] != ".") {   # There's an amph here...
        srcx <- hallwayx[hpos]   # Translate to x position
        dest <- utf8ToInt(amph[hpos]) - 64   # target (1,2,3,4)

        if (!can_recv[dest]) {  # Is that slot ready to receive?
          next
        }

        # Any obstacles preventing us getting into that slot?

        destx <- colx[dest]

        # srcx always != destx as they can't wait outside the column

        if (destx < srcx) {
          xx <- destx:(srcx - 1)
          xx <- xx[xx %in% hallwayx]
          if (any(amph[htohpos[xx]] != ".")) {
            next
          }
        } else {
          xx <- (srcx + 1):destx
          xx <- xx[xx %in% hallwayx]
          if (any(amph[htohpos[xx]] != ".")) {
            next
          }
        }

        # All good. explore the move.

        amph2 <- amph
        steps2 <- steps
        item <- amph2[hpos]

        wt <- weight[utf8ToInt(item) - 64]

        steps2 <- steps2 + (wt * (abs(hallwayx[hpos] - destx)))

        # Find the lowest space in the column

        if ((p2) && (amph2[19 + dest] == ".")) {
          amph2[19 + dest] <- item
          steps2 <- steps2 + (4 * wt)

        } else if ((p2) && (amph2[15 + dest] == ".")) {
          amph2[15 + dest] <- item
          steps2 <- steps2 + (3 * wt)

        } else if (amph2[11 + dest] == ".") {
          amph2[11 + dest] <- item
          steps2 <- steps2 + (2 * wt)

        } else if (amph2[7 + dest] == ".") {
          amph2[7 + dest] <- item
          steps2 <- steps2 + wt
        }
        amph2[hpos] <- "."
        dfs(amph2, steps2)
        if (steps >= best) return()
      }
    }

    # Move from cols to hallway. Try top amph in each col.

    for (col in 1:4) {
      if (can_recv[col]) {  # Col already happy - don't move.
        next
      }

      if ((amph[htohpos[colx[col] - 1]] != ".") &&
          (amph[htohpos[colx[col] + 1]] != ".")) {
        next               # Can't get out. Don't bother trying.
      }

      # Otherwise, we must have a valid move.

      steps2 <- steps
      amph2 <- amph
      wt <- NULL
      for (row in 1:4) {
        slot <- col + 3 + (row * 4)
        if (amph2[slot] != ".") {
          item <- amph2[slot]
          wt <- weight[utf8ToInt(item) - 64]
          steps2 <- steps2 + (wt * row)
          amph2[slot] <- "."
          break
        }
      }

      # So we are now at colx[col] in the hallway. Go left and right.

      for (x in (colx[col] - 1):2) {
        if (x %in% hallwayx) {
          if (amph2[htohpos[x]] != ".") { # Hit an obstacle. Stop looking.
            break
          }
          amph2[htohpos[x]] <- item
          dfs(amph2, steps2 + (wt * abs(colx[col] - x)))
          if (steps >= best) return()
          amph2[htohpos[x]] <- "."
        }
      }

      for (x in (colx[col] + 1):12) {
        if (x %in% hallwayx) {
          if (amph2[htohpos[x]] != ".") { # Hit an obstacle. Stop looking.
            break
          }
          amph2[htohpos[x]] <- item
          dfs(amph2, steps2 + (wt * abs(x - colx[col])))
          if (steps >= best) return()
          amph2[htohpos[x]] <- "."
        }
      }
    }
  }
  dfs(amph, 0)
  best
}

part1 <- function(d) {
  solve(d)
}

part2 <- function(d) {
  solve(d, TRUE)
}

c(part1(parse_input("../inputs/input_23.txt")), 
  part2(parse_input("../inputs/input_23.txt", TRUE)))
