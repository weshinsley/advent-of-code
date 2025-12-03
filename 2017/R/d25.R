parse <- function(input) {
  d <- NULL
  d$init_state <- gsub("Begin in state |\\.", "", input[1])
  d$iters <- as.numeric(gsub("Perform a diagnostic checksum after | steps\\.","",input[2]))
  line <- 4
  d$rules <- NULL
  while (line < length(input)) {
    d$rules <- rbind(d$rules, data.frame(
      in_state = gsub("In state |\\:","",input[line]),
      if_val = as.numeric(gsub("  If the current value is |\\:", "", input[line+1])),
      write_val = as.numeric(gsub("    - Write the value |\\.", "", input[line+2])),
      move_dir = gsub("    - Move one slot to the |ight|eft|\\.", "", input[line+3]),
      out_state = gsub("    - Continue with state |\\.", "", input[line+4]),
      stringsAsFactors=FALSE))

    d$rules <- rbind(d$rules, data.frame(
      in_state = gsub("In state |\\:","",input[line]),
      if_val = as.numeric(gsub("  If the current value is |\\:", "", input[line+5])),
      write_val = as.numeric(gsub("    - Write the value |\\.", "", input[line+6])),
      move_dir = gsub("    - Move one slot to the |ight|eft|\\.", "", input[line+7]),
      out_state = gsub("    - Continue with state |\\.", "", input[line+8]),
      stringsAsFactors=FALSE))

      line <- line + 10
  }

  d

}

advent25a <- function(spec) {
  state <- spec$init_state
  tape <- 0
  pointer <- 1
  i <- 0
  while (i < spec$iters) {
    rule <- spec$rules[(spec$rules$in_state == state) &
                       (spec$rules$if_val == tape[pointer]),]
    tape[pointer] <- rule$write_val
    pointer <- pointer + (rule$move_dir=='r') - (rule$move_dir=='l')
    state <- rule$out_state
    if (pointer > length(tape)) tape <- c(tape, 0)
    if (pointer == 0) {
      tape <- c(0, tape)
      pointer <- 1
    }
    i <- i + 1
  }
  sum(tape)
}

spec <- readLines("../inputs/input_25.txt")
advent25a(parse(spec))
