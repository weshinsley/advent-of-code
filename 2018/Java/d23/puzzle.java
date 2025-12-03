package d23;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  
  class Nanobot {
    int x, y, z, range;
    Nanobot(int _x, int _y, int _z, int _s) {
      x = _x; 
      y = _y; 
      z = _z; 
      range = _s;
    }
    
    int manhatten(Nanobot n) {
      return Math.abs(x-n.x)+Math.abs(y-n.y)+Math.abs(z-n.z);
    }
  }
  
  ArrayList<Nanobot> bots;
  int largest_index;
  
  void parseInput(ArrayList<String> input) {
    int largest_range = Integer.MIN_VALUE;
    bots = new ArrayList<Nanobot>();
    for (int i = 0; i < input.size(); i++) {
      String[] bits = input.get(i).replaceAll("[pos=<> r]","").split(",");
      int range = Integer.parseInt(bits[3]);
      if (range > largest_range) {
        largest_range = range;
        largest_index = i;
      }
      bots.add(new Nanobot(Integer.parseInt(bits[0]), Integer.parseInt(bits[1]),Integer.parseInt(bits[2]), Integer.parseInt(bits[3])));
    }
  }
  
  int advent23a() {
    Nanobot N = bots.get(largest_index);
    int c=0;
    for (int i=0; i<bots.size(); i++)
      if ((bots.get(i).manhatten(N) <= N.range)) c++;
    return c;
  }
  
  int inRangeOf(long x, long y, long z) {
    int within=0;
    for (int j=0; j<bots.size(); j++) {
      Nanobot NJ = bots.get(j);
      if ((Math.abs(NJ.x-x) + Math.abs(NJ.y-y) + Math.abs(NJ.z-z)) <= (long) NJ.range) within++;
    }
    return within;
  }
  
  long advent23b() {
    long best=-1;
    long stride = 100000000;
    int search = 10;
    int max = Integer.MIN_VALUE;
    ArrayList<long[]> hits = new ArrayList<long[]>();
    long base_x=0;
    long base_y=0;
    long base_z=0;
    while (stride >= 1) {
      for (int x=-search; x<search; x++) {
        for (int y=-search; y<search; y++) {
          for (int z=-search; z<search; z++) {
            int score = inRangeOf((long) (base_x + (x * stride)), (long) (base_y + (y * stride)), (long) (base_z + (z * stride)));
            if (score >= max) {
              if (score > max) { 
                max = score;
                hits.clear();
              }
              hits.add(new long[] {base_x + (x * stride), base_y + (y * stride), base_z + (z * stride)});
            }
          }
        }
      }
      best = Math.abs(hits.get(0)[0])+Math.abs(hits.get(0)[1])+Math.abs(hits.get(0)[2]);
      for (int i=1; i<hits.size(); i++) {
        long dist = Math.abs(hits.get(i)[0])+Math.abs(hits.get(i)[1])+Math.abs(hits.get(i)[2]);
        if (dist<best) best = dist;
      }
      base_x = hits.get(0)[0];
      base_y = hits.get(0)[1];
      base_z = hits.get(0)[2];
      hits.clear();
      stride = stride / 10;
    }
    return best;
  }
  
 public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_23.txt"));
    System.out.println(w.advent23a());
    System.out.println(w.advent23b());
  }
}
