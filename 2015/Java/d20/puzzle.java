package d20;

import tools.Utils;

public class puzzle {
  
  static int advent20a(int max) {
    int[] infinite_houses = new int[max+1];
    for (int elf=1; elf<=max; elf++) {
      for (int h=elf; h<=max; h+=elf) {
        infinite_houses[h]+=(elf*10);
      }
    }
    for (int i=0; i<=max; i++) {
      if (infinite_houses[i]>=max) return i;
    }
    return 0;
  }
  
  static int advent20b(int max) {
    int[] infinite_houses = new int[max+1];
    for (int elf=1; elf<=max; elf++) {
      for (int h=elf; h<Math.min(max, elf+(50*elf)); h+=elf) {
        infinite_houses[h]+=(elf*11);
      }
    }
    for (int i=0; i<=max; i++) {
      if (infinite_houses[i]>=max) return i;
    }
    return 0;
  }
  
  public static void main(String[] args) throws Exception {
    int input = Integer.parseInt(Utils.readLines("../inputs/input_20.txt").get(0));
    System.out.println(advent20a(input));
    System.out.println(advent20b(input));
  }
}
