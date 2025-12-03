d <- gsub("a ", "", gsub("[.]", "", gsub(",", "", gsub("nothing relevant.", "", 
  gsub("-compatible microchip","\tM", gsub(" generator", "\tG", 
    gsub("The (.*) floor contains ", "", gsub(", a ", "\t", gsub(" and a ", "\t", 
      readLines("../inputs/input_11.txt"))))))))))

encode <- function(state) {
  state$hash <- (state$gen - 1) + ifelse(!is.na(state$chip), 
                                         4 * (state$chip - 1), 0)
  sort_hash <- c(sort(state$hash[seq_len(nrow(state)-1)]),
                      state$hash[nrow(state)])
  res <- 0
  mul <- 1
  for (i in seq_along(sort_hash)) {
    res <- res + sort_hash[i] * mul
    mul <- mul * 16
  }
  res
}

solve <- function(part2 = FALSE) {
  chems <- sort(unique(unlist(lapply(seq_len(length(d)), 
    function(x) strsplit(d[x], "\t")))))
  chems <- chems[!chems %in% c("G", "M")]
  state <- data.frame(thing = chems, gen = NA, chip = NA)
  for (i in seq_len(nrow(state))) {
    state$gen[i] <- which(grepl(paste0(state$thing[i], "\tG"), d))
    state$chip[i] <- which(grepl(paste0(state$thing[i], "\tM"), d))
  }
  
  if (part2) {
    state <- rbind(state, data.frame(thing = c("elerium", "dilithium"), 
                                     gen = 1, chip = 1))
  }
  
  state <- rbind(state, data.frame(thing = "LIFT", gen = 1, chip = NA))
  history <- new.env(hash = TRUE, parent = parent.frame())
  assign(as.character(encode(state)), 0, envir = history)
  queue <- list()
  queue[[1]] <- list(state = state, n = 0)
  head <- 1
  tail <- 2
  target_state <- state
  target_state$gen <- 4
  target_state$chip[!is.na(target_state$chip)] <- 4
  target <- encode(target_state)
  
  viable <- function(newstate) {
    for (i in seq_len(nrow(newstate)-1)) {
      x <- newstate[i, ]
      if ((x$gen != x$chip) & (sum(newstate$gen[-nrow(newstate)] == x$chip, 
                                    na.rm = TRUE) > 0)) {
        return(FALSE)
      }
    }
    TRUE
  }
  
  while (TRUE) {
    S <- queue[[head]]
    head <- head + 1
    floor <- S$state$gen[nrow(S$state)]
    my_gens <- which(S$state$gen == floor & !is.na(S$state$chip))
    my_chips <- which(S$state$chip == floor)
    singles <- NULL
    if (length(my_gens) > 0) singles <- paste0("G", my_gens)
    if (length(my_chips) > 0) singles <- c(singles, paste0("C", my_chips))
    opts <- rbind(data.frame(A = singles, B = "Z"),
                  data.frame(A = singles,
                             B = rep(singles, each = length(singles))))
    opts <- opts[(opts$A != opts$B),]
    for (i in seq_len(nrow(opts))) {
      if (opts$A[i] > opts$B[i]) {
        z <- opts$A[i]
        opts$A[i] <- opts$B[i]
        opts$B[i] <- z
      }
    }
  
    opts <- unique(opts)
    
    range <- c(floor-1,floor+1)
    range <- range[range>=1 & range<=4]
    for (f in range) {
      for (j in seq_len(nrow(opts))) {
        N <- S
        N$n <- N$n + 1
        N$state$gen[nrow(N$state)] <- f
        for (obj in c("A", "B")) {
          ob <- opts[[obj]][j]
          if (ob != "Z") {
            type <- ifelse(substring(ob, 1, 1) == "G", "gen", "chip")
            num <- as.integer(substring(ob, 2))
            N$state[[type]][num] <- f
          }
        }
        new_encode <- encode(N$state)
        if (!exists(as.character(new_encode), envir = history)) {
          if (new_encode == target) {
            return(N$n)
          }
        
          if (viable(N$state)) {
            queue[[tail]] <- N
            tail <- tail + 1
          }
          assign(as.character(new_encode), 0, envir = history)
        }
      }
    }
  }
}

c(solve(), solve(TRUE))

