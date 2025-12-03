if (!interactive()) {
  stop("Day 25 needs to be run interactively")
}

source("wes_computer.R")

run <- function() {
  message("---------------------------------------------------------")
  message("About to run day 25. Useful extra commands: ")
  message("  quit     - exit")
  message("  restart  - start again (eg, if you get eaten by a grue)")
  message("---------------------------------------------------------")

  ic <- IntComputer$new("../inputs/input_25.txt")

  while (TRUE) {
    ic$run()
    s <- NULL
    while (ic$output_available()) s <- c(s, ic$read_output())
    message(intToUtf8(s))
    command <- readline("--> ")
    
    if (command == 'quit') {
      break
    
    } else if (command == 'restart') {
      ic$reset()
     
    } else {
      command <- c(utf8ToInt(command), 10)
      ic$add_input(command)
    }
  }
}

run()
