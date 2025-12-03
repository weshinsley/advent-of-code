library(numbers)

solve1 <- function(w) {
  ts <- as.integer(w[1])
  buses <- strsplit(w[2], ",")[[1]]
  buses <- as.integer(buses[buses != 'x'])
  nextbus <- (ceiling(ts/buses)*buses)-ts
  soonest <- which(nextbus == min(nextbus))
  nextbus[soonest]*buses[soonest]
}

solve2 <- function(w) {
  buses <- strsplit(w, ",")[[1]]
  indexes <- which(buses!='x') - 1
  values <- as.integer(buses[indexes + 1])
  start <- (-indexes)
  for (i in seq_along(start)) {
    while (start[i] < 0) {
      start[i] <- start[i] + values[i]
    }
  }
  chinese(start, values)
}
options(digits=16)
wes <- readLines("../inputs/input_13.txt")
c(solve1(wes), solve2(wes[[2]]))
