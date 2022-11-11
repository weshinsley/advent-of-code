package d16;

import java.util.HashSet;

import tools.Utils;

public class wes {
  
  public String solve(String[] moves, int len, long count) {
    HashSet<String> mem = new HashSet<String>();
    StringBuffer dancers = new StringBuffer(new String("abcdefghijklmnop").substring(0, len));
    
    for (long d=0; d<count; d++) {
      for (int i=0; i<moves.length; i++) {
        if (moves[i].startsWith("s")) {
          int n = Integer.parseInt(moves[i].substring(1));
          dancers.insert(0, dancers.substring(dancers.length() - n));
          dancers.delete(dancers.length() - n,  dancers.length());
        } else if (moves[i].startsWith("x")) {
          String[] bits = moves[i].substring(1).split("/");
          int b0 = Integer.parseInt(bits[0]);
          int b1 = Integer.parseInt(bits[1]);
          char c = dancers.charAt(b0);
          dancers.setCharAt(b0, dancers.charAt(b1));
          dancers.setCharAt(b1, c);
        
        } else if (moves[i].startsWith("p")) {
          String[] bits = moves[i].substring(1).split("/");
          int b0 = dancers.indexOf(bits[0]);
          int b1 = dancers.indexOf(bits[1]);
          char c = dancers.charAt(b0);
          dancers.setCharAt(b0, dancers.charAt(b1));
          dancers.setCharAt(b1, c);   
        }
      }
      String s = dancers.toString();
      if (mem.contains(s)) d = d * (count / d);
      else mem.add(s);
    }
    return dancers.toString();
  }
  
 
  void test() throws Exception {
    String[] example = new String("s1,x3/4,pe/b").split(",");
    Utils.test(solve(example, 5, 1),  "baedc");
  }
  
  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    String[] input = Utils.readLines("../R/16/input.txt").get(0).split(",");
    System.out.println(w.solve(input, 16, 1));
    System.out.println(w.solve(input,  16, 1000000000L));
  }
}
