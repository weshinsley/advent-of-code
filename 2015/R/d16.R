df <- data.frame(Sue = 0, children = NA, cats = NA, samoyeds = NA, pomeranians = NA,
                 akitas = NA, vizslas = NA, goldfish = NA, trees = NA,
                 cars = NA, perfumes = NA)

d <- data.table::rbindlist(lapply(readLines("../inputs/input_16.txt"), 
  function(x) {
    sx <- gsub(" ", "", strsplit(x, "[:,]")[[1]])
    sx[1] <- as.integer(gsub("Sue", "", sx[1]))
    row <- df[df$Sue == 0, ]
    row$Sue <- as.integer(sx[1])
    for (i in seq(2, length(sx), by = 2)) {
      row[[sx[i]]] <- as.integer(sx[i+1])
    }
    row
  }
))

ish <- function(x, y, func = `==`) {
  is.na(x) | func(x, y)
}

d <- d[ish(d$children, 3) & ish(d$samoyeds, 2) & ish(d$akitas, 0) & 
       ish(d$vizslas, 0) & ish(d$cars, 2) & ish(d$perfumes, 1), ]

c(d$Sue[ish(d$cats, 7) & ish(d$pomeranians, 3) & 
        ish(d$goldfish, 5) & ish(d$trees,3)],
  d$Sue[ish(d$cats, 7, `>`) & ish(d$pomeranians, 3, `<`) & 
        ish(d$goldfish, 5, `<`) & ish(d$trees,3, `>`)])
