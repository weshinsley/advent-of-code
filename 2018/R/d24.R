IMMUNE <- 1
INFECTION <- 2
TYPES <- c("bludgeoning", "radiation", "slashing", "fire", "cold")
binary <- c(1,2,4,8,16)

parse_input <- function(file) {
  id <- 0
  input <- readLines(file)
 
  army <- NA
  groups <- data.frame()

  for  (s in input) {

    if (s == "Immune System:") army <-IMMUNE

    else if (s == "Infection:") army <- INFECTION

    else if (length(grep("units each with", s)) >= 1) {
      units <- as.integer(substr(s, 1, regexpr("units each with", s)[1]-2))
      s <- substring(s, regexpr("units each with", s)[1]+16)
      hp <- as.integer(substr(s, 1, regexpr(" ",s)[1]-1))
      s <- substring(s, regexpr("hit points ", s)[1] + 11)

      weak <- 0
      immune <- 0
      if (substr(s, 1, 1) == "(") {
        bits <- unlist(strsplit(substr(s, 2, regexpr(")", s)[1]-1), "; "))
        for (bit in bits) {
          if (regexpr("weak to", bit)[1] == 1) {
            types <- unlist(strsplit(substring(bit, 9), ",\\s+"))
            weak <- weak + sum(binary[match(types, TYPES)])
          } else if (regexpr("immune to", bit)[1] == 1) {
            types <- unlist(strsplit(substring(bit, 11), ",\\s+"))
            immune <- immune + sum(binary[match(types, TYPES)])
          }
        }

        s <- substring(s,regexpr(")", s)[1] + 27) 
      } else {
        s <- substring(s, 26)
      }

      attack_damage <- as.integer(substr(s, 1, regexpr(" ",s)[1]-1))
      s <- substring(s, regexpr(" ", s)[1] + 1)
      attack_type <- which (TYPES == substr(s, 1, regexpr(" ",s)[1]-1))
      s <- substring(s, regexpr(" ",s)[1] + 22)
      initiative <- as.integer(s)
      id <- id + 1
      groups <- rbind(groups, data.frame(
        id = id,
        army = army, units = units,
        hits = hp,   attack_type = attack_type,
        attack_damage = attack_damage, weak = weak, immune = immune,
        initiative = initiative,
        stringsAsFactors = FALSE))

    }
  }
  groups
}

targeting <- function (groups, att) {
  groups$eff_power <- groups$units * groups$attack_damage
  attackers <- groups[groups$army == att, ]
  defenders <- groups[groups$army != att, ]
  attackers <- attackers[order(attackers$eff_power, attackers$initiative, decreasing = TRUE), ]

  for (a in seq_len(nrow(attackers))) {
    attacker <- attackers[a, ]
    defenders$damage <- attacker$eff_power *
      (1 + (bitwAnd(defenders$weak, binary[attacker$attack_type])>0)) *
      (1 - (bitwAnd(defenders$immune, binary[attacker$attack_type])>0))

    defenders <- defenders[order(defenders$damage, defenders$eff_power, 
                                 defenders$initiative, decreasing = TRUE),]

    if ((nrow(defenders) >= 1) && (defenders$damage[1] >= 1)) {
      groups$damage[groups$id == defenders$id[1]] <- defenders$damage[1]
      target_id <- defenders$id[1]
      groups$target[groups$id == attacker$id] <- target_id
      defenders <- defenders[defenders$id != target_id, ]
    }
  }
  groups
}

attack <- function(groups) {
  groups <- groups[order(groups$initiative, decreasing = TRUE),]

  for (a in seq_len(nrow(groups))) {
    attacker <- groups[a, ]
    target <- groups[groups$id == attacker$target, ]

    if (!is.na(attacker$target)) {
      damage <- attacker$units * attacker$attack_damage *
        (1 + (bitwAnd(target$weak, binary[attacker$attack_type])>0)) *
        (1 - (bitwAnd(target$immune, binary[attacker$attack_type])>0))

      damage <- damage %/% target$hits
      units <- max(0, target$units - damage)
      groups$units[groups$id == target$id] <- units
    }
  }
  groups
}

runner <- function(file, boost) {
  groups <- parse_input(file)
  groups$attack_damage[groups$army == IMMUNE] <- groups$attack_damage[groups$army == IMMUNE] + boost
  while (TRUE) {
    units_pre <- sum(groups$units)
    groups$target <- NA
    groups$damage <- 0
    groups <- targeting(groups, IMMUNE)
    groups <- targeting(groups, INFECTION)
    groups <- attack(groups)
    groups <- groups[groups$units > 0, ]

    units_post <- sum(groups$units)

    if (units_pre == units_post) {
      return(-1)
    } else if (sum(groups$units[groups$army == IMMUNE]) == 0) {
      return(list(INFECTION, units_post))
    } else if (sum(groups$units[groups$army == INFECTION]) == 0) {
      return(list(IMMUNE, units_post))
    }
  }
}

advent24a <- function(file) {
  runner(file, 0)[[2]]
}

advent24b <- function(file) {
  boost <- 1
  while (TRUE) {
    res <- runner(file, boost)
    if (res[[1]] == IMMUNE) {
      return(res[[2]])
    }
    boost <- boost + 1
  }
}

c(advent24a("../inputs/input_24.txt"), advent24b("../inputs/input_24.txt"))
