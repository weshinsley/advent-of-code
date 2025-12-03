source("wes_computer.R")

part2 <- function(file) {
  df <- data.frame(i = rep(0:99, 100),
                   j = rep(0:99, each = 100))
  res <- which(unlist(lapply(seq_len(nrow(df)), function(x)
    IntComputer$new(file)$poke(1,df$i[x])$poke(2,df$j[x])$run()$peek(0) == 19690720)))

  (df$i[res] * 100) + df$j[res]

}

c(IntComputer$new("../inputs/input_2.txt")$reset()$poke(1,12)$poke(2,2)$run()$peek(0),
  part2("../inputs/input_2.txt"))
