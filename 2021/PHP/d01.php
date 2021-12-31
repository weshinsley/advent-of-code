<?php
 
  function parse_file($d) {
    $ds = explode("\n", $d);
    foreach ($ds AS $index => $value)
      $ds[$index] = (int) $value; 
    return $ds;
  }

  function solve($d,$lag) {
    $res = 0;
    for ($i = $lag; $i < count($d); $i++)
      $res = $res + ($d[$i] > $d[$i - $lag] ? 1 : 0);
    return $res;
  }

  $d = parse_file("199\n200\n208\n210\n200\n207\n240\n269\n260\n263");
  if (solve($d,1) != 7) exit("Test 1 not 7");
  if (solve($d,3) != 5) exit("Test 2 not 5");

  $d = parse_file(file_get_contents("../inputs/d01-input.txt"));
  echo ("Part 1: ".solve($d, 1). "   Part 2: ".solve($d, 3)."\n");

?>