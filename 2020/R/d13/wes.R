library(crayon)
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

stopifnot(solve1(readLines("test.txt")) == 295)
stopifnot(solve2("17,x,13,19") == 3417)
stopifnot(solve2("67,7,59,61") == 754018)
stopifnot(solve2("67,x,7,59,61") == 779210)
stopifnot(solve2("67,7,x,59,61") == 1261476)
stopifnot(solve2("1789,37,47,1889") == 1202161486)

wes <- readLines("wes-input.txt")
cat(red("\nAdvent of Code 2020 - Day 13\n"))
cat(blue("----------------------------\n\n"))
cat("Part 1:", green(solve1(wes)), "\n")
cat("Part 2:", green(solve2(wes[[2]])), "\n")
