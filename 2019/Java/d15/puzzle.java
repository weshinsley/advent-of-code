package d15;

import java.util.ArrayList;
import d09.wes_computer;

public class puzzle {
  final static int NORTH = 1;
  final static int SOUTH = 2;
  final static int WEST = 3;
  final static int EAST = 4;
  
  final static int WALL = 0;
  final static int OXYGEN = 2;
  
  final static int CH_UNEXPLORED = -1;
  final static int CH_WALL = -2;
  
  final static int[] dx = new int[] {999, 0,0,-1,1};
  final static int[] dy = new int[] {999, -1,1,0,0};
  final static int[] reverse = new int[] {999, SOUTH, NORTH, EAST, WEST};
  
  ArrayList<ArrayList<Integer>> infinite_map;
  int droidx=0;
  int droidy=0;
  int oxygenx=0;
  int oxygeny=0;
  
  void ensure_size(int x, int y) {
    int wid = infinite_map.get(0).size();
    int hei = infinite_map.size();
    
    if (x < 0) { 
      for (int j=0; j < hei; j++) infinite_map.get(j).add(0, CH_UNEXPLORED); 
      droidx++;
      oxygenx++;
    
    } else if (y < 0) {
      ArrayList<Integer> newline = new ArrayList<Integer>();
      for (int i=0; i<wid; i++) newline.add(CH_UNEXPLORED);
      infinite_map.add(0, newline);
      droidy++;
      oxygeny++;
      
    } else if (x >= wid) {
      for (int j=0; j<hei; j++) infinite_map.get(j).add(CH_UNEXPLORED);
     
    } else if (y >= hei) {
      ArrayList<Integer> newline = new ArrayList<Integer>();
      for (int i=0; i<wid; i++) newline.add(CH_UNEXPLORED);
      infinite_map.add(newline);
    }
  }
  
  void explore(wes_computer wc, int direction, int step_no) {
    ensure_size(droidx+dx[direction], droidy+dy[direction]);
    int ch = infinite_map.get(droidy+dy[direction]).get(droidx+dx[direction]);
    if ((ch == CH_UNEXPLORED) || (ch > step_no)) {
      wc.add_input(direction);
      wc.run();
      int result = (int) wc.read_output();
      if (result == WALL) infinite_map.get(droidy+dy[direction]).set(droidx+dx[direction], CH_WALL);
      else {
        droidx += dx[direction];
        droidy += dy[direction];
        infinite_map.get(droidy).set(droidx, step_no + 1);
        if (result == OXYGEN) {
          oxygenx = droidx;
          oxygeny = droidy;
        }
        for (int i=1; i<=4; i++) {
          if (i != reverse[direction]) explore(wc, i, step_no + 1);
        }
        wc.add_input(reverse[direction]);
        wc.run();
        wc.read_output();
        droidx -= dx[direction];
        droidy -= dy[direction];
      }      
    }
  }
  
  int max_steps = 0;
  
  int solve2(int x, int y, int step) {
    max_steps = Math.max(max_steps,  step);
    infinite_map.get(y).set(x, 0);
    for (int i=1; i<=4; i++) {
      int scan = infinite_map.get(y+dy[i]).get(x+dx[i]);
      if (scan>0) solve2(x+dx[i], y+dy[i], step + 1);
    }
    return max_steps;
  }
  
  int solve(wes_computer wc) {
    infinite_map = new ArrayList<ArrayList<Integer>>();
    infinite_map.add(new ArrayList<>());
    infinite_map.get(0).add(0);
    droidx = 0;
    droidy = 0;
    oxygenx = droidx;
    oxygeny = droidy;
    for (int i=NORTH; i<=WEST; i++) explore(wc, i, 0);
    return infinite_map.get(oxygeny).get(oxygenx);
  }
  
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve(wes_computer.wc_from_input("../inputs/input_15.txt")));
    System.out.println("Part 2: "+W.solve2(W.oxygenx, W.oxygeny, 0));
    
  }
}
