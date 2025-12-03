package d14;

import java.io.File;
import java.nio.file.Files;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public class puzzle {
  
  long solve(List<String> d, boolean part2) {
    String pad = String.join("", Collections.nCopies(36, "0"));
    StringBuffer newmem = new StringBuffer(pad);
    String mask = "";
    long countx = 0;
    HashMap<Long, Long> mem = new HashMap<Long, Long>();
    for (int i=0; i < d.size(); i++) {
      String line = d.get(i);
      if (line.startsWith("mask = ")) {
        mask = line.split("\\s+")[2];
        if (part2) countx = mask.chars().filter(ch -> ch == 'X').count();
      }
      else {
        int val = Integer.parseInt(line.split("\\s+")[2]);
        int addr = Integer.parseInt(line.substring(4, line.indexOf("]")));
        String binary = Integer.toBinaryString(part2 ? addr : val);
        StringBuffer bin = new StringBuffer(pad.substring(binary.length()) + binary);
        if (!part2) {
          for (int j = 0; j < 36; j++)
            if (mask.charAt(j) != 'X') bin.setCharAt(j, mask.charAt(j));
          mem.put((long) addr,  Long.parseLong(bin.toString(), 2));
        } else {
          for (int j = 0; j < 36; j++)
            if (mask.charAt(j) != '0') bin.setCharAt(j, mask.charAt(j));
          for (int j = 0; j < Math.pow(2, countx); j++) {
            String xval = Integer.toBinaryString(j);
            while (xval.length() < countx) xval = "0" + xval;
            int xp = 0;
            for (int k=0; k<36; k++) {
              if (bin.charAt(k)=='X') newmem.setCharAt(k, xval.charAt(xp++));
              else newmem.setCharAt(k,  bin.charAt(k));
            }
            mem.put(Long.parseLong(newmem.toString(), 2), (long) val);
          }
        }
      }
    }
    long sum = 0;
    for (long addr: mem.keySet()) sum += mem.get(addr);
    return sum;
  }

  void run() throws Exception {
    List<String> w = Files.readAllLines(new File("../inputs/input_14.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 14\n----------------------------");
    System.out.println("Part 1: " + solve(w, false));
    System.out.println("Part 2: " + solve(w, true));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
