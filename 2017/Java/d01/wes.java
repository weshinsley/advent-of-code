package d01;
import tools.*;

public class wes {

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
  
  public void test() throws Exception {
    Utils.test(part1("1122"), 3);
    Utils.test(part1("1111"), 4);
    Utils.test(part1("1234"), 0);
    Utils.test(part1("91212129"), 9);
    Utils.test(part2("1212"), 6);
    Utils.test(part2("1221"), 0);
    Utils.test(part2("123425"), 4);
    Utils.test(part2("123123"), 12);
    Utils.test(part2("12131415"), 4);
  }
  
  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    String s = Utils.readLines("inputs/d01-input.txt").get(0);
    System.out.println(w.part1(s));
    System.out.println(w.part2(s));
  }
}
