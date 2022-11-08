package d14;

import java.math.BigInteger;

import tools.Utils;

public class wes {
  int[][] map = new int[128][128];
  
  int part1(String input) {
    int count = 0;
    d10.wes d10 = new d10.wes();
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
  
  void test() throws Exception {
    Utils.test(part1("flqrgnkx"), 8108);
    Utils.test(part2(), 1242);
  }
  
  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    String input = Utils.readLines("../R/14/input.txt").get(0);
    System.out.println(w.part1(input));
    System.out.println(w.part2());
  }
}
