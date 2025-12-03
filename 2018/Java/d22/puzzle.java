package d22;

import java.awt.Point;
import java.util.ArrayDeque;
import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  int depth;
  Point target;
  static final String[] types = new String[] {"rocky", "wet", "narrow"};
  static final char[] ch_types = new char[] {'.', '=', '|'};
  static int SPLATTER = 100;
  int[][] type;
  
  // Note order: you can't have NEITHER in ROCKY. You can't have TORCH in WET. You can't CLIMB in NARROW.
  
  static final int ROCKY = 0;
  static final int WET = 1;
  static final int NARROW = 2;
  static final byte NEITHER = 0;
  static final byte TORCH = 1;
  static final byte CLIMB = 2;
  
  
  ArrayList<ArrayList<Integer>> caves = new ArrayList<ArrayList<Integer>>();
  
  void parseInput(ArrayList<String> input) {
    depth = Integer.parseInt(input.get(0).split("\\s+")[1]);
    String[] ts = input.get(1).split("\\s+")[1].split(",");
    target = new Point(Integer.parseInt(ts[0]), Integer.parseInt(ts[1])); 
    type = new int[target.y + SPLATTER][target.x + SPLATTER];
  } 
  
  int advent22a() {
    long[][] GI;
    long[][] EL;
    GI = new long[type.length][type[0].length];
    EL = new long[type.length][type[0].length];
    
    GI[0][0] = 0;
    EL[0][0] = depth % 20183;
    type[0][0] = (int) (EL[0][0] % 3);
    for (int i = 1; i < GI[0].length; i++) { GI[0][i] = 16807*i; EL[0][i] = (depth + GI[0][i]) % 20183; type[0][i] = (int) (EL[0][i] % 3); }
    for (int j = 1; j < GI.length; j++)    { GI[j][0] = 48271*j; EL[j][0] = (depth + GI[j][0]) % 20183; type[j][0] = (int) (EL[j][0] % 3); }
    
    for (int j=1; j<GI.length; j++) { 
      for (int i=1; i<GI[j].length; i++) { 
        GI[j][i] = EL[j][i-1] * EL[j-1][i];
        EL[j][i] = (depth + GI[j][i]) % 20183;
        type[j][i] = (int) (EL[j][i] % 3);
      }
    }
    GI[target.y][target.x] = 0;
    EL[target.y][target.x] = depth % 20183;
    type[target.y][target.x] = (int) (EL[target.y][target.x] % 3);
    int risk = 0;
    for (int j = 0; j <= target.y; j++) 
      for (int i = 0; i <= target.x; i++)
        risk += type[j][i];
    return risk;
  }

  static final int[] dx = new int[] {0,  1,  0, -1};
  static final int[] dy = new int[] {1,  0, -1,  0};
  
  class Place {
    int x;
    int y;
    byte tool;
    int time;
    
    Place(int _x, int _y, byte _t, int tm) {
      x = _x;
      y = _y;
      tool = _t;
      time = tm;
    }
  }
  
  int advent22b(int best_final, int xrange, int yrange) {
    int[][][] best = new int[yrange][xrange][3];
    for (int j = 0; j < yrange; j++) 
      for (int i = 0; i < xrange; i++) 
        for (int k = 0; k < 3; k++) best[j][i][k] = Integer.MAX_VALUE;

    ArrayDeque<Place> places = new ArrayDeque<Place>();
    places.add(new Place(0, 0, TORCH, 0));
    
    while (places.size() > 0) {
      Place p = places.pop();
      if (p.time > best[p.y][p.x][p.tool]) continue;
      best[p.y][p.x][p.tool] = p.time;
      
      if ((p.x == target.x) && (p.y == target.y) && (p.tool == TORCH) && (p.time < best_final)) {
        best_final = p.time;
        continue;
      }
      
      if (p.time >= best_final) continue;
      
      // Because ROCKY == NEITHER etc...
      
      for (byte i = 0; i < 3; i++) {
        if ((type[p.y][p.x] != i) && (p.tool != i)) {
          if (best[p.y][p.x][i] > p.time + 7) 
            places.push(new Place(p.x, p.y, i, p.time + 7));
        }
      }
      
      for (byte i = 0;  i < dx.length; i++) {
        int x2 = p.x + dx[i];
        int y2 = p.y + dy[i];
        if ((x2 >= 0) && (y2 >= 0) && (x2 < xrange) && (y2 < yrange)) {
          if (type[y2][x2] != p.tool) {
            if (best[y2][x2][p.tool] > p.time + 1) places.push(new Place(x2, y2, p.tool, p.time + 1));
          }
        }
      }
    }
    return best_final;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_22.txt"));
    System.out.println("(a) "+w.advent22a());
    long time = -System.currentTimeMillis();
    int ball_park = w.advent22b(Integer.MAX_VALUE, w.target.x + 2, w.target.y + 2);
    System.out.println("(b) Approximate answer: " + ball_park);
    System.out.println("(b) Real answer: " + w.advent22b(ball_park, w.target.x + 100, w.target.y + 100));
    time += System.currentTimeMillis();
    System.out.println("Time taken for (b): " + time+" ms");    
  }
}
