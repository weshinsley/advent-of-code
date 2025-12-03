package d02;

import java.util.Arrays;

import tools.*;

public class puzzle {

  public int part1(int[][] d) {
    int sum=0;
    for (int row = 0; row < d.length; row++) {
      Arrays.sort(d[row]);
      sum += d[row][d[row].length-1] - d[row][0];
    }
    return sum;
  }
  
  public int part2(int[][] d) {
    int sum = 0;
    for (int row = 0; row < d.length; row++) {
      Arrays.sort(d[row]);
      for (int i = d[row].length - 1; i > 0; i--) {
        for (int j = i - 1; j >= 0; j--) {
          if (d[row][i] % d[row][j] == 0) {
            sum += d[row][i] / d[row][j];
            j = 0;
            i = 0; 
          }
        }
      }
    }
    return sum;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    int[][] data_rc = Utils.readIntGrid_ji("../inputs/input_2.txt", "\\s+");
    System.out.println(w.part1(data_rc));
    System.out.println(w.part2(data_rc));
  }
}
