package d01;
import tools.*;

public class puzzle {

  public int part1(String s) {
    int res = 0;
    s += s.charAt(0);
    for (int i = 0; i < s.length() - 1; i++) {
      if (s.charAt(i) == s.charAt(i + 1)) {
        res += Integer.parseInt(""+s.charAt(i));
      }
    }
    return res;
  }

  public int part2(String s) {
    int res = 0;
    int step = s.length() / 2;
    for (int i = 0; i < s.length(); i++) {
      if (s.charAt(i) == s.charAt((i + step) % s.length())) {
        res += Integer.parseInt(""+s.charAt(i));
      }
    }
    return res;  
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    String s = Utils.readLines("../inputs/input_1.txt").get(0);
    System.out.println(w.part1(s));
    System.out.println(w.part2(s));
  }
}
