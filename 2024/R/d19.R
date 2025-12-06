source("../../shared/R/util.R")

parse_file <- function(f = "../inputs/input_19.txt") {
  d <- readLines(f)
  d <- list(towels = strsplit(d[1], ", ")[[1]],
       designs = d[3:length(d)])
  d$towels <- d$towels[order(nchar(d$towels), decreasing = TRUE)]
  d
}

solve <- function(d) {
  remember <- new.env()
  
  solve1 <- function(towels, target, start = 1L, tot = 0L) {
    thing <- substring(target, start)
    if (exists(thing, envir = remember, inherits = FALSE)) {
      return(get(thing, envir = remember))
    }
    
    tot <- sum(vnapply(which(vlapply(towels, function(x) 
      substring(target, start, (start - 1L) + nchar(x)) == x)), 
        function(y) if (towels[y] == thing) 1L else 
                    solve1(towels, target, start + nchar(towels[y]))))

    assign(thing, tot, envir = remember)
    return(tot)
  }
  
  #################################
  
  tot <- rep(0, length(d$designs))
  for (design in seq_along(d$designs)) {
    rm(list = ls(envir = remember), envir = remember)
    tot[design] <- solve1(d$towels, d$designs[design])
  }
  c(sum(tot > 0), sum(tot))
}

part1 <- function(d) {
  d[1]
}

part2 <- function(d) {
  d[2]
}

d <- solve(parse_file())
c(part1(d), part2(format(d, digits = 16)))