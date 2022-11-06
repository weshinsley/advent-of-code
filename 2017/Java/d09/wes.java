package d09;
import tools.Utils;

public class wes {
  
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

  public void test() throws Exception {
    Utils.test(solve("{}")[0], 1);
    Utils.test(solve("{{{}}}")[0], 6);
    Utils.test(solve("{{},{}}")[0], 5);
    Utils.test(solve("{{{},{},{{}}}}")[0], 16);
    Utils.test(solve("{<a>,<a>,<a>,<a>}")[0], 1);
    Utils.test(solve("{{<ab>},{<ab>},{<ab>},{<ab>}}")[0], 9);
    Utils.test(solve("{{<!!>},{<!!>},{<!!>},{<!!>}}")[0], 9);
    Utils.test(solve("{{<a!>},{<a!>},{<a!>},{<ab>}}")[0], 3);

    Utils.test(solve("{<>}")[1], 0);
    Utils.test(solve("{<random characters>}")[1], 17);
    Utils.test(solve("{<<<<>}")[1], 3);
    Utils.test(solve("{<{!>}>}")[1], 2);
    Utils.test(solve("{<!!>}")[1], 0);
    Utils.test(solve("{<!!!>>}")[1], 0);
    Utils.test(solve("{<{o\"i!a,<{i<a>}")[1], 10);

  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    String input = Utils.readLines("../R/09/input.txt").get(0);
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
