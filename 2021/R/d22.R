read_input <- function(f) {
  read.csv(text = gsub("on", "1", gsub("off", "0", gsub(" x=", ",", 
    gsub("\\.\\.", ",", gsub("y=", "",  gsub("z=", "", readLines(f))))))), header = FALSE, 
      col.names = c("state", "x1", "x2", "y1", "y2", "z1", "z2"))
}

part1 <- function(d) {
  cubes <- rep(0, 51*51*51)
  d <- d[d$x1 >= -50 & d$x2 <= 50 & d$y1 >= -50 & d$y2 <= 50 & d$z1 >= -50 & d$z2 <= 50, ]
  cubes <- array(0, c(101, 101, 101))

  for (i in seq_len(nrow(d))) {
    cube <- d[i, ]
    cubes[(cube$x1+51):(cube$x2+51),(cube$y1+51):(cube$y2+51),(cube$z1+51):(cube$z2+51)] <- cube$state
  }
  sum(cubes)
}

part2 <- function(d) {
  cubes <- list()
  nc <- 0
  
  # ARGH - everything off by 1
  d$x2 <- d$x2 + 1
  d$y2 <- d$y2 + 1
  d$z2 <- d$z2 + 1
  
  for (i in seq_len(nrow(d))) {
    new_cubes <- list()
    nc <- 0
    new <- d[i, ]
    for (j in seq_along(cubes)) {
      
      old <- cubes[[j]]
      # Does new cube j intersect with old cube i
      
      if ((new$x2 > old$x1) & (new$x1 < old$x2) &
          (new$y2 > old$y1) & (new$y1 < old$y2) &
          (new$z2 > old$z1) & (new$z1 < old$z2)) {
        
        # Slice the left-x section from the existing cube, so we
        # can leave it alone
        
        if (old$x1 < new$x1) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$x2 <- new$x1
          cubes[[j]]$x1 <- new$x1
          old$x1 <- new$x1
        }
        
        if (old$x2 > new$x2) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$x1 <- new$x2
          cubes[[j]]$x2 <- new$x2
          old$x2 <- new$x2
        }
        
        if (old$y1 < new$y1) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$y2 <- new$y1
          cubes[[j]]$y1 <- new$y1
          old$y1 <- new$y1
        }
        
        if (old$y2> new$y2) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$y1 <- new$y2
          cubes[[j]]$y2 <- new$y2
          old$y2 <- new$y2
        }
        if (old$z1 < new$z1) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$z2 <- new$z1
          cubes[[j]]$z1 <- new$z1
          old$z1 <- new$z1
        } 
        if (old$z2 > new$z2) {
          nc <- nc + 1
          new_cubes[[nc]] <- old
          new_cubes[[nc]]$z1 <- new$z2
          cubes[[j]]$z2 <- new$z2
          old$z2 <- new$z2
        }
      } else {
        nc <- nc + 1
        new_cubes[[nc]] <- old
      }
    }
    nc <- nc + 1
    new_cubes[[nc]] <- new
    
    cubes <- new_cubes
  }
  
  all_cubes <- data.table::rbindlist(cubes)
  
  all_cubes <- all_cubes[all_cubes$state == 1, ]
  all_cubes$vol <- 0
  all_cubes$xd <- all_cubes$x2 - all_cubes$x1
  all_cubes$yd <- all_cubes$y2 - all_cubes$y1
  all_cubes$zd <- all_cubes$z2 - all_cubes$z1
  all_cubes$xx <- all_cubes$xd * all_cubes$yd * all_cubes$zd
  return(sum(all_cubes$xx))

}

d <- data.frame(state = c(1, 0), x1 = c(1,2), y1 = c(1,2), x2 = c(2,3), y2 = c(2,3),
                 z1 = c(1,2), z2 = c(2,3))
d <- read_input("../inputs/input_22.txt")
options(digits=14)
c(part1(d), part2(d))
