package d07;

import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {

  class Program {
    Program parent = null;
    ArrayList<Program> children = new ArrayList<Program>();
    int weight;
    int sum;
    String name;
    Program bad_child = null;
    
    Program(String name, int weight) {
      this.name = name;
      this.weight = weight;
    }
    
    int sum() {
      int w = weight;
      for (int i=0; i<children.size(); i++) {
        w += children.get(i).sum();
      }
      return w;      
    }
    
    int check_balanced(int adj) {
      if (children.size() == 1) {
        return children.get(0).check_balanced(adj);
      } else if (children.size() == 2) {
        int c1 = children.get(0).check_balanced(adj);
        int c2 = children.get(1).check_balanced(adj);
        if (c1!=0) return c1;
        else return c2;
      } else if (children.size() >= 3) {
        int s0 = children.get(0).sum();
        int s1 = children.get(1).sum();
        int s2 = children.get(2).sum();
        if ((s1 == s2) && (s0 != s1)) return children.get(0).check_balanced(s1 - s0);
        else if ((s0 == s2) && (s1 != s2)) return children.get(1).check_balanced(s2 - s1);
        else if ((s0 == s1) && (s2 != s1)) return children.get(2).check_balanced(s1 - s2);
        else {
          for (int j=3; j<children.size(); j++) {
            if (children.get(j).sum() != s0) {
              return children.get(j).check_balanced(children.get(j).sum() - s0);
            }
          }
          return weight + adj;
        } 
      } else { 
        return weight + adj;
      }    
    }
  }
  
  HashMap<String, Program> programs = new HashMap<String, Program>();
  
  void parse(ArrayList<String> input) {
    programs.clear();
    for (int i = 0; i < input.size(); i++) {
      String[] s = input.get(i).split("\\s+");
      s[1] = s[1].replace("(", "");
      s[1] = s[1].replace(")", "");
      programs.put(s[0],  new Program(s[0], Integer.parseInt(s[1])));
    }
    for (int i = 0; i < input.size(); i++) {
      String[] s = input.get(i).split("\\s+");
      if (s.length > 2) {
        Program parent = programs.get(s[0]);
        for (int j = 3; j < s.length; j++) {
          s[j] = s[j].replace(",", "");
          Program p = programs.get(s[j]);
          p.parent = parent;
          parent.children.add(p);
        }
      }
    }
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i).split("\\s+")[0];
      programs.get(s).sum = programs.get(s).sum();
    }
  }
  
  String part1() {
    for (Program p : programs.values()) {
      if (p.parent == null) return(p.name);
    }
    return null;
  }
  
  int part2(String base) {
    return programs.get(base).check_balanced(0);    
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parse(Utils.readLines("../inputs/input_7.txt"));
    String base = w.part1();
    System.out.println(base);
    System.out.println(w.part2(base));
  }
}
