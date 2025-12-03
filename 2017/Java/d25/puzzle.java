package d25;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import tools.Utils;

public class puzzle {
  class Rule {
    char next;
    char write;
    char move;
    
    Rule (char w, char m, char n) {
      write = w;
      move = m;
      next = n;
    }
  }
  
  HashMap<String, Rule> rules = new HashMap<String, Rule>();
  char state;
  int finish;
  
  void parse(ArrayList<String> input) {
    rules.clear();
    state = input.get(0).charAt(15);
    finish = Integer.parseInt(
      input.get(1).replaceAll("Perform a diagnostic checksum after ", "").
                   replaceAll(" steps.", ""));
    int i = 2;
    while (i < input.size()) {
      if (input.get(i).trim().equals("")) {
        i++;
        continue;
      }
      rules.put(input.get(i).charAt(9)+ "0", new Rule(input.get(i + 2).charAt(22),
                                                      input.get(i + 3).charAt(27),
                                                      input.get(i + 4).charAt(26)));
      
      rules.put(input.get(i).charAt(9)+ "1", new Rule(input.get(i + 6).charAt(22),
          input.get(i + 7).charAt(27),
          input.get(i + 8).charAt(26)));

      i+=10;
    } 
  }
  
  int run() {
    HashSet<Integer> tape = new HashSet<Integer>();
    int tc = 0;
    for (int i=0; i<finish; i++) {
      char tape_read = tape.contains(tc)?'1':'0';
      Rule rule = rules.get("" + state+tape_read);
      if ((rule.write == '0') && (tape_read == '1')) tape.remove(tc); 
      else if ((rule.write == '1') && (tape_read == '0')) tape.add(tc);
      tc += (rule.move == 'r') ? 1 : -1;
      state = rule.next;
    }
    
    return tape.size();
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_25.txt");
    w.parse(input);
    System.out.println(w.run());
  }
}
