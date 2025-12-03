package d12;

import java.util.ArrayList;
import java.util.LinkedList;

import tools.WesUtils;

public class puzzle {
  LinkedList<Boolean> state = new LinkedList<Boolean>();
  boolean[] rules = new boolean[32]; 
  int first_pot;
  
  void parseInput(ArrayList<String> input) {
    state.clear();
    String sstate = input.get(0).substring(15);
    for (int i=0; i<sstate.length(); i++) {
      state.add(sstate.charAt(i) == '#');
    }
    for (int i=2; i<input.size(); i++) {
      String[] bits = input.get(i).split(" => ");
      rules[((bits[0].charAt(0)=='#')?16:0) + ((bits[0].charAt(1)=='#')?8:0) + ((bits[0].charAt(2)=='#')?4:0) + ((bits[0].charAt(3)=='#')?2:0) + ((bits[0].charAt(4)=='#')?1:0)] = (bits[1].charAt(0)=='#');
    }
    first_pot = 0;
   
  }
    
  long advent12a(long gens) throws Exception {
    parseInput(WesUtils.readLines("../inputs/input_12.txt"));
    for (long i=0; i<gens; i++) {
      while (state.getFirst() || state.get(1) || state.get(2) || state.get(3) || state.get(4)) { state.addFirst(false); first_pot--; }
      int lgth = state.size();
      while (state.getLast() || state.get(lgth-2) || state.get(lgth-3) || state.get(lgth-4)) { state.addLast(false); lgth++; }
      LinkedList<Boolean> nextState = new LinkedList<Boolean>(state);
      byte rule_no = (byte) ((state.get(0)?16:0) + (state.get(1)?8:0) + (state.get(2)?4:0) + (state.get(3)?2:0) + (state.get(4)?1:0));
      nextState.set(2, rules[rule_no]);
      for (int j=0; j<nextState.size()-5; j++) {
        rule_no = (byte) (((rule_no & 15) << 1) | (state.get(j+4)?1:0));
        nextState.set(j+2, rules[rule_no]);
      }
      state = nextState;
    }
    long total=0;
    for (int z=first_pot; z<first_pot + state.size(); z++) {
      if (state.get(z - first_pot)) total+=z;
    }
    return total;
    
  }
  
  long advent12b(long gens) throws Exception {
    // Not sure how long it takes to stabilise into constant growth
    // From observation, mine took about 192, so...
    
    long arbitrary = 250;
    if (gens<arbitrary) return advent12a(gens);
    long d1 = advent12a(arbitrary);
    long d2 = advent12a(arbitrary+1);
    return d1 + ((d2 - d1) * (gens - arbitrary));
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    System.out.println(w.advent12a(20));
    System.out.println(w.advent12b(50000000000L));
  }
}
