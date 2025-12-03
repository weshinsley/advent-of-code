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

  $d = parse_file(file_get_contents("../inputs/input_1.txt"));
  echo ("Part 1: ".solve($d, 1). "   Part 2: ".solve($d, 3)."\n");

?>