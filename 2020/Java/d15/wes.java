package d15;

import java.io.File;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;

public class wes {
  
  int[] read_input(String f) throws Exception {
    List<String> line = Files.readAllLines(new File("d15/wes-input.txt").toPath());
    String[] bits = line.get(0).split(",");
    int[] res = new int[bits.length];
    for (int i=0; i<bits.length; i++) res[i] = Integer.parseInt(bits[i]);
    return res;
  }
  
  long solve(int[] d, int end) {
    HashMap<Integer, Integer> memory = new HashMap<Integer, Integer>();
    for (int i=0; i<d.length-1; i++) memory.put(d[i], i + 1);
    int count = d.length;
    int next = d[d.length - 1];
    while (count < end) {
      int previous = -1;
      if (memory.containsKey(next)) {
        previous = memory.get(next);
      }
      memory.put(next, count);
      if (previous == -1) next = 0;
      else next = count - previous;
      count++;
    }
    return next;
  }
    
  void stop_if_not(long res, int expec, String test) {
    if (res != expec) {
      System.out.println("Test " + test + " failure - expected " + expec + ", got " + res);
      System.exit(-1);
    }
  }

  void test() {
    stop_if_not(solve(new int[] {0,3,6}, 2020), 436, "Test1 036");
    stop_if_not(solve(new int[] {1,3,2}, 2020), 1, "Test1 132");
    stop_if_not(solve(new int[] {2,1,3}, 2020), 10, "Test1 213");
    stop_if_not(solve(new int[] {1,2,3}, 2020), 27, "Test1 123");
    stop_if_not(solve(new int[] {2,3,1}, 2020), 78, "Test1 231");
    stop_if_not(solve(new int[] {3,2,1}, 2020), 438, "Test1 321");
    stop_if_not(solve(new int[] {3,1,2}, 2020), 1836, "Test1 312");
    stop_if_not(solve(new int[] {0,3,6}, 30000000), 175594, "Test2 036");
    stop_if_not(solve(new int[] {1,3,2}, 30000000), 2578, "Test2 132");
    stop_if_not(solve(new int[] {2,1,3}, 30000000), 3544142, "Test2 213");
    stop_if_not(solve(new int[] {1,2,3}, 30000000), 261214, "Test2 123");
    stop_if_not(solve(new int[] {2,3,1}, 30000000), 6895259, "Test2 231");
    stop_if_not(solve(new int[] {3,2,1}, 30000000), 18, "Test2 321");
    stop_if_not(solve(new int[] {3,1,2}, 30000000), 362, "Test2 312");
  }
  
  void run() throws Exception {
    // test(); - it's slow
    int[] input = read_input("d15/wes-input.txt");
    System.out.println("Advent of Code 2020 - Day 15\n----------------------------");
    System.out.println("Part 1: " + solve(input, 2020));
    System.out.println("Part 2: " + solve(input, 30000000));
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
