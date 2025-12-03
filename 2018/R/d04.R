advent4 <- function() {
  
  input <- sort(readLines("../inputs/input_4.txt"))
  guard_ids <- sort(as.numeric(gsub("#", "", unique(sapply(strsplit(input[grep("#", input)]," "), "[[", 4)))))
  guard_minutes <- rep(list(rep(0,60)), length(guard_ids))
  guard_total <- rep(0,60)

  e_guard = substring(input, 27)
  e_guard[e_guard == "sleep"] <- ""
  e_guard[e_guard == "p"] <- ""
  for (g in seq_len(length(e_guard))) {
    if (e_guard[g]!="") {
      e_guard[g] <- strsplit(e_guard[g]," ")[[1]][1]
    } else {
      e_guard[g] <- e_guard[g-1]
    }
  }
  
  events <- data.frame(
    day = as.numeric(substring(input,10,11)),
    minute = as.numeric(substring(input, 16, 17)),
    guard = as.numeric(e_guard),
    type = substring(input, 20, 20), stringsAsFactor = FALSE
  )
  
  i <- 1
  while (i < nrow(events)) {
    if (events$type[i]=='f') {
      m1 <- events$minute[i]
      m2 <- (events$minute[i+1] - 1)
      gid <- which(guard_ids == events$guard[i])
      for (j in m1:m2) guard_minutes[[gid]][j] <- guard_minutes[[gid]][j] + 1
      guard_total[gid] <- guard_total[gid] + (m2 - m1)
      i <- i + 1
    }
    i <- i + 1 
  }
  max <- max(guard_total)
  gid <- which(guard_total == max)
  best_minute <- which(guard_minutes[[gid]] == max(guard_minutes[[gid]]))
  r1 <- (guard_ids[gid] * best_minute)
    
  max_mins <- unlist(lapply(guard_minutes, max))
  gid <- which(max_mins == max(max_mins))
  fav_min <- max(guard_minutes[[gid]])
  c(r1, guard_ids[gid] * which(guard_minutes[[gid]] == fav_min))
}

advent4()
