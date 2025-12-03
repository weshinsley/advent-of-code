package d09;
import tools.Utils;

public class puzzle {
  
  public int[] solve(String input) {
    int i = 0;
    int depth = 0;
    int groups = 0;
    int garbage = 0;
    boolean in_garbage = false;
    while (i < input.length()) {
      char c = input.charAt(i++);
      if (c == '{' && !in_garbage) {
        depth++;
        groups += depth;
      } else if (c == '}' && !in_garbage) {
        depth--;
      } else if (c == '<') {
        if (in_garbage) garbage++;
        else in_garbage = true;
      } else if (c == '>') {
        in_garbage = false;
      } else if (c == '!') {
        i++;
      } else if (in_garbage) garbage++;
    }
    return new int[] {groups, garbage};
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    String input = Utils.readLines("../inputs/input_9.txt").get(0);
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
