parse_input <- function(f) {
  as.data.frame(read.table(f, sep = " ", col.names = c("cards", "bid")))
}

get_type <- function(s, p2 = FALSE) {
  s <- sort(strsplit(s, "")[[1]])
  tab <- table(s)
  tabi <- as.integer(tab)
  if (p2 && "J" %in% s) return(get_type_jok(tab, tabi))
  else if (length(tabi) == 1) 7                              # 88888
  else if (max(tabi) == 4) 6                                 # 88887
  else if ((max(tabi) == 3) && (length(tabi) == 2)) 5        # 88877
  else if (max(tabi) == 3) 4                                 # 88876
  else if (length(which(tabi == 2)) == 2) 3                  # 88776
  else if (2 %in% tabi) 2                                    # 88765
  else 1                                                     # 87654
}

get_type_jok <- function(tab, tabi) {
  if (length(tabi) == 1) 7                                    # JJJJJ or 88888
  else if (max(tabi) == 4) 7                                  # JJJJ8 or 8888J
  else if ((max(tabi) == 3) && (length(tabi) == 2)) 7         # JJJ88 or 888JJ
  else if (max(tabi) == 3) 6                                  # JJJ87 or 888J7
  else if (length(which(tabi == 2)) == 2)                     # JJ887 or 8877J
    (if (tabi[names(tab) == "J"] == 2) 6 else 5)
  else if (2 %in% tabi) 4                                     # JJ876 or 8876J
  else 2                                                      # J8765
}

get_tie <- function(s, p2 = FALSE) {
  card <- if (!p2)
    c("2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A") else
    c("J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A")

  swap <- letters[seq_along(card)]
  s <- strsplit(s, "")[[1]]
  paste0(swap[match(s, card)], collapse = "")
}

part1 <- function(d, p2 = FALSE) {
  d$type <- unlist(lapply(d$cards, function(x) get_type(x, p2)))
  d$tie <- unlist(lapply(d$cards, function(x) get_tie(x, p2)))
  d <- d[order(d$type, d$tie), ]
  d$rank <- seq_len(nrow(d))
  d$score <- d$rank * d$bid
  sum(d$score)
}

part2 <- function(d) {
  part1(d, TRUE)
}

d <- parse_input("../inputs/input_7.txt")
c(part1(d), part2(d))
