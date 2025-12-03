package d08;

import java.util.ArrayList;
import java.util.HashMap;

import tools.Utils;

public class puzzle {
  
  boolean eval_if(int val, String op, int cmp) {
    if (op.equals(">=")) return (val >= cmp);
    if (op.equals("==")) return (val == cmp);
    if (op.equals("<=")) return (val <= cmp);
    if (op.equals("<")) return (val < cmp);
    if (op.equals(">")) return (val > cmp);
    if (op.equals("!=")) return (val != cmp);
    System.out.println("ERROR - "+op);
    return false;
  }
  
  int eval_set(int val, String op, int val2) {
    if (op.equals("inc")) return val + val2;
    if (op.equals("dec")) return val - val2;
    System.out.println("ERROR - "+op);
    return -1;
  }
  
  public int[] solve(ArrayList<String> input) {
    int max_val = Integer.MIN_VALUE;
    HashMap<String, Integer> regs = new HashMap<String, Integer>();
    for (int i=0; i<input.size(); i++) {
      String[] s = input.get(i).trim().split("\\s+");
      if (!regs.containsKey(s[0])) regs.put(s[0], 0);
      if (!regs.containsKey(s[4])) regs.put(s[4], 0);
      if (eval_if(regs.get(s[4]), s[5], Integer.parseInt(s[6]))) {
        int res = eval_set(regs.get(s[0]), s[1], Integer.parseInt(s[2]));
        regs.put(s[0], res);
        max_val = Math.max(max_val,  res);
      }
    }
    
    int max_final_val = Integer.MIN_VALUE;
    for (int value : regs.values()) {
      max_final_val = Math.max(max_final_val,  value);
    }
  
    return new int[] {max_final_val, max_val};
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    ArrayList<String> input = Utils.readLines("../inputs/input_8.txt");
    int[] res = w.solve(input);
    System.out.println(res[0]);
    System.out.println(res[1]);
  }
}
