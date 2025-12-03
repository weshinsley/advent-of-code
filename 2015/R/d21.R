shop <- data.frame(
  cost = c(8,10,25,40,74,13,31,53,75,102,0,25,50,100,20,40,80,0,0),
  dmg = c(4,5,6,7,8,0,0,0,0,0,0,1,2,3,0,0,0,0,0),
  arm = c(0,0,0,0,0,1,2,3,4,5,0,0,0,0,1,2,3,0,0),
  type = c(1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,3,3))
shop <- split(shop, shop$type)

d <- read.csv(text = readLines("../inputs/input_21.txt"), sep = ":", 
              header = FALSE, col.names = c("n", "v"))
enemy <- data.frame(
  hp = d$v[d$n == "Hit Points"],
  dmg = d$v[d$n == "Damage"],
  arm = d$v[d$n == "Armor"])

solve <- function() {
  nwea <- nrow(shop[[1]])
  narm <- nrow(shop[[2]])
  nrng <- nrow(shop[[3]])
  tries <- data.frame(
    wea = rep(seq_len(nwea), each = narm * nrng * nrng),
    arm = rep(seq_len(narm), each = nrng * nrng),
    r1 = rep(seq_len(nrng), each = nrng),
    r2 = seq_len(nrng)
  )
  tries <- tries[tries$r2 > tries$r1,]
  tries$cost <- shop[[1]]$cost[tries$wea] + shop[[2]]$cost[tries$arm] + 
                shop[[3]]$cost[tries$r1] + shop[[3]]$cost[tries$r2]
  tries$tdmg <- shop[[1]]$dmg[tries$wea] +  
              shop[[3]]$dmg[tries$r1] + shop[[3]]$dmg[tries$r2]
  tries$tarm <- shop[[2]]$arm[tries$arm] +  
                shop[[3]]$arm[tries$r1] + shop[[3]]$arm[tries$r2]
  tries$win <- pmax(1, tries$tdmg - enemy$arm) >= pmax(1, enemy$dmg - tries$tarm)
  c(min(tries$cost[tries$win]), max(tries$cost[!tries$win]))
}  
  
solve()
