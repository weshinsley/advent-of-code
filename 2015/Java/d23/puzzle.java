package d23;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  class Computer {
    int a=0;
    int b=0;
    int pc;
    
    void execute(String s) {
      s = s.replace(","," ");
      s = s.replace("+"," ");
      String[] bits = s.split("\\s+");
    
      if (bits[0].equals("hlf")) {
        if (bits[1].equals("a")) a=a/2;
        else b=b/2;
        pc++;
      
      } else if (bits[0].equals("tpl")) {
        if (bits[1].equals("a")) a=a*3;
        else b=b*3;
        pc++;
      
      } else if (bits[0].equals("inc")) {
        if (bits[1].equals("a")) a++;
        else b++;
        pc++;
      
      } else if (bits[0].equals("jmp")) {
        pc+=Integer.parseInt(bits[1]);
      
      } else if (bits[0].equals("jie")) {
        if   ((bits[1].equals("a") && (a % 2 == 0))
          || (bits[1].equals("b") && (b % 2 == 0))) {
          pc+=Integer.parseInt(bits[2]);
        } else pc++;
        
      } else if (bits[0].equals("jio")) {
        if   ((bits[1].equals("a") && (a == 1))
            || (bits[1].equals("b") && (b == 1))) {
            pc+=Integer.parseInt(bits[2]);
        } else pc++;
      } else System.out.println("Unrecogniseed "+bits[0]);
    }
    
    void run(ArrayList<String> script) {
      pc=0;
      while (pc<script.size())
        execute(script.get(pc));
    }
  }
  
  void advent23a(ArrayList<String> input) {
    Computer c = new Computer();
    c.run(input);
    System.out.println(c.b);
  }
  
  void advent23b(ArrayList<String> input) {
    Computer c = new Computer();
    c.a=1;
    c.run(input);
    System.out.println(c.b);
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_23.txt");
    puzzle p = new puzzle();
    p.advent23a(input);
    p.advent23b(input);
  }
}
