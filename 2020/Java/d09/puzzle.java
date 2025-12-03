package d09;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedList;

public class puzzle {

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

  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 09\n----------------------------");
    int t = solve1("../inputs/input_9.txt", 25);
    System.out.println("Part 1: " + t);
    System.out.println("Part 2: " + solve2("../inputs/input_9.txt", t));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
