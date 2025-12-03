package d03;

import java.util.ArrayList;
import tools.WesUtils;

public class puzzle {
  ArrayList<String> input;
  
  int advent3(boolean part_a) {
    boolean[] overlap = new boolean[input.size() + 1];
    int count = 0;
    
    ArrayList<ArrayList<Integer>> grid = WesUtils.newGrid();
    
    for (int c = 0; c < input.size(); c++) {
      String[] bits = input.get(c).replaceAll("[#@,:x]"," ").trim().split("\\s+");
      int x = Integer.parseInt(bits[1]);
      int y = Integer.parseInt(bits[2]);
      int w = Integer.parseInt(bits[3]);
      int h = Integer.parseInt(bits[4]);
      WesUtils.resize(grid, x + w, y + h);
      for (int i = x; i < x + w; i++) {
        for (int j = y; j < y + h; j++) {
          int v = grid.get(j).get(i);
          
          if (part_a) {
            if (v == 1) count++;
            grid.get(j).set(i, v+1);
              
          } else {
            if (v != 0) {
              overlap[v] = true;
              overlap[c + 1] = true;
            }
            grid.get(j).set(i, c + 1);
          }
        }
      }
    }

    if (part_a) return count;
    for (int i=1; i<=input.size(); i++) {
      if (!overlap[i]) return i;
    }
    return -1;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.input = WesUtils.readLines("../inputs/input_3.txt");
    System.out.println(w.advent3(true));
    System.out.println(w.advent3(false));
  }
}
