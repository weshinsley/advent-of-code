d <- readLines("../inputs/input_21.txt")
maybe <- data.table::rbindlist(lapply(seq_len(length(d)),
  function(i) {
    line <- d[[i]]
    bits <- strsplit(line, " \\(contains ")[[1]]
    ings <- strsplit(bits[1], " ")[[1]]
    allergens <- strsplit(gsub(",", "", gsub(")", "", bits[[2]])), " ")[[1]]
    data.frame(line = i, ing = rep(ings, length(allergens)),
               allergen = rep(allergens, each = length(ings)))
  }                                  
))             
allergens <- data.frame(allergen = unique(maybe$allergen), ingred = NA)
ingred <- list()
for (a in allergens$allergen) {
  rows <- unique(maybe$line[maybe$allergen == a])
  ings <- maybe$ing[maybe$line == rows[1] & maybe$allergen == a]
  for (i in 2:length(rows)) {
    ings <- ings[ings %in% maybe$ing[maybe$line == rows[i]]]
  }
  ingred[[a]] <- ings
}

while (any(as.numeric(lapply(ingred, length)) > 0)) {
  single <- which(as.numeric(lapply(ingred, length)) == 1)[1]
  ing <-ingred[[single]]
  allergens$ingred[allergens$allergen == names(ingred[single])] <- ing
  for (o in seq_len(length(ingred))) {
    if (length(ingred[[o]]) > 0) {
      ingred[[o]] <- setdiff(ingred[[o]], ing)
    }
  }
}

p1 <- 0
for (i in seq_len(nrow(maybe))) {
  ings <- unique(maybe$ing[maybe$line == i])
  p1 <- p1 + length(ings[!ings %in% allergens$ingred])
}
allergens <- allergens[order(allergens$allergen),]
c(p1, paste0(allergens$ingred, collapse=","))
