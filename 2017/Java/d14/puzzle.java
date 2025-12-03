package d14;

import java.math.BigInteger;

import tools.Utils;

public class puzzle {
  int[][] map = new int[128][128];
  
  int part1(String input) {
    int count = 0;
    d10.puzzle d10 = new d10.puzzle();
    for (int row = 0; row < 128; row++) {
      String s = new BigInteger(d10.part2(input + "-" + row), 16).toString(2);
      while (s.length()<128) s = "0" + s;
      for (int col = 0; col < 128; col++) {
        map[row][col] = (s.charAt(col) == '1') ? 1 : 0;
        count += map[row][col];
      }
    }
    return count;
  }
  
  void fill(int r, int c) {
    if ((r<0) || (r>127) || (c<0) || (c>127)) return;
    if (map[r][c] == 0) return;
    map[r][c] = 0;
    fill(r-1, c);
    fill(r+1, c);
    fill(r, c-1);
    fill(r, c+1);
  }
  
  int part2() {
    int groups = 0;
    for (int row = 0; row < 128; row++) {
      for (int col = 0; col < 128; col++) {
        if (map[row][col] == 1) {
          groups++;
          fill(row, col);
        }
      }
    }
    return groups;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    String input = Utils.readLines("../inputs/input_14.txt").get(0);
    System.out.println(w.part1(input));
    System.out.println(w.part2());
  }
}
