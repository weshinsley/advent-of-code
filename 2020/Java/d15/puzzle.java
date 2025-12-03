package d15;

import java.io.File;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;

public class puzzle {
  
  int[] read_input(String f) throws Exception {
    List<String> line = Files.readAllLines(new File("../inputs/input_15.txt").toPath());
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
  
  void run() throws Exception {
    // test(); - it's slow
    int[] input = read_input("../inputs/input_15.txt");
    System.out.println("Advent of Code 2020 - Day 15\n----------------------------");
    System.out.println("Part 1: " + solve(input, 2020));
    System.out.println("Part 2: " + solve(input, 30000000));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
