package d06;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  public static int advent6(ArrayList<String> data, int rules) {
    int[][] grid = Utils.createIntGrid(1000,1000);
    for (int i=0; i<data.size(); i++) {
      String s = data.get(i);
      s = s.replace("turn on", "turn_on");
      s = s.replace("turn off", "turn_off");
      String[] bits = s.split("\\s+");
      String[] coord1 = bits[1].split(",");
      String[] coord2 = bits[3].split(",");
      int x1 = Integer.parseInt(coord1[0]);
      int y1 = Integer.parseInt(coord1[1]);
      int x2 = Integer.parseInt(coord2[0]);
      int y2 = Integer.parseInt(coord2[1]);
  
      for (int x = Math.min(x1,x2); x <= Math.max(x1,x2); x++) {
        for (int y = Math.min(y1, y2); y <= Math.max(y1, y2); y++) {
          if (rules == 1) {
            if (bits[0].equals("toggle")) grid[y][x] = 1 - grid[y][x];
            else if (bits[0].equals("turn_on")) grid[y][x] = 1;
            else if (bits[0].equals("turn_off")) grid[y][x] = 0;
          } else if (rules == 2) {
            if (bits[0].equals("toggle")) grid[y][x] += 2;
            else if (bits[0].equals("turn_on")) grid[y][x] += 1;
            else if (bits[0].equals("turn_off")) grid[y][x] = Math.max(0, grid[y][x] - 1);
          }
        }
      }
    }
    return Utils.sum(grid);
    
  }
  public static void main(String[] args) throws Exception {
    ArrayList<String> data = Utils.readLines("../inputs/input_6.txt");
    System.out.println(advent6(data,1));
    System.out.println(advent6(data,2));
  }
}
