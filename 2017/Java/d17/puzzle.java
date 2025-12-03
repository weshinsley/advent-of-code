package d17;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  class Spinlock {
    int x;
    Spinlock next;
    Spinlock(int _x, Spinlock _next) {
      x = _x;
      next = _next;;
    }
  }
  
  void print(Spinlock z) {
    Spinlock p = z;
    do {
      System.out.print(p.x+" ");
      p = p.next;
    } while (p!=z);
    System.out.println();
    
  }
  
  int part1(int input) {
     Spinlock zero = new Spinlock(0, null);
     zero.next = zero;
     Spinlock pos = zero;
     for (int val=1; val<=2017; val++) {
       for (int i=0; i < input % val; i++) pos = pos.next;
       Spinlock n = new Spinlock(val, pos.next);
       pos.next = n;
       pos = n;
     }
     return pos.next.x;
  }
  
  int part2(int input) {
    int after_zero = -1;
    int pos = 0;
    for (int i = 1; i <= 50000000; i++) {
      pos = (pos + 1 + input) % i;
      if (pos == 0) after_zero = i;
    }
    return after_zero;
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    int input = Integer.parseInt(Utils.readLines("../inputs/input_17.txt").get(0));
    System.out.println(w.part1(input));
    System.out.println(w.part2(input));
  }
}
