package d25;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  ArrayList<int[]> points;
  
  void parseInput(ArrayList<String> input) {
    points = new ArrayList<int[]>();
    for (int i = 0; i < input.size(); i++) {
      points.add(new int[4]);
      String[] bits = input.get(i).split(",");
      for (int j = 0; j < 4; j++) points.get(i)[j] = Integer.parseInt(bits[j]);
    }
  }
  
  boolean close(int[] p1, int[] p2) {
    return (Math.abs(p1[0] - p2[0]) + Math.abs(p1[1] - p2[1]) + Math.abs(p1[2] - p2[2]) + Math.abs(p1[3] - p2[3]) <= 3);  
  }

  int advent25a() {
    ArrayList<ArrayList<int[]>> cons = new ArrayList<ArrayList<int[]>>();
    boolean[] in_con = new boolean[points.size()];
    
    while (points.size() > 0) {
      for (int j = 0; j < cons.size(); j++) in_con[j]=false;
      int[] p = points.get(0);
      points.remove(0);
      
      int count_cons = 0;
      int first_index = -1;
      
      for (int j=0; j < cons.size(); j++)
        for (int i = 0; i < cons.get(j).size(); i++) {
          if (close(p, cons.get(j).get(i))) {
            in_con[j] = true;
            count_cons++;
            if (first_index == -1) first_index = j;
            
          }
        }
      
      if (count_cons == 0) {
        ArrayList<int[]> new_con = new ArrayList<int[]>();
        new_con.add(p);
        cons.add(new_con);
      
      } else if (count_cons == 1) cons.get(first_index).add(p);
      
      else {
        ArrayList<int[]> first_con = cons.get(first_index);
        first_con.add(p);
        for (int j = 0; j < cons.size(); j++) {
          if ((j != first_index) && (in_con[j])) {
            first_con.addAll(cons.get(j));
            cons.get(j).clear();
          }
        }
      } 
    }
    
    int total = 0;
    for (int i = 0; i < cons.size(); i++)
      if (cons.get(i).size()>0) total++;
    return total;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_25.txt"));
    System.out.println(w.advent25a());
  }
}
