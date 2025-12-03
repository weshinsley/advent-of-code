d <- read.csv(text = gsub("rect ","rect,", gsub("rotate row y=", "rotr,",
      gsub("x", ",", gsub("rotate column x=", "rotc,", 
         gsub(" by ",",", readLines("../inputs/input_8.txt")))))),
           header = FALSE, col.names = c("func", "arg1", "arg2"))

d$arg1[d$func != "rect"] <- d$arg1[d$func != "rect"] + 1

screen <- list()
for (i in 1:6) screen[[i]] <- rep(" ", 50)

rect <- function(screen, x, y) {
  for (ys in 1:y) screen[[ys]][1:x] <- "@"
  screen
}

rotc <- function(screen, x, n) {
  n <- n %% 6
  map <- (1:6) - n
  map[map <= 0] <- map[map <= 0] + 6
  screen2 <- screen
  for (i in 1:6) {
    screen2[[i]][x] <- screen[[map[i]]][x]
  }
  screen2
}

rotr <- function(screen, y, n) {
  n <- n %% 50
  map <- (1:50) - n
  map[map <= 0] <- map[map <= 0] + 50
  screen2 <- screen
  for (i in 1:50) {
    screen2[[y]][i] <- screen[[y]][map[i]]
  }
  screen2
}

draw <- function(screen) {
  for (y in 1:6) {
    message(paste(screen[[y]], collapse=""))
  }
}
for (i in seq_len(nrow(d))) {
  screen <- do.call(d$func[i], list(screen, d$arg1[i], d$arg2[i]))
}
message(paste(sum(unlist(screen) == '@'), "\n"))
draw(screen)
