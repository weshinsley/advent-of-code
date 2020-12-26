package d05;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;

public class wes {
  
  int convert(String s) {
    s = s.replaceAll("[FL]", "0");
    s = s.replaceAll("[BR]", "1");
    return Integer.parseInt(s, 2);  
  }
  
  ArrayList<Integer> read_input(String f) throws Exception {
    ArrayList<Integer> ai = new ArrayList<Integer>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      ai.add(convert(s));
      s = br.readLine();
    }
    br.close();
    Collections.sort(ai);
    return ai;
  }
  
  int solve2(ArrayList<Integer> d) {
    int m = d.get(0);
    int i = 0;
    while (d.get(i++) == m++) {}
    return m - 1;
  }
     
  void stop_if_not(long res, long expec, String test) {
    if (res != expec) {
      System.out.println("Test "+test+" failure - expected "+expec+", got "+res);
      System.exit(-1);
    }
  }
  
  void run() throws Exception {
    stop_if_not(convert("FBFBBFFRLR"), 357, "Seat example 1");
    stop_if_not(convert("BFFFBBFRRR"), 567, "Seat example 2");
    stop_if_not(convert("FFFBBBFRRR"), 119, "Seat example 3");
    stop_if_not(convert("BBFFBBFRLL"), 820, "Seat example 4");
            
    System.out.println("Advent of Code 2020 - Day 05\n----------------------------");
    ArrayList<Integer> wes = read_input("d05/wes-input.txt");
    System.out.println("Part 1: "+wes.get(wes.size()-1));
    System.out.println("Part 2: "+solve2(wes));
  }
  
  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
