package d05;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;

public class puzzle {
  
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
     
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 05\n----------------------------");
    ArrayList<Integer> wes = read_input("../inputs/input_5.txt");
    System.out.println("Part 1: "+wes.get(wes.size()-1));
    System.out.println("Part 2: "+solve2(wes));
  }
  
  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
