source("wes_computer.R")

read_screen <- function(ic) {
  screen <- list()
  line <- NULL
  
  while (ic$output_available()) {
    ch <- ic$read_output()
    if (ch == 10) {
      screen <- c(screen, list(paste0(line)))
      line <- NULL
    } else {
      line <- c(line, intToUtf8(ch))
    }
  }
  screen
}

print_screen <- function(screen) {
  for (y in seq_along(screen)) {
    message(paste0(screen[[y]]))
  }
}

count_intersections <- function(screen) {
  total <- 0
  hei <- length(screen)
  wid <- length(screen[[1]])
  for (j in 2:(hei-1)) {
    for (i in 2:(wid-1)) {
      if ((all(screen[[j]][(i-1):(i+1)] == '#')) && 
              (screen[[j-1]][i] == '#') &&
              (screen[[j+1]][i] == '#'))
      total <- total + (i-1) * (j-1)
    }
  }
  total
}

solve1 <- function(ic) {
  count_intersections(read_screen(ic$run()))
}

read_write <- function(ic, entry) {
  while (ic$output_available()) ic$read_output()
  ic$add_input(c(utf8ToInt(entry), 10))
  ic$run()
}

solve2 <- function(ic) {
  ic$poke(0,2)
  ic$run()
  read_write(ic, "A,B,A,C,A,A,C,B,C,B")
  read_write(ic, "L,12,L,8,R,12")
  read_write(ic, "L,10,L,8,L,12,R,12")
  read_write(ic, "R,12,L,8,L,10")
  read_write(ic, "n")
  count10s <- 0
  while (ic$output_available()) { 
    ch <- ic$read_output()
    if (ch == 10) count10s <- count10s + 1
    else count10s <- 0
    if (count10s == 2) break
  }
  ic$read_output()
}

c(solve1(IntComputer$new("../inputs/input_17.txt")),
  solve2(IntComputer$new("../inputs/input_17.txt")))
