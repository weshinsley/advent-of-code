d <- read.csv("../inputs/input_15.txt", sep=" ", header = FALSE)[, c(3,5,7,9,11)]
names(d) <- c("cap", "dur", "flav", "tex", "cal")
for (n in names(d)) {
  d[[n]] <- as.integer(gsub(",","",d[[n]]))
}

g <- data.frame(a = 1:97, b = rep(1:97, each = 97), c = rep(1:97, each = 9409))
g <- g[g$a + g$b + g$c < 100, ]
g$d <- 100 - (g$a + g$b + g$c)

g$cap <-  pmax(0, g$a*d$cap[1] +  g$b*d$cap[2] +  g$c*d$cap[3] +  g$d*d$cap[4])
g$dur <-  pmax(0, g$a*d$dur[1] +  g$b*d$dur[2] +  g$c*d$dur[3] +  g$d*d$dur[4])
g$flav <- pmax(0, g$a*d$flav[1] + g$b*d$flav[2] + g$c*d$flav[3] + g$d*d$flav[4])
g$tex <-  pmax(0, g$a*d$tex[1] +  g$b*d$tex[2] +  g$c*d$tex[3] +  g$d*d$tex[4])
g$cal <-  pmax(0, g$a*d$cal[1] +  g$b*d$cal[2] +  g$c*d$cal[3] +  g$d*d$cal[4])
g$score <- g$cap * g$dur * g$flav * g$tex

c(max(g$score), max(g$score[g$cal == 500]))
