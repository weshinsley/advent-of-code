package d11;

import tools.Utils;

public class puzzle {
  
  static String inc(String s) {
    StringBuffer sb = new StringBuffer(s);
    int i = s.length()-1;
    while (i>=0) {
      if (sb.charAt(i)=='z') {
        sb.setCharAt(i,'a');
        i--;
      } else {
        do {
          sb.setCharAt(i, (char) (1 + (int) (sb.charAt(i))));
        } while ((sb.charAt(i)=='o') ||(sb.charAt(i)=='i') || (sb.charAt(i)=='l'));
        break;
      }
    }
    return sb.toString();
  }
  
  static boolean rule1(String s) {
    int i=3;
    int a = (int) s.charAt(0);
    int b = (int) s.charAt(1);
    int c = (int) s.charAt(2);
    while (i<s.length()) {
      if ((b == a + 1) && (c == b + 1)) return true;
      a = b;
      b = c;
      c = (int)(s.charAt(i));
      i++;
    }
    return false;
  }
  
  static boolean rule2(String s) {
    return (s.indexOf("i")==-1) && (s.indexOf("o")==-1) && (s.indexOf("l")==-1);
  }
  
  static boolean rule3(String s) {
    int a = (int) 'a';
    int b = (int) 'z';
    int c=0;
    for (int i=a; i<=b; i++) {
      if (s.indexOf("" + (char)i + (char)i)>=0) {
        c++;
        if (c==2) return true;
      }
    }
    return false;
  }
  
  static String advent11(String s) {
    do {
      s = inc(s);
    } while (!rule1(s) || !rule3(s));
    return s;
  }
  
  public static void main(String[] args) throws Exception {
    String input = Utils.readLines("../inputs/input_11.txt").get(0);
    System.out.println(advent11(input));
    System.out.println(advent11(advent11(input)));
  }
}
