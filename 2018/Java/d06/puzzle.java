package d06;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  int[] x;
  int[] y;
  int min_x = Integer.MAX_VALUE, min_y = Integer.MAX_VALUE;
  int max_x = Integer.MIN_VALUE, max_y = Integer.MIN_VALUE;
  int[][] grid;

  void parseInput(ArrayList<String> s) {
    x = new int[s.size()];
    y = new int[s.size()];
    for (int i=0; i<s.size(); i++) {
      x[i] = Integer.parseInt(s.get(i).split(",")[0]);
      y[i] = Integer.parseInt(s.get(i).split(",")[1].trim());
      if (x[i] < min_x) min_x = x[i];
      if (x[i] > max_x) max_x = x[i];
      if (y[i] < min_y) min_y = y[i];
      if (y[i] > max_y) max_y = y[i];
    }
    grid = new int[max_y+1][];
    for (int j = 0; j <= max_y; j++) {
      grid[j] = new int[max_x+1];
    }
  }
  
  int closest(int i, int j) {
    int best = Math.abs(x[0] - i) + Math.abs(y[0] - j);
    int best_index = 1;
    boolean equal_flag = false;
    
    for (int n = 1; n < x.length; n++) {
      int d = Math.abs(x[n] - i) + Math.abs(y[n] - j);
      if (d == best) equal_flag = true;
      else if (d < best) {
        equal_flag = false;
        best = d; 
        best_index = n + 1;
      }
    }
    return !equal_flag?(best_index):0;
  }
  
  int advent6a() {
    for (int j = min_y; j <= max_y; j++)
      for (int i = min_x; i <= max_x; i++)
        grid[j][i] = closest(i, j);

    boolean[] infinite = new boolean[x.length];
    int v = 0;

    for (int  i =-1; i<=max_x+1; i++) {
      v = closest(i, 0) - 1;           if (v >= 0) infinite[v] = true;
      v = closest(i, max_y + 1) - 1;   if (v >= 0) infinite[v] = true;
    }

    for (int j = -1; j <= max_y + 1; j++) {
      v = closest(0, j) - 1;           if (v >= 0) infinite[v] = true;
      v = closest(max_x + 2, j) - 1;   if (v >= 0) infinite[v] = true;
    }
    int best=0;
    for (int i = 0; i < x.length; i++) {
      if (!infinite[i]) {
        int area = WesUtils.count2d(grid, i + 1);
        if (area > best) best = area;
      }
    }
    return best;
  }
  
  int advent6b() {
    int r=0;
    for (int j = min_y; j <= max_y; j++) 
      for (int i = min_x; i <= max_x; i++) { 
        int d=0;
        for (int n = 0; n < x.length; n++) {
          d += Math.abs(x[n] - i) + Math.abs(y[n] - j);
          if (d >= 10000) break;
        }
        if (d < 10000) r++;
      }
    return r;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    long time = - System.currentTimeMillis();
    w.parseInput(WesUtils.readLines("../inputs/input_6.txt"));
    time += System.currentTimeMillis();
    System.out.println("Setup : "+time+" ms");
    time = - System.currentTimeMillis();
    System.out.print(w.advent6a());
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" ms)");;
    time = - System.currentTimeMillis();
    System.out.print(w.advent6b());
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" ms)");
    
  }
}
