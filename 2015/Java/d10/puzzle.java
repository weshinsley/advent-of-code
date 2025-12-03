package d10;

import tools.Utils;

public class puzzle {
  
  static String play(String s) {
    StringBuffer sb = new StringBuffer();
    int i=0;
    int j=1;
    while (i<s.length()) {
      while ((j<s.length()) && (s.charAt(j) == s.charAt(i))) j++;
      sb.append(String.valueOf(j-i));
      sb.append(s.charAt(i));
      i=j;
      j=i+1;
    }
    return sb.toString();
  }
  
  static String advent10(String s, int n) {
    for (int i=0; i<n; i++) s = play(s);
    return s;
  }
  
  public static void main(String[] args) throws Exception {
    String input = Utils.readLines("../inputs/input_10.txt").get(0);
    System.out.println(advent10(input,40).length());
    System.out.println(advent10(input,50).length());
  }
}
