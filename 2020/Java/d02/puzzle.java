package d02;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  ArrayList<OTCP> input;
  
  class OTCP {
    int min;
    int max;
    char letter;
    String password;
    
    OTCP(String s) {
      String[] bits = s.split("\\s+");
      letter = bits[1].charAt(0);
      password = bits[2];
      bits = bits[0].split("-");
      min = Integer.parseInt(bits[0]);
      max = Integer.parseInt(bits[1]);
    }
    
    boolean isValid(int part) {
      int c=0;
      if (part == 1) {
        for (int i=0; i<password.length(); i++) {
          c += (password.charAt(i)==letter)?1:0;
          if (c > max) return false;
        }
        return c>=min;
      } else {
        if (password.charAt(min - 1) == letter) c++;
        if (password.charAt(max - 1) == letter) c++;
        return (c == 1);
      }
    }
  }
  
  ArrayList<OTCP> read_input(String f) throws Exception {
    ArrayList<OTCP> ai = new ArrayList<OTCP>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      ai.add(new OTCP(s));
      s = br.readLine();
    }
    br.close();
    return ai;
  }
  
  int solve(ArrayList<OTCP> d, int part) {
    int c=0;
    for (int i = 0; i < d.size(); i++) 
      c+=(d.get(i).isValid(part))?1:0;
    return c;
  }
  
  void run() throws Exception {
    System.out.println("Advent of Code 2020 - Day 02\n----------------------------");
    ArrayList<OTCP> wes = read_input("../inputs/input_2.txt");
    System.out.println("Part 1: "+solve(wes, 1));
    System.out.println("Part 2: "+solve(wes, 2));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
