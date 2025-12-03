package d10;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  ArrayList<Integer> px = new ArrayList<Integer>();
  ArrayList<Integer> py = new ArrayList<Integer>();
  ArrayList<Integer> vx = new ArrayList<Integer>();
  ArrayList<Integer> vy = new ArrayList<Integer>();
  int range_x = Integer.MAX_VALUE;
  int range_y = Integer.MAX_VALUE;
  int min_x, min_y, max_x, max_y;
  
  void parseInput(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      px.add(Integer.parseInt(s.substring(10, 16).trim()));
      py.add(Integer.parseInt(s.substring(18, 24).trim()));
      vx.add(Integer.parseInt(s.substring(36, 38).trim()));
      vy.add(Integer.parseInt(s.substring(40, 42).trim()));
    }
  }
  
  void print() {
    StringBuilder[] grid = new StringBuilder[range_y + 1];
    for (int j=0; j<=range_y; j++) {
      grid[j] = new StringBuilder();
      for (int i=0; i<=range_x; i++)
        grid[j].append(".");
    }
    
    for (int i=0; i<px.size(); i++) {
      grid[py.get(i)-min_y].setCharAt(px.get(i)-min_x,'#');
    }
    for (int j=0; j<=range_y; j++) System.out.println(grid[j].toString());
    System.out.print("\n");
  }
  
  void update(boolean reverse) {
    int dir = (reverse)?-1:1;
    for (int i=0; i<px.size(); i++) {
      px.set(i, px.get(i) + (dir * vx.get(i)));
      py.set(i, py.get(i) + (dir * vy.get(i)));
    }
    min_x = WesUtils.min(px);
    max_x = WesUtils.max(px);
    min_y = WesUtils.min(py);
    max_y = WesUtils.max(py);
  }
  
  int steps() {
    int steps=0;
    while (true) {
      update(false);
      int new_range_x = max_x-min_x;
      int new_range_y = max_y-min_y;
      if ((new_range_x > range_x) && (new_range_y > range_y)) {
        update(true);
        break;
      }
      range_x = new_range_x;
      range_y = new_range_y;
      steps++;
    }
    return steps;
  }
  
  int advent10b() {
    return 0;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_10.txt"));
    int steps = w.steps();
    w.print();
    System.out.println(steps);
    
  }
}
