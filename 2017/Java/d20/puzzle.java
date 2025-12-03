package d20;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  
  class XYZ {
    long x,y,z;
    XYZ(long _x, long _y, long _z) { x = _x; y = _y; z = _z; }
    void add(XYZ V) { x += V.x; y += V.y; z += V.z; }
    long dist() { return Math.abs(x)+Math.abs(y)+Math.abs(z); }
  }
  
  ArrayList<XYZ> P = new ArrayList<XYZ>();
  ArrayList<XYZ> V = new ArrayList<XYZ>();
  ArrayList<XYZ> A = new ArrayList<XYZ>();
  
  XYZ parseXYZ(String s) {
    String[] bits = s.substring(s.indexOf("<") + 1, s.indexOf(">")).split(",");
    return new XYZ(Integer.parseInt(bits[0].trim()), Integer.parseInt(bits[1].trim()), 
        Integer.parseInt(bits[2].trim()));    
  }
  void parse(ArrayList<String> input) {
    P.clear();
    A.clear();
    V.clear();
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split(", ");
      P.add(parseXYZ(bits[0]));
      V.add(parseXYZ(bits[1]));
      A.add(parseXYZ(bits[2]));
    }
  }
  
  int part1() {
    long best = Long.MAX_VALUE;
    int best_index = -1;
    for (int j=0; j<1000; j++) { // bit arbitrary...
      best = Integer.MAX_VALUE;
      best_index = -1;
      for (int i=0; i<P.size(); i++) {
        V.get(i).add(A.get(i));
        P.get(i).add(V.get(i));
        long new_dist = P.get(i).dist();
        if (new_dist < best) {
          best = new_dist;
          best_index = i;
        }
      }
    }
    return best_index;
  }
  
  int part2() {
    HashMap<String, String> lookup = new HashMap<String, String>();
    HashMap<String, String> delete = new HashMap<String, String>();
    
    for (int j=0; j<1000; j++) { // bit arbitrary...
      lookup.clear();
      delete.clear();
      for (int i=0; i<P.size(); i++) {
        V.get(i).add(A.get(i));
        P.get(i).add(V.get(i));
        String hash = P.get(i).x+","+P.get(i).y+","+P.get(i).z;
        if (delete.containsKey(hash)) {
          delete.put(hash, delete.get(hash)+","+i);
        } else if (lookup.containsKey(hash)) {
          delete.put(hash,  lookup.get(hash)+","+i);
          lookup.remove(hash);
        } else {
          lookup.put(hash, ""+i);
        }
      }
      ArrayList<Integer> delete_indexes = new ArrayList<Integer>();

      for (String key : delete.keySet()) {
        String[] inds = delete.get(key).split(",");
        for (int i=0; i<inds.length; i++) {
          delete_indexes.add(Integer.parseInt(inds[i]));
        }
      }
      Collections.sort(delete_indexes);
      for (int i = delete_indexes.size()-1; i>=0; i--) {
        int ind = delete_indexes.get(i);
        A.remove(ind);
        V.remove(ind);
        P.remove(ind);
      }
    }
    return P.size();
  }
    
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_20.txt");
    w.parse(input);
    System.out.println(w.part1());
    w.parse(input);
    System.out.println(w.part2());
   }
}
