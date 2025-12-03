package d13;
import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  class Scanner {
    int range;
    int position;
    int dir;
    
    Scanner(int r, int p) {
      range = r;
      position = p;
      dir = 1;
    }
    
    void update() {
      if (position >= 0) {
        position = (position + dir);
        if ((position == 0) || (position == range - 1)) dir = -dir;        
      }
    }
  }
  
  ArrayList<Scanner> course = new ArrayList<Scanner>();
  
  void parse(ArrayList<String> input) {
    course.clear();
    int x=0;
    for (int i=0; i<input.size(); i++) {
      String[] s = input.get(i).split(": ");
      int xp = Integer.parseInt(s[0]);
      int xr = Integer.parseInt(s[1]);
      while (x < xp) {
        course.add(new Scanner(-1, -1));
        x++;
      }
      course.add(new Scanner(xr, 0));
      x++;
    }
  }
  
  int solve(boolean part2) {
    int x = 0;
    int penalty = 0;
    while (x < course.size()) {
      Scanner S = course.get(x);
      if (S.position == 0) {
        if (part2) return 999;
        penalty += (x * (S.range));
      }
      x++;
      for (int i=0; i<course.size(); i++) course.get(i).update();
    }
    return penalty;
  }
  
  int part1() {
    return solve(false);
  }
  
  int part2() {
    for (int i=0; i<course.size(); i++) {
      if (course.get(i).position >=0) { 
        course.get(i).position = 0;
        course.get(i).dir = 1;
      }
    }
    int[] mem_pos = new int[course.size()];
    int[] mem_dir = new int[course.size()];
    int delay = 0;
    
    while(true) {
      delay++;
      for (int i=0; i<course.size(); i++) {
        Scanner S = course.get(i);
        S.update();
        mem_pos[i]=S.position;
        mem_dir[i]=S.dir;
      }
      int pen = solve(true);
      if (pen == 0) return delay;
      for (int i=0; i<course.size(); i++) {
        Scanner S = course.get(i);
        S.position = mem_pos[i];
        S.dir = mem_dir[i];
      }
    }
  }
 
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parse(Utils.readLines("../inputs/input_13.txt"));
    System.out.println(w.part1());
    System.out.println(w.part2());
  }
}
