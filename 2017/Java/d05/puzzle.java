package d05;

import java.util.ArrayList;
import java.util.Arrays;

import tools.Utils;

public class puzzle {

  public int solve(ArrayList<Integer> input, boolean part2) {
    int ptr = 0;
    int steps = 0;
    while ((ptr >= 0) && (ptr < input.size())) {
      int jump = input.get(ptr);
      input.set(ptr,  jump + 1 + ((part2 && (jump >= 3)) ? -2 : 0));
      ptr += jump;
      steps++;
    }
    return steps;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<Integer> input = Utils.toIntArrayList(Utils.readLines("../inputs/input_5.txt"));
    System.out.println(w.solve(input, false));
    input = Utils.toIntArrayList(Utils.readLines("../inputs/input_5.txt"));
    System.out.println(w.solve(input, true));
  }
}
