EMPTY <- -1
WALL <- -2
GOBLIN <- -3
ELF <- -4
map_chars <- c('E','G','#','.')
map_int <- data.frame(chr = c(35,46,69,71), out = c(WALL, EMPTY, ELF, GOBLIN))



parse_input <- function(input) {
  game <- NULL
  input <- lapply(input,
    function(x) map_int$out[match(utf8ToInt(x), map_int$chr)])

  game$map <- matrix(nrow = length(input[[1]]), ncol = length(input),
                data = unlist(input), byrow = TRUE)

  game$elves <- data.frame(
                t = ELF,
                x = 1 + (which(game$map == ELF) %/% nrow(game$map)),
                y = (which(game$map == ELF) %% nrow(game$map)),
                hp = 200, ap = 3, stringsAsFactors = FALSE)

  game$elves$id <- seq_len(nrow(game$elves))

  game$goblins <- data.frame(
                t = GOBLIN,
                x = 1 + (which(game$map == GOBLIN) %/% nrow(game$map)),
                y = (which(game$map == GOBLIN) %% nrow(game$map)),
                hp = 200, ap = 3, stringsAsFactors = FALSE)

  game$goblins$id <- seq_len(nrow(game$goblins)) + nrow(game$elves)

  game$players <- rbind(game$elves, game$goblins)

  game
}

dump <- function(game, chars = FALSE, fname = NULL) {
  for (j in seq_len(nrow(game$map))) {
    message(intToUtf8(map_int$chr[match(game$map[j, ], map_int$out)]))
  }
  ps <- game$players[order(game$players$y, game$players$x), ]
  cat("\n")
  for (p in seq_len(nrow(ps))) {
    cat(sprintf("%s(%d), ", map_chars[5 + ps$t[p]], ps$hp[p]))
  }
  cat("\n")
}

explore_map <- function(m, i, j, dist) {
  m[j, i] <- dist
  dist <- dist + 1
  if ((m[j-1, i] == EMPTY) || (m[j-1, i] > dist)) m <- explore_map(m, i, j - 1, dist)
  if ((m[j, i-1] == EMPTY) || (m[j, i-1] > dist)) m <- explore_map(m, i - 1, j, dist)
  if ((m[j, i+1] == EMPTY) || (m[j, i+1] > dist)) m <- explore_map(m, i + 1, j, dist)
  if ((m[j+1, i] == EMPTY) || (m[j+1, i] > dist)) m <- explore_map(m, i, j + 1, dist)
  m
}

get_shortest_distance_map <- function(m, x, y) {
  m[y, x] <- 0
  if (m[y-1, x] >= EMPTY) m <- explore_map(m, x, y - 1, 1)
  if (m[y, x-1] >= EMPTY) m <- explore_map(m, x - 1, y, 1)
  if (m[y, x+1] >= EMPTY) m <- explore_map(m, x + 1, y, 1)
  if (m[y+1, x] >= EMPTY) m <- explore_map(m, x, y + 1, 1)
  m
}

single_step <- function(map, p) {
  squares <- NULL
  if (map[p$y - 1, p$x] == EMPTY)
    squares <- rbind(squares, data.frame(x = p$x, y = p$y - 1, stringsAsFactors = FALSE))
  if (map[p$y, p$x - 1] == EMPTY)
    squares <- rbind(squares, data.frame(x = p$x - 1, y = p$y, stringsAsFactors = FALSE))
  if (map[p$y, p$x + 1] == EMPTY)
    squares <- rbind(squares, data.frame(x = p$x + 1, y = p$y, stringsAsFactors = FALSE))
  if (map[p$y + 1, p$x] == EMPTY)
    squares <- rbind(squares, data.frame(x = p$x, y = p$y + 1, stringsAsFactors = FALSE))
  squares
}

moves_for <- function(map, ps) {
  squares <- NULL
  for (p in seq_len(nrow(ps))) squares <- rbind(squares, single_step(map, ps[p, ]))
  if (is.null(squares)) {
    NULL
  } else {
    unique(squares[order(squares$y, squares$x),])
  }
}

make_move <- function(game, pno, dist, char) {
  dist[dist<0] <- Inf
  squares <- single_step(game$map, game$players[pno, ])
  if (!is.null(squares)) {
    for (ts in seq_len(nrow(squares))) {
      squares$dist[ts] <- dist[squares$y[ts], squares$x[ts]]
    }
    squares <- squares[order(squares$dist, squares$y, squares$x), ]

    game$map[game$players$y[pno], game$players$x[pno]] <- EMPTY
    game$players$x[pno] <- squares$x[1]
    game$players$y[pno] <- squares$y[1]

    if (game$players$t[pno] == GOBLIN) {
      game$goblins$x[game$goblins$id == game$players$id[pno]] <- squares$x[1]
      game$goblins$y[game$goblins$id == game$players$id[pno]] <- squares$y[1]
    } else {
      game$elves$x[game$elves$id == game$players$id[pno]] <- squares$x[1]
      game$elves$y[game$elves$id == game$players$id[pno]] <- squares$y[1]
    }

    game$map[game$players$y[pno], game$players$x[pno]] <- char
  }
  game
}

turn <- function(game) {
  game$players <- game$players[order(game$players$y, game$players$x), ]
  game$elves <- game$players[game$players$t == ELF, ]
  game$goblins <- game$players[game$players$t == GOBLIN, ]

  p <- 1

  while (p <= nrow(game$players)) {
    i_am_elf <- (game$players$t[p] == ELF)
    target_squares <- NULL
    enemies <- game$elves
    if (i_am_elf) enemies <- game$goblins
    if (nrow(enemies) == 0) return(game)


    in_range <- any(  ((enemies$x == game$players$x[p]) &
                         (abs(enemies$y - game$players$y[p])==1)) |
                        ((enemies$y == game$players$y[p]) &
                           (abs(enemies$x - game$players$x[p])==1)))

    if (!in_range) {
      target_squares <- moves_for(game$map, enemies)
      if (!is.null(target_squares)) {
        if (nrow(target_squares)>0) {
          dist_from_me <- get_shortest_distance_map(game$map, game$players$x[p], game$players$y[p])
          for (ts in seq_len(nrow(target_squares))) {
            target_squares$dist[ts] <- dist_from_me[target_squares$y[ts], target_squares$x[ts]]
          }
          target_squares <- target_squares[target_squares$dist>=0, ]
          if (nrow(target_squares)>0) {
            target_squares <- target_squares[order(target_squares$dist, target_squares$y, target_squares$x),]
            dist_from_target <- get_shortest_distance_map(game$map, target_squares$x[1], target_squares$y[1])
            game <- make_move(game, p, dist_from_target, GOBLIN - i_am_elf)
          }
        }
      }
    }

    victims <- enemies[((enemies$x == game$players$x[p]) &
                        (abs(enemies$y - game$players$y[p])==1)) |
                     ((enemies$y == game$players$y[p]) &
                        (abs(enemies$x - game$players$x[p])==1)), ]

    if (nrow(victims)>=1) {
      victims <- victims[order(victims$hp, victims$y, victims$x), ]
      vid <- victims$id[1]
      vic <- which(game$players$id == vid)
      ap <- game$players$ap[p]
      game$players$hp[vic] <- game$players$hp[vic] - ap

      if (i_am_elf) game$goblins$hp[game$goblins$id == vid] <- game$goblins$hp[game$goblins$id == vid] - ap
      else game$elves$hp[game$elves$id == vid] <- game$elves$hp[game$elves$id == vid] - ap

      if (game$players$hp[vic] <= 0) {
        game$map[game$players$y[vic], game$players$x[vic]] <- EMPTY
        if (vic < p) p <- p - 1
        game$players <- game$players[game$players$id != victims$id[1], ]
        if (i_am_elf) game$goblins <- game$goblins[game$goblins$id != victims$id[1], ]
        else game$elves <- game$elves[game$elves$id != victims$id[1], ]
      }
    }
    p <- p + 1
  }
  game$turns <- game$turns + 1
  game
}


advent15a <- function(game) {
  game$turns <- 0
  while ((nrow(game$elves) * nrow(game$goblins))>0) {
    game <- turn(game)
    #message(sprintf("\nAfter turn %d: ", game$turns))
    #dump(game)
  }
  hp <- sum(game$players$hp)
  s <- "Elf"
  if (game$players$t[1] == GOBLIN ) s<- "Goblin"

  #message(sprintf("%s victory after %d complete turns. Hp left = %d. Result = %d\n",
                  #s, game$turns, hp, game$turns * hp))
  game$turns * hp
}

advent15b <- function() {
  ap <- 34
  game <- NULL
  while (TRUE) {
    game <- parse_input(readLines("../inputs/input_15.txt"))
    game$turns <- 0
    game$players$ap[game$players$t == ELF] <- ap
    orig_elves <- nrow(game$players[game$players$t == ELF, ])
    while ((nrow(game$elves) * nrow(game$goblins))>0) {
      game <- turn(game)

    }
    if (nrow(game$players[game$players$t == ELF, ]) < orig_elves) {
      message(sprintf("Final elves: %d", nrow(game$players[game$players$t == ELF, ])))
      ap <- ap + 1
    } else {
      h <- sum(game$players$hp[game$players$t == ELF])
      #message(sprintf("\nElves win with no fatalities, after %d turns. Total Hp = %d. Answer = %d",
       #               game$turns, h, game$turns*h))
      return(game$turns*h)
    }
  }

}

game <- parse_input(readLines("../inputs/input_15.txt"))
#message("Initialisation: ")
#dump(game)
c(advent15a(game), advent15b())
