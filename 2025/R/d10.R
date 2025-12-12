parse_file <- function(f = "../inputs/input_10.txt") {
  strsplit(gsub("#", 1, gsub("\\.", 0, gsub("[^0-9.,# ]", "", readLines(f)))), "\\s+")
}
   
solve1 <- function(target, buttons) {
  history <- new.env()
  state <- list(lights = rep(0, length(target)), pushes = 0)
  hash <- paste0(c("X", target), collapse="_")
  assign(hash, 1, envir = history)
  
  queue <- list()
  queue[[1]] <- state
  head <- 1
  tail <- 2
  
  while(TRUE) {
    state <- queue[[head]]
    head <- head + 1
    for (b in buttons) {
      new_lights <- state$lights
      new_pushes <- state$pushes + 1
      for (each in b) {
        new_lights[each + 1] <- (1 - new_lights[each + 1])
        
      }
      if (all(new_lights == target)) return(new_pushes)
      
      hash <- paste0(c("X", new_lights), collapse="_")
      if (!exists(hash, envir = history)) {
        queue[[tail]] <- list(lights = new_lights, pushes = new_pushes)
        tail <- tail + 1
        assign(hash, 1, envir = history)
      }
    }
  }
}

solve2 <- function(jolts, buttons) {
  vars <- rep(1, length(buttons))
  in_buttons <- lapply(seq_along(jolts), function(var) {
    as.integer(unlist(lapply(buttons, function(b) {
      (var - 1) %in% b
  })))})
  constraints <- do.call(rbind, in_buttons)
  res <- lpSolve::lp(direction = "min", 
                     objective.in = vars,
                     const.mat = constraints,
                     const.dir = rep("=", length(jolts)),
                     const.rhs = jolts,
                     int.vec = seq_along(vars))
  res$objval
}

one_machine <- function(m, part1 = TRUE) {
  target <- as.integer(strsplit(m[1], "")[[1]])
  jolts <- as.integer(strsplit(m[length(m)], ",")[[1]])
  buttons <- lapply(m[2:(length(m)-1)], function(x)
    as.integer(strsplit(x, ",")[[1]]))
  if (part1) solve1(target, buttons)
  else solve2(jolts, buttons)
}

part1 <- function(d) {
  sum(unlist(lapply(d, one_machine)))
}

part2 <- function(d) {
  sum(unlist(lapply(d, one_machine, FALSE)))
}

d <- parse_file()
c(part1(d), part2(d))
