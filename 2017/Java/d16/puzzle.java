package d16;

import java.util.HashSet;

import tools.Utils;

public class puzzle {
  
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
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    String[] input = Utils.readLines("../inputs/input_16.txt").get(0).split(",");
    System.out.println(w.solve(input, 16, 1));
    System.out.println(w.solve(input,  16, 1000000000L));
  }
}
