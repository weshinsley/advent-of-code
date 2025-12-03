read_input <- function(fn) {
  
  lines <- strsplit(readLines(fn), ")")
  
  df <- data.frame(stringsAsFactors = FALSE,
    thing = unlist(lapply(lines, "[[", 1)),
    orbited_by = unlist(lapply(lines, "[[", 2))
  )
  
  db <- data.frame(stringsAsFactors = FALSE,
    thing = unique(c(df$thing, df$orbited_by)),
    orbits = "",
    orbited_by = ""
  )
  
  for (i in seq_len(nrow(db))) {
    db$orbited_by[i] <- paste(df$orbited_by[df$thing == db$thing[i]],
                              collapse = ",")
    db$orbits[i] <- paste(df$thing[df$orbited_by == db$thing[i]],
                              collapse = ",")
  }
  db
}

count_orbits <- function(db, thing) {
  orbits <- db$orbits[db$thing == thing]
  if (orbits == '') return(0)
  return(1 + count_orbits(db, orbits))
}

solve1 <- function(db) {
  sum(unlist(lapply(seq_len(nrow(db)), function(x)
    count_orbits(db, db$thing[x]))))
}

######################

solve2 <- function(db) {
  thing_i_orbit <- db$orbits[db$thing == 'YOU']
  thing_san_orbits <- db$orbits[db$thing == 'SAN']
  db$steps <- nrow(db) + 1
  db$steps[db$thing == thing_i_orbit] <- 0
  
  queue <- thing_i_orbit
  
  while (length(queue) > 0) {
    i_now_orbit <- queue[1]
    my_steps <- db$steps[db$thing == i_now_orbit]
    queue <- queue[-1]
    if (i_now_orbit == thing_san_orbits) {
      return(my_steps)
    }
    
    dests <- c(db$orbits[db$thing == i_now_orbit],
               unlist(strsplit(db$orbited_by[db$thing == i_now_orbit], ",")))
    dests <- dests[dests != ""]
    
    for (dest in dests) {
      prev <- db$steps[db$thing == dest]
      if ((my_steps + 1) < prev) {
        db$steps[db$thing == dest] = my_steps + 1;
        queue <- c(queue, dest)
      }
    }
  }
}

wes <- read_input("../inputs/input_6.txt")
c(solve1(wes), solve2(wes))
