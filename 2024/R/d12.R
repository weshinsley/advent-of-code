source("../../shared/R/matrix.R")

parse_file <- function(f = "../inputs/input_12.txt") {
  pad_matrix(strings_to_char_matrix(readLines(f)), 2, ".")
}

scan_shape <- function(d, pxy) {
  w <- ncol(d)
  H <- function(x, y) { (y * w) + x }
  dx <- c(0, 1, 0, -1)                           # URDL
  dy <- c(-1, 0, 1, 0)                           # URDL
  dx8 <- c(-1, 0, 1, 1, 1, 0, -1, 0)             # 8-dir dx
  dy8 <- c(-1, -1, -1, 0, 1, 1, 1, 0)            # 8-dir dy
  pix <- list()                 # list of pixels in this region
  contains <- list()            # pixels in other regions contained in this one
  cc <- 0                 # Count of contains
  related <- c()          # hash  of other-region pixels that might be inside
  rx <- c()               # x co-ords of them
  ry <- c()               # y co-ords of them
  xrange <- c(pxy[1], pxy[1])  # x bounds of this region
  yrange <- c(pxy[2], pxy[2])  # y bounds of this region
  queue <- list(pxy)           # queue of work to do
  ch <- d[pxy[2], pxy[1]]      # character for this region
  i <- 0                       # pointer into how much work we've done
  n <- 1                       # last entry to explore
  d[pxy[2], pxy[1]] <- "#"     # Set first square to visited
  area <- 1                    # and as area 1

  while (i < n) {                   # While there's more work to
    i <- i + 1                      # Get the work out
    x <- queue[[i]][1]              #   Explore this x
    y <- queue[[i]][2]              #    and this y
    xrange[1] <- min(xrange[1], x)  # Remember bounding box - xmin
    xrange[2] <- max(xrange[2], x)  # xmax   - so that we can tell later
    yrange[1] <- min(yrange[1], y)  # ymin   - if we're outside this region
    yrange[2] <- max(yrange[2], y)  # ymax   - when considering related bits

    pix[[i]] <- H(x, y)        # Remember pixel is part of this region
    for (dir in 1:4) {         # Explore each direction
      ny <- y + dy[dir]        #   Here's the new potential y
      nx <- x + dx[dir]        #   and new potential x
      ch2 <- d[ny, nx]         #   What do we find here?
      if (ch2 == ch) {         #      SAME REGION!
        n <- n + 1             #        More work to do from that point.
        queue[[n]] <- c(nx, ny)   #     Add it to end of queue
        d[ny, nx] <- "#"          #     Set it as visited so won't come up again
        area <- area + 1          #     inc area
      } else if (!ch2 %in% c("#", ".")) { #  OTHER REGION - might/not be inside this one
        hash <- (ny * ncol(d)) + nx    #  hash (x,y) into integer
        if (!hash %in% related) {      # If we  didn't flag it already
          related <- c(related, hash)  # then flag it for later.
          rx <- c(rx, nx)              # Store rx and ry for ease...
          ry <- c(ry, ny)
        }
      }
    }
  }
  remember_d <- d                 # We're going to mess d up in a minute...
  while (length(related) >= 1) {  # Now, for each point that "might" be inside..
    x <- rx[1]                    # Fetch x
    y <- ry[1]                    # and y
    ch2 <- d[y, x]                # and name of other region
    d[y, x] <- "@"                # Mark first pix at visited

              # Do a seed fill for this other region, see if we can break
              # outside of the xrange,yrange for our region above, without
              # crossing any characters we marked with "#". If so, the
              # related region is not enclosed by the first one.
              # without going outside of the range, then

    queue <- list(c(x, y)) # First cell to explore...
    i <- 0                 # pointer again
    n <- 1                 # size again

    broke_out <- FALSE
    while (i < n) {
      i <- i + 1
      x <- queue[[i]][1]
      y <- queue[[i]][2]
      if (x < xrange[1] || x > xrange[2] ||   # If out of range
          y < yrange[1] || y > yrange[2]) {
        broke_out <- TRUE                     # We escaped.
        next                                  # End this pixel.
      }                                       # Note that we can escape through
                                              # diagonals...
      for (dir8 in 1:8) {                      # For each direction again
        nx <- x + dx8[dir8]                     # Step - what's x
        ny <- y + dy8[dir8]                     #   and y...
        if ((d[ny, nx] != "@" && d[ny, nx] != "#")) { # Not visited before
          d[ny, nx] <- "@"                            # Now visited
          n <- n + 1                                  # Add to list...
          queue[[n]] <- c(nx, ny)
        }
      }
    }

    explored <- which(d == "@", arr.ind = TRUE)   # Mark newly visited...
    d[explored] <- "~"                            # so we don't go again...

    hashes <- explored[, 1] * ncol(d) + explored[, 2] # Filter to only the
    hashes <- hashes[hashes %in% related]             # ones in related -
    for (hash in hashes) {
      j <- which(related == hash)
      if (!broke_out) {
        cc <- cc + 1                      # If we didn't break out, remember
        contains[[cc]] <- H(rx[j], ry[j]) # these pixels for this region...
      }
      related <- related[-j]              # Remove all the ones visited so far
      rx <- rx[-j]                        # from the related, rx and ry vecs.
      ry <- ry[-j]
    }
  }

  d <- remember_d      # Back to our non-messed up version with just '#'
  perim <- 0                                     # The perimeter.
  for (y in (yrange[1] - 1):(yrange[2] + 1)) {   # For every empty space
    for (x in (xrange[1] - 1):(xrange[2] + 1)) { # that's next to a boundary...
      if (d[y, x] != "#") {
        perim <- perim +
          (d[y + 1, x] == "#") +
          (d[y - 1, x] == "#") +
          (d[y, x + 1] == "#") +
          (d[y, x - 1] == "#")
      }
    }
  }

  # And the number of sides. Going to walk around the perimeter
  # counting the number of times we change directions. We might do so
  # multiple times on the spot, for a U-turn type.

  sides <- 0        # Our counter
  sx <- pxy[1]      # Starting x
  sy <- pxy[2]      # Starting y - and we either face right or down.
  sdir <- if (d[sy, sx + 1] == "#")  2 else 3    # at the start.

  dir <- sdir
  y <- sy
  x <- sx
  while ((sides == 0) || (sx != x) || (sy !=  y) || (dir != sdir)) {
    dirl <- if (dir == 1) 4 else (dir - 1)  # what dir if I turn left?
    dirr <- if (dir == 4) 1 else (dir + 1)  # what dir if I turn right?
    f <- d[y + dy[dir], x + dx[dir]]        # What is straight ahead?
    if ((length(f) == 0) || (is.null(f)) || (is.na(f))) {
      browser()
    }
    fl <- d[y + dy[dirl], x + dx[dirl]]     # What is directly to my left?

    if (fl == "#") {        # If there's perimeter on my left...
      dir <- dirl           #   Turn left
      sides <- sides + 1    #   This counts as a corner.
      x <- x + dx[dir]      #   Take a step in whatever direction I am facing
      y <- y + dy[dir]

    } else if (f == "#") {  #   If there's perimeter in front of me
      x <- x + dx[dir]      #   Just walk on it.
      y <- y + dy[dir]

    } else  {
      dir <- dirr           # Otherwise, turn right on the spot - it's a
      sides <- sides + 1    # corner, so count it. Then see what I can see.
    }
  }


  d[d == "#"] <- "."          # Done with this region - set to "."
  list(d = d,
       pxy = pxy,
       pix = unlist(pix),
       area = area,
       region = ch,
       contains = unlist(contains),
       perim = perim,
       sides = sides)
}

solve <- function(d) {
  i <- 0             # Counter for what region we're on
  data <- list()     # Collect data for each region.
  orig <- d          # Keep a copy of the unspoiled map.
                     # d we'll fill with "." as we do each region
                     # so we can look up the next one below.

  points <- which(d != ".", arr.ind = TRUE)    # Start with top-left-ish
  while (nrow(points) > 0) {                   # While there is work to do
    i <- i + 1                                 # Set index for data
    pxy <- as.integer(c(points[1, 2],
                        points[1, 1]))         # Get point co-ords
    res <- scan_shape(orig, pxy)               # Fetch results
    d[res$d == "."] <- "."                     # Update my map
    res$d <- NULL                              # Don't need result map any more
    data[[i]] <- res                           # Save rest of data
    points <- which(d != ".", arr.ind = TRUE)  # Ready for Next region
  }

  # Now we need to find regions contained within other regions, and add
  # the extra sides

  for (i in seq_along(data)) {                 # For each region
    if (length(data[[i]]$contains) > 0) {      # Does it contain foreign pix?
      ps <- data[[i]]$contains                 # Yes.
      for (j in seq_along(data)) {             # For each region again
        if (i != j) {                          # Not ourself (not that it matters)
          if (any(ps %in% data[[j]]$pix)) {    # Any pixels region j owns?
            ps <- ps[!ps %in% data[[j]]$pix]   # Yes. Remove from list, and
                                               # add sides.
                                               # `i` may have more children..
            data[[i]]$sides <- data[[i]]$sides + data[[j]]$sides
          }
        }
      }
    }
  }
  data
}

part1 <- function(data) {
  sum(unlist(lapply(data, function(x) { x$area * x$perim })))
}

part2 <- function(data) {
  sum(unlist(lapply(data, function(x) { x$area * x$sides })))
}

d <- solve(parse_file())
c(part1(d), part2(d))
