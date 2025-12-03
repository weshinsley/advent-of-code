package d23;

import java.nio.file.Files;

public class puzzle {
  class Cup {
    int num;
    Cup next;
    Cup(int v) { num = v; }
  }
 
  long solve(String s, boolean part2) {
    // Simultaneously setup a linked list (circular) of cups,
    // and a lookup array to index each cup object by its number.
    
    Cup[] cups = new Cup[1 + ((!part2) ? s.length() : 1000000)];
    int first_val = Integer.parseInt(s.substring(0, 1));
    Cup first_cup = new Cup(first_val);
    cups[first_val] = first_cup;
    Cup previous = first_cup;
    
    for (int i=1; i<s.length(); i++) {
      int v = Integer.parseInt(s.substring(i, i+1));
      cups[v] = new Cup(v);
      previous.next = cups[v];
      previous = previous.next;
    }
    if (part2) {
      for (int j = 10; j <= 1000000; j++) {
        cups[j] = new Cup(j);
        previous.next = cups[j];
        previous = previous.next;
      }
    }
    previous.next = first_cup;
    
    Cup current = first_cup;
    int no = !part2 ? 100 : 10000000;
    for (int i = 1; i <= no; i++) {
      int dest = current.num - 1;
      if (dest == 0) dest = cups.length - 1;
      while ((current.next.num == dest) || (current.next.next.num == dest) || 
             (current.next.next.next.num == dest)) {
        dest--;
        if (dest == 0) dest = cups.length - 1;
      }
      Cup orphan = current.next;
      current.next = current.next.next.next.next;
      Cup new_parent = cups[dest];
      orphan.next.next.next = new_parent.next;
      new_parent.next = orphan;
      current = current.next;
    }
    Cup one = cups[1];
    if (!part2) {
      String res = "";
      for (int j = 0; j < cups.length - 2; j++) {
        one = one.next;
        res += String.valueOf(one.num);
      }
      return Long.parseLong(res);
    } else {
      return (long)(one.next.num) * (long)(one.next.next.num);
    }
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 23\n----------------------------");
    String wes = "952316487";
    System.out.println("Part 1: "+solve(wes, false));
    System.out.println("Part 2: "+solve(wes, true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
