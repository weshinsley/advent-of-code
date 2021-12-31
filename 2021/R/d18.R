p0 <- function(x) paste0(x, collapse = "")

ss <- function(x) {
  x <- strsplit(x, "")[[1]]
  repeat {
    nums <- !x %in% c("[", "]", ",")
    reps <- which(diff(nums) == 0)
    reps <- reps[nums[reps]][1]
    if (is.na(reps[1])) break
    x[reps] <- p0(c(x[reps], x[reps + 1]))
    x <- x[-(reps + 1)]
  }
  x
}

read <- function(x) {
  lapply(readLines(x), ss)
}


explode <- function(x, test_single = FALSE) {
  leaf_depth <- x
  leaf_depth[leaf_depth %in% c(",", 0:9)] <- 0
  leaf_depth[leaf_depth == "["] <- 1
  leaf_depth[leaf_depth == "]"] <- -1
  leaf_depth <- cumsum(as.integer(leaf_depth))
  while (any(leaf_depth == 5)) {
    nums <- which(!x %in% c("[", "]", ","))
    start <- which(leaf_depth == 5)[[1]]
    left <- as.integer(x[start + 1])
    right <- as.integer(x[start + 3])
    next_right <- nums[nums > start + 3]
    prev_left <- nums[nums < start + 1]
    if (length(next_right) > 0) {
      next_right <- min(next_right)
      x[next_right] <- as.integer(x[start + 3]) + as.integer(x[next_right])
    }
    if (length(prev_left) > 0) {
      prev_left <- max(prev_left)
      x[prev_left] <- as.integer(x[start + 1]) + as.integer(x[prev_left])
    }
    
    x[start] <- "0"
    x <- x[-c((start + 1):(start+4))]
    leaf_depth[start] <- leaf_depth[start] - 1
    leaf_depth <- leaf_depth[-c((start + 1):(start+4))]
    if (test_single) break
  }
  x
}

split <- function(x) {
  nums <- which(!x %in% c("[", "]", ","))
  big <- nums[as.integer(x[nums]) >= 10]
  
  if (length(big) == 0) return(x)
  big <- min(big)
  v <- as.integer(x[big])
  x <- c(x[(1:(big-1))], "[", v %/% 2, ",", (v - (v %/% 2)), "]", 
         x[(big+1):length(x)])
  x
}

add <- function(x, y) {
  c("[", x, ",", y, "]")
}

reduce <- function(x) {
  repeat {
    x2 <- explode(x)
    x2 <- split(x2)
    if (identical(x, x2)) break
    x <- x2
  }
  x2
}

assemble <- function(x) {
  res <- reduce(x[[1]])
  for (i in 2:length(x)) {
    res <- reduce(add(res, x[[i]]))
  }
  res
}

magnitude <- function(x) {
  res <- 0
  x <- x[2:(length(x) - 1)]
  leaf_depth <- x
  leaf_depth[leaf_depth %in% c(",", 0:9)] <- 0
  leaf_depth[leaf_depth == "["] <- 1
  leaf_depth[leaf_depth == "]"] <- -1
  leaf_depth <- cumsum(as.integer(leaf_depth))
  comma <- which(x == "," & leaf_depth == 0)
  left <- x[1:(comma - 1)]
  right <- x[(comma + 1):length(x)]
  res <- res + 3 * (if ("," %in% left) magnitude(left) else as.integer(left))
  res <- res + 2 * (if ("," %in% right) magnitude(right) else as.integer(right))
  res
}

part1 <- function(d) { 
  magnitude(assemble(d)) 
}

part2 <- function(d) {
  max(unlist(lapply(seq_len(length(d)), function(x)
    lapply(seq_len(length(d)), function(y)
      if (x==y) 0 else magnitude(assemble(list(d[[x]], d[[y]])))))))
}

  

###############################################

tests <- function() {
  test_ex <- function(x, y) {
    identical(p0(explode(ss(x), test_single = TRUE)), y)
  } 

  stopifnot(test_ex("[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]"))
  stopifnot(test_ex("[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]"))
  stopifnot(test_ex("[7,[6,[5,[4,[3,2]]]]]", "[7,[6,[5,[7,0]]]]"))
  stopifnot(test_ex("[[6,[5,[4,[3,2]]]],1]", "[[6,[5,[7,0]]],3]"))
  stopifnot(test_ex("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"))
  stopifnot(test_ex("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"))

  test_split <- function(x, y) {
    identical(p0(split(ss(x))), y)
  }

  stopifnot(test_split("[[[[0,7],4],[15,[0,13]]],[1,1]]", "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"))
  stopifnot(test_split("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]", "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]"))

  test_add <- function(x, y, z) {
    identical(p0(add(ss(x), ss(y))), z)
  }
  
  stopifnot(test_add("[1,2]", "[[3,4],5]", "[[1,2],[[3,4],5]]"))

  test_reduce <- function(x, y) {
    identical(p0(reduce(ss(x))), y)
  }
          
  stopifnot(test_reduce(p0(add(ss("[[[[4,3],4],4],[7,[[8,4],9]]]"), ss("[1,1]"))), 
                "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"))

  test_assemble <- function(f, cmp) {
    res <- assemble(read(f))
    identical(p0(reduce(res)), cmp)
  }

  stopifnot(test_assemble("test1.txt", "[[[[1,1],[2,2]],[3,3]],[4,4]]"))
  stopifnot(test_assemble("test2.txt", "[[[[3,0],[5,3]],[4,4]],[5,5]]"))
  stopifnot(test_assemble("test3.txt", "[[[[5,0],[7,4]],[5,5]],[6,6]]"))
  stopifnot(test_assemble("test4.txt", "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"))
  stopifnot(test_assemble("test5.txt", "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"))

  test_mag <- function(x, y) {
    identical(magnitude(ss(x)), y)  
  }

  stopifnot(test_mag("[[9,1],[1,9]]", 129))
  stopifnot(test_mag("[[1,2],[[3,4],5]]", 143))
  stopifnot(test_mag("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384))
  stopifnot(test_mag("[[[[1,1],[2,2]],[3,3]],[4,4]]", 445))
  stopifnot(test_mag("[[[[3,0],[5,3]],[4,4]],[5,5]]", 791))
  stopifnot(test_mag("[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137))    
  stopifnot(test_mag("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]", 3488))
  stopifnot(test_mag("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]", 4140))

  d <- lapply(readLines("../inputs/d18-test5.txt"), ss)
  stopifnot(magnitude(assemble(d)) == 4140)
  stopifnot(part2(d) == 3993)
}

d <- lapply(readLines("../inputs/d18-input.txt"), ss)
part1(d)
part2(d)
