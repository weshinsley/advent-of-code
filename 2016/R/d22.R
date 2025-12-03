d <- read.table("../inputs/input_22.txt", skip = 2, header = FALSE,
              col.names = c("node", "size", "used", "avail", "use"))

d$used <- as.integer(gsub("T", "", d$used))
d$avail <- as.integer(gsub("T", "", d$avail))

d2 <- data.frame(node = rep(d$node, nrow(d)),
                 used = rep(d$used, nrow(d)),
                 avail = rep(d$avail, nrow(d)),
                 node2 = rep(d$node, each = nrow(d)),
                 used2 = rep(d$used, each = nrow(d)),
                 avail2 = rep(d$avail, each = nrow(d)))

d2 <- d2[d2$node != d2$node2, ]
d2 <- d2[d2$used != 0 & d2$avail2 >= d2$used, ]
part1 <- nrow(d2)

# Next bit is by observation. 
# Only one node can store anyone else's data on it,
# so use that to get to the top right, avoiding
# a bunch of nodes that are too big to move.
# Then wiggle around to copy the data from 
# right to left. Play the Atari version.

as.csv <- function(x) {
  read.csv(text = gsub("-y", ",", gsub("/dev/grid/node-x", "", x)),
            header = FALSE, col.names = c("x", "y"))
}

free_node <- as.csv(unique(d2$node2))
too_big <- as.csv(d$node[d$used > 0 & !d$node %in% d2$node])
last <- as.csv(d$node[nrow(d)])

steps <- (free_node$y - max(too_big$y) - 1) +
         (free_node$x - min(too_big$x) + 1) + 
         max(too_big$y) + 
         (last$x - (min(too_big$x))) + 1 +
         ((last$x - 1) * 5) + 1

c(nrow(d2), steps)
