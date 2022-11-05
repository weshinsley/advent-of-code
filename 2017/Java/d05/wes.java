package d05;

import java.util.ArrayList;
import java.util.Arrays;

import tools.Utils;

public class wes {

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

  public void test() throws Exception {
    Utils.test(solve(new ArrayList<Integer>(Arrays.asList(0, 3, 0, 1, -3)), false), 5);
    Utils.test(solve(new ArrayList<Integer>(Arrays.asList(0, 3, 0, 1, -3)), true), 10);
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    ArrayList<Integer> input = Utils.toIntArrayList(Utils.readLines("../R/05/input.txt"));
    System.out.println(w.solve(input, false));
    input = Utils.toIntArrayList(Utils.readLines("../R/05/input.txt"));
    System.out.println(w.solve(input, true));
  }
}
