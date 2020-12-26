package d03;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class wes {
  
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
  
  void stop_if_not(long res, long expec, String test) {
    if (res != expec) {
      System.out.println("Test "+test+" failure - expected "+expec+", got "+res);
      System.exit(-1);
    }
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 03\n----------------------------");
    ArrayList<String> test = read_input("d03/test_7_336.txt");
    stop_if_not(solve1(test), 7, "Solve1");
    stop_if_not(solve2(test), 336, "Solve2");
    ArrayList<String> wes = read_input("d03/wes-input.txt");
    System.out.println("Part 1: "+solve1(wes));
    System.out.println("Part 2: "+solve2(wes));
  }
  
  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
