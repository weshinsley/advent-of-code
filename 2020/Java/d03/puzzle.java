package d03;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  
  ArrayList<String> read_input(String f) throws Exception {
    ArrayList<String> as = new ArrayList<String>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      as.add(s);
      s = br.readLine();
    }
    br.close();
    return as;
  }
  
  long solve(ArrayList<String> d, int xd, int yd) {
    int x = xd;
    int y = yd;
    long tree = 0;
    while (y < d.size()) {
      char c = d.get(y).charAt(x);
      if (c == '#') tree++;
      x = (x + xd) % d.get(0).length();
      y += yd; 
    }
    return tree;
  }
  
  long solve1(ArrayList<String> d) {
    return solve(d, 3, 1);
  }
  
 long solve2(ArrayList<String> d) {
    return solve(d,1,1) * solve(d,3,1) * solve(d,5,1) * solve(d,7,1) * solve(d,1,2);
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 03\n----------------------------");
    ArrayList<String> wes = read_input("../inputs/input_3.txt");
    System.out.println("Part 1: "+solve1(wes));
    System.out.println("Part 2: "+solve2(wes));
  }
  
  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
