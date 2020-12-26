package d09;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedList;

public class wes {

  int solve1(String f, int preamble) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    LinkedList<Integer> buffer = new LinkedList<Integer>();
    for (int i = 0; i < preamble; i++) {
      buffer.add(Integer.parseInt(br.readLine()));
    }
    while (true) {
      boolean found = false;
      int i = Integer.parseInt(br.readLine());
      for (int j = 0; j < preamble - 1; j++)
        for (int k = j + 1; k < preamble ; k++)
          if (buffer.get(j) + buffer.get(k) == i) {
            found = true;
            k = j = preamble;
          }
      
      if (!found) {
        br.close();
        return i;
      }
      buffer.removeFirst();
      buffer.add(i);
    }
  }

  int solve2(String f, long target) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(f));
    LinkedList<Integer> buffer = new LinkedList<Integer>();
    int tot = 0;
    while (tot != target) {
      int i = Integer.parseInt(br.readLine());
      tot += i;
      buffer.add(i);
      while (tot > target)
        tot -= buffer.removeFirst();
    }
    br.close();
    int max = Integer.MIN_VALUE;
    int min = Integer.MAX_VALUE;
    for (int i = 0; i < buffer.size(); i++) {
      min = Math.min(min, buffer.get(i));
      max = Math.max(max, buffer.get(i));
    }

    return min + max;
  }

  void stop_if_not(int res, int expec, String test) {
    if (res != expec) {
      System.out.println("Test " + test + " failure - expected " + expec + ", got " + res);
      System.exit(-1);
    }
  }

  void run() throws Exception {
    int t = solve1("d09/test_127_62.txt", 5);
    stop_if_not(t, 127, "Part 1");
    stop_if_not(solve2("d09/test_127_62.txt", t), 62, "Part 2");
    
    System.out.println("Advent of Code 2020 - Day 09\n----------------------------");
    t = solve1("d09/wes-input.txt", 25);
    System.out.println("Part 1: " + t);
    System.out.println("Part 2: " + solve2("d09/wes-input.txt", t));
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
