parse_file <- function(f = "../inputs/input_21.txt") {
  readLines(f)
}

nums <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A")
p_nums <- list(
  c("", "UL", "U", "UR", "UUL", "UU", "UUR", "UUUL", "UUU", "UUUR", "R"),
  c("RD", "", "R", "RR", "U", "UR", "URR", "UU", "UUR", "UURR", "RRD"),
  c("D", "L", "", "R", "LU", "U", "UR", "LUU", "UU", "UUR", "DR"),
  c("LD", "LL", "L", "", "LLU", "LU", "U", "LLUU", "LUU", "UU", "D"),
  c("RDD", "D", "DR", "DRR", "", "R", "RR", "U", "UR", "URR", "RRDD"),
  c("DD", "LD", "D", "DR", "L", "", "R", "LU", "U", "UR", "DDR"),
  c("LDD", "LLD", "LD", "D", "LL", "L", "", "LLU", "LU", "U", "DD"),
  c("RDDD", "DD", "DDR", "DDRR", "D", "DR", "DRR", "", "R", "RR", "RRDDD"),
  c("DDD", "LDD", "DD", "DDR", "LD", "D", "DR", "L", "", "R", "DDDR"),
  c("LDDD", "LLDD", "LDD", "DD", "LLD", "LD", "D", "LL", "L", "", "DDD"),
  c("L", "ULL", "LU", "U", "UULL", "LUU", "UU", "UUULL", "LUUU", "UUU", ""))

dirs <- c("L", "D", "R", "U", "A")
p_dirs <- list(
  c("", "R", "RR", "RU", "RRU"),
  c("L", "", "R", "U", "UR"),
  c("LL", "L", "", "LU", "U"),
  c("DL", "D", "DR", "", "R"),
  c("DLL", "LD", "D", "L", "")
)

get_path <- function(code, paths, ind) {
  code <- paste0(code, collapse = "")
  start <- "A"
  res <- c()
  for (i in seq_len(nchar(code))) {
    ch <- substring(code, i, i)
    res <- c(res, paste0(paths[[which(ind == start)]][which(ind == ch)], "A"))
    start <- ch
  }
  res
}

solve <- function(d, num = 25) {
  tot <- 0
  for (code in d) {
    p <- table(get_path(code, p_nums, nums))
    for (i in 1:num) {
      pnext = list()
      for (n in names(p)) {
        count <- as.numeric(p[[n]])
        p2 <- table(get_path(n, p_dirs, dirs))
        for (n2 in names(p2)) {
          if (n2 %in% names(pnext)) {
            pnext[[n2]] <- pnext[[n2]] + (count * p2[[n2]])
          } else {
            pnext[[n2]] <- (count * p2[[n2]])
          }
        }
      }
      p <- pnext
    }
    lgth <- unlist(lapply(names(p), nchar))
    p <- unlist(p) * lgth
    
    i <- as.integer(gsub("A", "", code))
    tot <- tot + i * sum(p)
  }
  tot
}

part1 <- function(d) solve(d, 2)
part2 <- function(d) solve(d, 25)

test <- function() {
  nc <- function(x) nchar(paste0(x, collapse = ""))
  
  prove_best <- function(m) {
    for (p in seq_along(m)) {
      paths <- m[[p]]
      for (q in seq_along(paths)) {
        path <- paths[[q]]
        orig <- path
        if (nchar(path) < 2) next
        c0 <- get_path(get_path(path, p_dirs, dirs), p_dirs, dirs)
        path <- table(strsplit(path, "")[[1]])
        if (length(path) == 1) next
        
        path1 <- paste0(c(rep(names(path)[1], path[1]),
                          rep(names(path)[2], path[2])), collapse = "")
        path2 <- paste0(c(rep(names(path)[2], path[2]),
                          rep(names(path)[1], path[1])), collapse = "")
        c1 <- nc(get_path(get_path(path1, p_dirs, dirs), p_dirs, dirs))
        c2 <- nc(get_path(get_path(path2, p_dirs, dirs), p_dirs, dirs))
        best <- min(c1, c2)
        if (best != nc(c0)) {
          message(sprintf("Check %s at %d, %d", orig, p, q))
        }
      }
    }
  }
  
  #prove_best(p_dirs)
  #prove_best(p_nums)
  
  stopifnot(nc(get_path("029A", p_nums, nums)) == 12)
  stopifnot(nc(get_path(get_path("029A", p_nums, nums), p_dirs, dirs)) == 28)
  stopifnot(nc(get_path(get_path(get_path("029A", p_nums, nums), 
                                p_dirs, dirs), p_dirs, dirs)) == 68)
                  
}

d <- parse_file()
c(part1(d), format(part2(d), digits = 16))
