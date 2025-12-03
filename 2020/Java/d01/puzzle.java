package d01;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  ArrayList<Integer> read_input(String f) throws Exception {
    ArrayList<Integer> ai = new ArrayList<Integer>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      ai.add(Integer.parseInt(s));
      s = br.readLine();
    }
    br.close();
    return ai;
  }

  int solve1(ArrayList<Integer> d) {
    for (int i = 0; i < d.size() - 1; i++) 
      for (int j = i + 1; j < d.size(); j++)
        if (d.get(i) + d.get(j) == 2020) 
          return d.get(i) * d.get(j);
    return 0;
  }

  int solve2(ArrayList<Integer> d) {
    for (int i = 0; i < d.size() - 2; i++) 
      for (int j = i + 1; j < d.size() - 1; j++)
        for (int k = j + 1; k < d.size(); k++)
        if (d.get(i) + d.get(j) + d.get(k) == 2020) 
          return d.get(i) * d.get(j) * d.get(k);
    return 0;
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 01\n----------------------------");
    ArrayList<Integer> wes = read_input("../inputs/input_1.txt");
    System.out.println("Part 1: "+solve1(wes));
    System.out.println("Part 2: "+solve2(wes));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
