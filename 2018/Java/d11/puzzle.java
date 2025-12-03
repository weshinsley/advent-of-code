package d11;

import tools.WesUtils;

public class puzzle {
  int[][][] grid = new int[301][301][2];
    
  void init(int serial) {
    for (int j = 1; j < 301; j++)
      for (int i = 1; i < 301; i++)
        grid[i][j][0] = ((((((i + 10) * j) + serial) * (i + 10)) / 100) % 10) - 5; 
  }

  void advent11(int max_size, boolean search) {
    int max = Integer.MIN_VALUE, max_i = 0, max_j = 0, best_size = 0;
    int start = (search) ? 1 : max_size;
    for (int size = start; size <= max_size; size++)
      for (int j = 1; j <= 301 - size; j++) 
        for (int i = 1; i <= 301 - size; i++) { 
          int power = 0;
          if (size == start) {
            for (int ii = 0; ii < size; ii++) for (int jj = 0; jj < size; jj++) power += grid[i + ii][j + jj][0];
            grid[i][j][1] = power;
          } else {
            power = grid[i][j][1];
            for (int ii = 0; ii < size; ii++) power += grid[i + ii][j + size - 1][0];
            for (int jj = 0; jj < size-1; jj++) power += grid[i + size - 1][j + jj][0];
            grid[i][j][1]=power;
          }
          if (power > max) { max = power; max_i = i; max_j = j; best_size = size; }
        }
    System.out.println(max_i + "," + max_j + (search ? "," + best_size : ""));
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.init(Integer.parseInt(WesUtils.readLines("../inputs/input_11.txt").get(0)));
    w.advent11(3, false);
    w.advent11(300, true);
  }
}
