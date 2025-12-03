START <- -99L
END <- 0L
PO <- -98L

read_input <- function(f) {
  d <- read.table(f,  sep = "-", header = FALSE,
                  col.names = c("from", "to"))
  
  # This is specific to my solution.
  # Edges po<->YK and po<->zk are spurs, which we can remove;
  # for part 1 they are never used as they force two entries to po
  # for part 2, they allow 2 additional possibilities, for each result
  # where po is visited exactly once.
  
  d <- d[d$from !="po" | d$to == "TS", ]
  
  d <- rbind(d, data.frame(from = d$to, to = d$from))
  d$small <- (tolower(d$to) == d$to)
  d <- d[d$from != "end", ]
  d <- d[d$to != "start", ]
  caves <- data.frame(name = unique(c(d$from, d$to)))
  caves$no <- seq_len(nrow(caves))
  caves$small <- tolower(caves$name) == caves$name
  caves$no[caves$small] <- -(caves$no[caves$small])
  caves$no[caves$name == "start"] <- START
  caves$no[caves$name == "end"] <- END
  caves$no[caves$name == "po"] <- PO
  d$from <- caves$no[match(d$from, caves$name)]
  d$to <- caves$no[match(d$to, caves$name)]
  
  d <- d[, c("to", "from")]
  
  graph <- new.env() 
  for (i in unique(d$from)) {
    assign(as.character(i), unique(d$to[d$from == i]), env = graph)
  }
  
  graph
  
}

explore <- function(current, small_visited, part2 = FALSE, used_dups = FALSE) {

  used_dups <- used_dups || anyDuplicated(small_visited)
  tot <- 0L
  dests <- d[[as.character(current)]]
  if ((!part2) || (used_dups)) {
    dests <- dests[!dests %in% small_visited]
  }
  
  for (dest in dests) {
    if (dest == 0L) {
      if (part2) {
        if (!used_dups) {
          if (PO %in% small_visited) {
            tot <- tot + 2L
          }
        }
      }
      tot <- tot + 1L
    } else {
      tot <- tot + explore(dest, 
        if (dest > 0L) small_visited else c(small_visited, dest),
        part2, used_dups)
    }
  }
  
  tot
}

part1 <- function(part2 = FALSE) {
  explore(START, START, part2)
}

part2 <- function() {
  part1(TRUE)
}

d <- read_input("../inputs/input_12.txt")
c(part1(), part2())
