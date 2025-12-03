package d18;

import java.util.ArrayList;

import tools.WesUtils;

public class puzzle {
  static final byte OPEN = 0;
  static final byte TREES = 1;
  static final byte LUMBERYARD = 2;
  byte[][] area;
  
  void parseInput(ArrayList<String> input) {
    area = new byte[input.size()][input.get(0).length()];
    for (int j=0; j<input.size(); j++) {
      String s = input.get(j);
      for (int i=0; i<s.length(); i++) {
        char c = s.charAt(i);
        if (c=='.') area[j][i] = OPEN;
        else if (c=='|') area[j][i] = TREES;
        else if (c=='#') area[j][i] = LUMBERYARD;
      }
    }
  }
  
  boolean count(int i, int j, byte type, int stop) {
    byte count=0;
    for (int y = Math.max(0,  j - 1); y<=Math.min(j + 1,  area.length-1); y++) {
      for (int x= Math.max(0,  i - 1); x<=Math.min(i + 1, area[0].length-1); x++) {
        if (((x!=i) || (y!=j)) && (area[y][x] == type)) {
          count++;
          if (count>=stop) break;
        }
      }
    }
    return (count>=stop);
  }
  
  int getScore() {
    int lumber=0;
    int wooded=0;
    for (byte j=0; j<area.length; j++) {
      for (byte i=0; i<area[j].length; i++) {
        if (area[j][i]==LUMBERYARD) lumber++;
        if (area[j][i]==TREES) wooded++;
      }
    }
    return lumber * wooded;        
  }
  
  byte[][] turn() {
    byte[][] area2 = new byte[area.length][area[0].length];
    for (int j=0; j<area.length; j++) {
      for (int i=0; i<area[0].length; i++) {
        if (area[j][i] == OPEN) {
          if (count(i,j,TREES, 3)) area2[j][i]=TREES;
          else area2[j][i] = OPEN;
        } else if (area[j][i] == TREES) {
          if (count(i,j,LUMBERYARD, 3)) area2[j][i]=LUMBERYARD;
          else area2[j][i]=TREES;
        } else {
          if ((count(i,j,LUMBERYARD, 1)) && (count(i,j,TREES, 1))) area2[j][i]=LUMBERYARD;
          else area2[j][i]=OPEN;
        }
      }
    }
    return area2;
  }
 
  int[] findSeq(ArrayList<Integer> nums) {
    int[] remember = new int[5];
    int[] next_index = new int[5];
    for (int i=0; i<5; i++) {
      remember[i]=nums.get(0);
      nums.remove(0);
      next_index[i] = nums.indexOf(remember[i]);
    }
    for (int i=4; i>=0; i--) nums.add(0, remember[i]);
    if ((next_index[0]!=-1) && (next_index[0] == next_index[1]) && (next_index[1] == next_index[2])
                            && (next_index[2] == next_index[3]) && (next_index[3] == next_index[4])) {
      
      int[] seq = new int[next_index[0]+1];
      for (int i=0; i<next_index[0]+1; i++) seq[i] = nums.get(i);
      return seq;
    }
    return null;
  }
  
  int advent18b(long turns, int burn_in, int max_len) {
    ArrayList<Integer> remember = new ArrayList<Integer>();
    int turn=0;
    int[] seq;
    while (true) {
      area = turn();
      remember.add(getScore());
      if (remember.size()>max_len) {
        remember.remove(0);
      }
      if (turn>burn_in) {
        seq = findSeq(remember);
        if (seq!=null) break;
      }
      turn++;
    }
    return seq[(int)((turns - (remember.size() + turn - 2)) % seq.length)];
  }
  
  int advent18(long turns) {
    int[] seq = new int[] {187404,189150,190125,192603,192831,196578,199424,202572,205461,208884,212040,214520,218673,219566,219919,
                           221340, 219745,218584,219096,216948,210888,206568,204417,202980,198990,197819,192465,191478};
    if (turns <= 565) return advent18a(turns);
    
    else return seq[(int)((turns-566) % seq.length)];
  }

  int advent18a(long turns) {
    for (long turn=0; turn<turns; turn++) area = turn();
    return getScore();
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.parseInput(WesUtils.readLines("../inputs/input_18.txt"));
    System.out.println("Part (a) : "+w.advent18(10));
    w.parseInput(WesUtils.readLines("../inputs/input_18.txt"));
    System.out.println("Part (b) - my specific case:  "+w.advent18(1000000000L));
    w.parseInput(WesUtils.readLines("../inputs/input_18.txt"));
    System.out.println("Part (b) - sequence analysis: "+w.advent18b(1000000000L, 600, 100));
  }
}
