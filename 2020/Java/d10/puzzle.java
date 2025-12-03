package d10;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;

public class puzzle {

  ArrayList<Integer> read_input(String f) throws Exception {
    ArrayList<Integer> ai = new ArrayList<Integer>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s != null) {
      ai.add(Integer.parseInt(s));
      s = br.readLine();
    }
    br.close();
    Collections.sort(ai);
    ai.add(ai.get(ai.size() - 1) + 3);
    return ai;
  }

  int solve1(ArrayList<Integer> d) {
    int dummy = 0, c1 = 0, c3 = 0;
    dummy = d.get(0) == 1 ? ++c1 : ++c3;
    for (int i = 1; i < d.size(); i++)
      dummy = (d.get(i) - d.get(i - 1) == 1) ? ++c1 : ++c3;
    return (c1 * c3) * (dummy / dummy); // Divide is just to avoid the warning!
  }

  long solve2(ArrayList<Integer> d) {
    d.add(0, 0);
    int rows = 0;
    long prod = 1;
    
    // For one permutable number, can turn it on/off. (2 options)
    // For two permutable numbers, both/either on/off (4 options)
    // For three: can't turn them all off (as stride is then >3)
    //            but can have 123, 12, 23, 13, 1, 2, 3 (7 options)
    
    long[] options = new long[] { 1, 2, 4, 7 };
    for (int i = 1; i < d.size() - 1; i++) {
      if (d.get(i + 1) - d.get(i - 1) <= 3) {
        rows++;
      } else {
        prod *= options[rows];
        rows = 0;
      }
    }
    return prod;
  }

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 10\n----------------------------");
    ArrayList<Integer> w = read_input("../inputs/input_10.txt");
    System.out.println("Part 1: " + solve1(w));
    System.out.println("Part 2: " + solve2(w));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
