source("wes_computer.R")

CH_UNEXPLORED <- (-1)
CH_WALL <- (-2)

OXYGEN <- 2
WALL <- 0

map <<- list(0)
droidx <<- 1
droidy <<- 1
oxygenx <<- 1
oxygeny <<- 1
dx <- c(0, 0, -1, 1)
dy <- c(-1, 1, 0, 0)
reverse <- c(2,1,4,3)

expand <- function(x, y) {
  wid <- length(map[[1]])
  hei <- length(map)
  if (x == 0) {
    for (y in seq_along(map)) map[[y]] <<- c(CH_UNEXPLORED, map[[y]])
    droidx <<- droidx + 1
    oxygenx <<- oxygenx + 1
    
  } else if (x > wid) {
    for (y in seq_along(map)) map[[y]] <<- c(map[[y]], CH_UNEXPLORED)
    
  } else if (y == 0) {
    map <<- c(list(rep(CH_UNEXPLORED, wid)), map)
    droidy <<- droidy + 1
    oxygeny <<- oxygeny + 1
    
  } else if (y > hei) {
    map <<- c(map, list(rep(CH_UNEXPLORED, wid)))
  }
}

explore <- function(direction, step_no) {
  expand(droidx + dx[direction], droidy + dy[direction])
  ch <- map[[droidy + dy[direction]]][droidx + dx[direction]]

  if ((ch == CH_UNEXPLORED) || (ch > step_no)) {
    ic$add_input(direction)
    ic$run()
    result <- ic$read_output()
    if (result == WALL) {
      map[[droidy + dy[direction]]][droidx + dx[direction]] <<- CH_WALL
    } else {
      droidx <<- droidx + dx[direction]
      droidy <<- droidy + dy[direction]
      map[[droidy]][droidx] <<- step_no + 1
      
      if (result == OXYGEN) {
        oxygenx <<- droidx;
        oxygeny <<- droidy;
      }
      
      for (next_dir in 1:4) {
        if (next_dir != reverse[direction]) explore(next_dir, step_no + 1);
      }
      ic$add_input(reverse[direction])
      ic$run()
      ic$read_output()
      droidx <<- droidx - dx[direction]
      droidy <<- droidy - dy[direction]
    }      
  }
}

solve1 <- function() {
  map <<- list(0)
  droidx <<- 1
  droidy <<- 1
  oxygenx <<- 1
  oxygeny <<- 1
  for (i in 1:4) explore(i, 0)
  map[[oxygeny]][oxygenx]
}

solve2 <- function(x, y, step = 0, max_steps = 0) {
  max_steps <- max(max_steps,  step)
  map[[y]][x] <<- 0
  for (dir in 1:4) {
    scan <- map[[y + dy[dir]]][x + dx[dir]]
    if (scan>0) 
      max_steps <- solve2(x + dx[dir], y + dy[dir], step + 1, max_steps)
  }
  return(max_steps)
}

ic <- IntComputer$new("../inputs/input_15.txt")
c(solve1(), solve2(oxygenx, oxygeny))
