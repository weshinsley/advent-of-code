package d10;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collections;

public class wes {

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

  void stop_if_not(long res, int expec, String test) {
    if (res != expec) {
      System.out.println("Test " + test + " failure - expected " + expec + ", got " + res);
      System.exit(-1);
    }
  }

  void run() throws Exception {
    ArrayList<Integer> w = read_input("d10/test_35_8.txt");
    stop_if_not(solve1(w), 35, "16,10,5.. test part 1");
    stop_if_not(solve2(w), 8, "16,10,5.. test part 2");
    
    w = read_input("d10/test_220_19208.txt");
    stop_if_not(solve1(w), 220, "28,33.. test part 1");
    stop_if_not(solve2(w), 19208, "28,33.. test part 2");
    
    
    System.out.println("Advent of Code 2020 - Day 10\n----------------------------");
    w = read_input("d10/wes-input.txt");
    System.out.println("Part 1: " + solve1(w));
    System.out.println("Part 2: " + solve2(w));
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
