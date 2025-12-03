package d17;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  byte[][] grid;
  final static byte SAND = 0;
  final static byte CLAY = 1;
  final static byte SPRING = 2;
  final static byte DRIP = 3;
  final static byte POOL = 4;
  final static char[] grid_chars = new char[] {'.', '#', '+', '|', '~'};
  int min_x = 500, min_y = Integer.MAX_VALUE;
  
  void parseInput(ArrayList<String> input) {
    int max_x = 500, max_y = Integer.MIN_VALUE;
    ArrayList<Integer> x = new ArrayList<Integer>();
    ArrayList<Integer> y = new ArrayList<Integer>();
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      boolean xfirst = s.startsWith("x");
      s = s.replaceAll("[xy= ]", "");
      s = s.replace("..",",");
      String[] bits = s.split(",");
      int i1 = Integer.parseInt(bits[0]);
      int i2 = Integer.parseInt(bits[1]);
      int i3 = Integer.parseInt(bits[2]);
      for (int j=i2; j<=i3; j++) {
        if (xfirst) {
          x.add(i1);
          y.add(j);
          max_x = Math.max(max_x, i1);
          min_x = Math.min(min_x, i1);
          max_y = Math.max(max_y, j);
          min_y = Math.min(min_y, j);
          
        } else {
          y.add(i1);
          x.add(j);
          max_x = Math.max(max_x, j);
          min_x = Math.min(min_x, j);
          max_y = Math.max(max_y, i1);
          min_y = Math.min(min_y, i1);
        }
      }
    }
    min_x--;
    max_x++;
    grid = new byte[max_y + 1][(max_x - min_x)];
    for (int i=0; i<x.size(); i++) grid[y.get(i)][x.get(i) - min_x] = CLAY;
    grid[0][500 - min_x] = SPRING;
  }
  
  void print() {
    System.out.println("");
    for (int j=0; j<grid.length; j++) {
      for (int i=0; i<grid[j].length; i++) {
        System.out.print(grid_chars[grid[j][i]]);
      }
      System.out.println("");
    }
  }
  
  void drip(int x, int y) {
    if ((x>=0) && (x<grid[0].length) && (y<grid.length-1)) {
      while ((y<grid.length-1) && (grid[y+1][x] == SAND)) grid[++y][x] = DRIP;
      
      if (y<grid.length-1) {
        if ((grid[y+1][x] == CLAY) || (grid[y+1][x] == POOL)) {
          int xl = x, xr = x;
          while ((xl>0) && (grid[y][xl] != CLAY) && ((grid[y+1][xl] == CLAY) || (grid[y+1][xl] == POOL))) xl--;
          while ((xr<grid[0].length-1) && (grid[y][xr] != CLAY) && ((grid[y+1][xr] == CLAY) || (grid[y+1][xr] == POOL))) xr++;
      
          while ((grid[y][xl] == CLAY) && (grid[y][xr] == CLAY)) { 
            for (int i=xl+1; i<=xr-1; i++) grid[y][i] = POOL;
            y--;
            xl = x;
            xr = x;
            while ((xl>0) && (grid[y][xl] != CLAY) && ((grid[y+1][xl] == CLAY) || (grid[y+1][xl] == POOL))) xl--;
            while ((xr<grid[0].length-1) && (grid[y][xr] != CLAY) && ((grid[y+1][xr] == CLAY) || (grid[y+1][xr] == POOL))) xr++;
          }
          for (int i=xl+1; i<xr; i++) grid[y][i] = DRIP;
          if (grid[y][xr]!=CLAY) drip(xr,y-1);
          if (grid[y][xl]!=CLAY) drip(xl,y-1);
        }
      }
    }
  }
  
  int countWater(boolean include_drips) {
    int x=0;
    for (int j=min_y; j<grid.length; j++) {
      for (int i=0; i<grid[j].length; i++) {
        if ((grid[j][i] == POOL) || ((include_drips) && grid[j][i] == DRIP)) x++;
      }
    }
    return x;
  }
  
  int advent17a() {
    drip(500 - min_x, 0);
    return countWater(true);
  }
  
  int advent17b() {
    return countWater(false);
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_17.txt"));
    System.out.println(w.advent17a());
    System.out.println(w.advent17b());
  }
}
