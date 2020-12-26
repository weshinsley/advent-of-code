package d04;

import java.io.BufferedReader;
import java.io.FileReader;

public class wes {
  int first,last;

  void readInput(String s) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(s));
    String[] bits = br.readLine().split("-");
    br.close();
    first = Integer.parseInt(bits[0]);
    last = Integer.parseInt(bits[1]);
  }

  int valid1(String s) {
    boolean repeat = false;
    boolean decreasing = false;
    for (int j = 0; j < s.length() - 1; j++) {
      int ch1 = s.charAt(j);
      int ch2 = s.charAt(j+1);
      if (ch1 == ch2) repeat=true;
      if (ch2 < ch1) decreasing=true;
    }
    return (repeat && !decreasing)?1:0;
  }

  int valid2(String s) {
    boolean repeat = false;
    boolean decreasing = false;
    for (int j = 0; j < s.length() - 1; j++) {
      int ch0 = -1;
      if (j>0) ch0=s.charAt(j - 1);
      int ch1 = s.charAt(j);
      int ch2 = s.charAt(j + 1);
      int ch3 = -1;
      if (j+2 < s.length()) ch3 = s.charAt(j + 2);
      if ((ch1 == ch2) && (ch2 != ch3) && (ch1 != ch0)) repeat=true;
      if (ch2 < ch1) decreasing=true;
    }
    return (repeat && !decreasing) ? 1 : 0;
  }

  void solve(int _first, int _last, int part) {
    int count=0;
    for (int i=_first; i <= _last; i++) {
      if (part == 1) count += valid1(String.valueOf(i));
      else count += valid2(String.valueOf(i));
    }
    System.out.println("Part " + part + ": "+count);
  }

  public void expect(String val, int res, boolean part1) {
    if (part1) {
      if (valid1(val)!=res) System.out.println("Part 1: "+val +" should be "+res);
    } else {
      if (valid2(val)!=res) System.out.println("Part 2: "+val +" should be "+res);
    }
  }

  public void test() {
    expect("111111", 1, true);
    expect("223450", 0, true);
    expect("123789", 0, true);
    expect("112233", 1, false);
    expect("123444", 0, false);
    expect("111122", 1, false);
  }

  public static void main(String[] args) throws Exception {
    wes W = new wes();
    W.test();
    W.readInput("d04/wes-input.txt");
    W.solve(W.first, W.last, 1);
    W.solve(W.first, W.last, 2);
  }
}
