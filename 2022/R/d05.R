parse_stacks <- function(input) {
  count <- max(as.integer(strsplit(trimws(input[which(input == "") - 1]),
                          "\\s+")[[1]]))

  parse_single <- function(index) {
    index <- (index * 4) - 2
    stack <- substr(input, index, index)
    stack <- stack[1:(which(stack == "")[1] - 2)]
    stack[trimws(stack) != ""]
  }

  lapply(1:count, parse_single)
}

parse_moves <- function(input) {
  input <- input[(1 + which(input == "")):length(input)]
  read.csv(text = gsub("[a-z ]+", ",", input),
    col.names = c("", "move", "from", "to"), header = FALSE)
}

parse <- function(input) {
  list(stacks = parse_stacks(input), moves = parse_moves(input))
}

solve <- function(d, part1 = FALSE) {
  for (i in seq_len(nrow(d$moves))) {
    move <- d$moves[i, ]
    lift <- d$stacks[[move$from]][1:move$move]
    if (part1) lift <- rev(lift)
    d$stacks[[move$from]] <-
      d$stacks[[move$from]][(move$move + 1):length(d$stacks[[move$from]])]
    d$stacks[[move$to]] <- c(lift, d$stacks[[move$to]])
  }
  paste0(lapply(d$stacks, `[[`, 1), collapse = "")
}

part1 <- function(d) {
  solve(d, TRUE)
}

part2 <- function(d) {
  solve(d)
}

d <- parse(readLines("../inputs/input_5.txt"))
c(part1(d), part2(d))
