<?php

  function solve($d, $p) {
    $d = explode("\n", $d);
    $hrz = 0;
    $dep = 0;
    $aim = 0;
    for ($i = 0; $i < count($d); $i++) {
      $cmd = explode(" ", $d[$i]);
      if (count($cmd) < 2) continue;
      $val = intval($cmd[1]);
      $cmd = $cmd[0];
      if ($cmd == "forward") $hrz = $hrz + $val;
      if ($p == 1) {
        if ($cmd == "up") $dep = $dep - $val;
        else if ($cmd == "down") $dep = $dep + $val;
      } else {
        if ($cmd == "forward") $dep = $dep + ($aim * $val);
        else if ($cmd == "up") $aim = $aim - $val;
        else $aim = $aim + $val;
      }
    }
    return $dep * $hrz;
  }

  $d = file_get_contents("../inputs/d02-test.txt");
  if (solve($d, 1) != 150) exit("Test 1 not 150");
  if (solve($d, 2) != 900) exit("Tets 2 not 900");

  $d = file_get_contents("../inputs/d02-input.txt");
  echo ("Part 1: ".solve($d, 1)."   Part 2: ".solve($d, 2)."\n");

?>