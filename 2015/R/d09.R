d <- read.csv("../inputs/input_9.txt", header = FALSE, sep=" ",
  col.names = c("orig","x","dest","y","dist"))[, c("orig", "dest", "dist")]
d <- rbind(d, data.frame(orig = d$dest, dest = d$orig, dist = d$dist))

best_dist <<- 0

explore <- function(visited, to_visit, func, dist) {
  if (length(to_visit) == 0) {
    best_dist <<- func(best_dist, dist)
    return(best_dist)
  }
  dests <- d[d$orig == visited[length(visited)] &
             d$dest %in% to_visit, ]
  
  if (nrow(dests) == 0) {
    return()
  }
  
  for (i in seq_len(nrow(dests))) {
    x <- explore(c(visited, dests$dest[i]), to_visit[to_visit != dests$dest[i]],
            func, dist + dests$dist[i])
  }
  best_dist
}

explore_all <- function(best, func) {
  places <- unique(c(d$orig, d$dest))
  best_dist <<- best
  for (p in places) {
    explore(p, places[places!= p], func, 0)
  }
  best_dist
}

c(explore_all(sum(d$dist), min), explore_all(0, max))
