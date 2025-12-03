package d01;
import tools.Utils;

public class puzzle {

  public static int day1a(String s) {
    int floor = 0;
    for (int i = 0; i < s.length(); i++) floor += (s.charAt(i) == '(') ? 1 : -1;
    return floor;
  }

  public static int day1b(String s) {
    int i = 0, floor = 0;
    while (floor >= 0) floor += (s.charAt(i++) == '(') ? 1 : -1;
    return i;
  }

  public static void main(String[] args) throws Exception {
    String s = Utils.readLines("../inputs/input_1.txt").get(0);
    System.out.println(day1a(s));
    System.out.println(day1b(s));
  }
}
