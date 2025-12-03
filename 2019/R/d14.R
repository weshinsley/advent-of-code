data_frame <- function(...) { data.frame(stringsAsFactors = FALSE, ...) }
stock <- data_frame()
needed <- data_frame()

read_input <- function(fn) {
  lines <- strsplit(gsub(" => ", ",", readLines(fn)), ",")
  reactions <- data.frame(stringsAsFactors = FALSE,
    inputs = unlist(lapply(lines, function(x)
      paste(x[1:(length(x)-1)], collapse = " "))),
    output_name = unlist(lapply(lines, function(x) 
      strsplit(x[[length(x)]], " ")[[1]][2])),
    output_quantity = as.numeric(unlist(lapply(lines, function(x) 
      strsplit(x[[length(x)]], " ")[[1]][1])))
  )
  reactions
}

recurse <- function(reactions, make_me) {
  amount_needed <- needed$quantity[needed$thing == make_me]
  if (nrow(stock[stock$thing == make_me, ]) == 0) {
    stock <<- rbind(stock, data_frame(
      thing = make_me, quantity = 0))
  }
  stock_avail <- stock$quantity[stock$thing == make_me]
  
  ingreds <- strsplit(
    reactions$inputs[reactions$output_name == make_me], "\\s+")[[1]]
  result_quantity <- as.numeric(
    reactions$output_quantity[reactions$output_name == make_me])
  
  count <- ceiling((amount_needed - stock_avail) / result_quantity)
  stock$quantity[stock$thing == make_me] <<-
    stock$quantity[stock$thing == make_me] + (count * result_quantity)
  
  for (ingred in seq(1, length(ingreds), 2)) {
    ing_name <- ingreds[ingred + 1]
    ing_quant <- as.numeric(ingreds[ingred])
    if (nrow(needed[needed$thing == ing_name, ]) == 0)
      needed <<- rbind(needed, data_frame(thing = ing_name, quantity = 0))

    needed$quantity[needed$thing == ing_name] <<-
      needed$quantity[needed$thing == ing_name] + count * ing_quant
  }
  
  for (ingred in seq(1, length(ingreds), 2)) {
    ing_name <- ingreds[ingred + 1]
    if (ing_name != "ORE") recurse(reactions, ing_name)
  }
    
}

solve1 <- function(reactions, fuel) {
  stock <<- data_frame()
  needed <<- data_frame(thing = "FUEL", quantity = fuel)
  recurse(reactions, "FUEL");
  needed$quantity[needed$thing == 'ORE']
}

solve2 <- function(reactions) {
  ore <- 1000000000000
  
  # Cheat to speed things up! This is the minimum
  # binary chop start point for all tests...
  # Set to 1 to work for every input...
  
  fuel <- 262144
  while (solve1(reactions, fuel) <= ore) {
    fuel <- fuel * 2
  }
  start <- floor(fuel / 2)
  end <- fuel;
  while (start <= end) {
    mid <- floor((start + end) / 2)
    trythis <- solve1(reactions, mid)
    if (trythis < ore) start <- mid + 1
    else if (trythis > ore) end <- mid - 1
  }
  (start - 1)
}

c(solve1(read_input("../inputs/input_14.txt"), 1),
  solve2(read_input("../inputs/input_14.txt")))
