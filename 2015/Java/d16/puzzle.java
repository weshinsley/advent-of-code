package d16;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  class Sue {
    int no;
    ArrayList<String> things = new ArrayList<String>();
    ArrayList<Integer> count = new ArrayList<Integer>();
    int getCount(int i) { return count.get(i); }
    int getThing(String t) { return things.indexOf(t); }
    
    Sue(String line) {
      line = line.replace(",", " ");
      line = line.replace(":", " ");
      String[] bits = line.split("\\s+");
      no = Integer.parseInt(bits[1]);
      for (int i=2; i<bits.length; i+=2) {
        things.add(bits[i]);
        count.add(Integer.parseInt(bits[i+1]));
      }
    }
  }

  ArrayList<Sue> sues = new ArrayList<Sue>();
  
  void parse(ArrayList<String> input) {
    for (int i=0; i<input.size(); i++) sues.add(new Sue(input.get(i)));
  }
  
  ArrayList<Sue> getSues(String thing, int no, byte op, ArrayList<Sue> options) {
    ArrayList<Sue> viable = new ArrayList<Sue>(); 
    for (int i=0; i<options.size(); i++) {
      Sue sue = options.get(i);
      int index = sue.getThing(thing);
      if (index==-1) viable.add(sue);
      else {
        if ((op==OP_EQ) && (sue.getCount(index)==no)) viable.add(sue);
        else if ((op==OP_GT) && (sue.getCount(index)>no)) viable.add(sue);
        else if ((op==OP_LT) && (sue.getCount(index)<no)) viable.add(sue);
      }
    }
    return viable;
  }
  
  final static byte OP_EQ = 1;
  final static byte OP_GT = 2;
  final static byte OP_LT = 3;
  
  int advent16a() {
    ArrayList<Sue> answer = getSues("children", 3, OP_EQ, sues);
    answer = getSues("cats", 7, OP_EQ, answer);
    answer = getSues("samoyeds",2, OP_EQ, answer);
    answer = getSues("pomeranians", 3, OP_EQ, answer);
    answer = getSues("akitas", 0, OP_EQ, answer);
    answer = getSues("vizslas", 0, OP_EQ, answer);
    answer = getSues("goldfish", 5, OP_EQ, answer);
    answer = getSues("trees", 3, OP_EQ, answer);
    answer = getSues("cars", 2, OP_EQ, answer);
    answer = getSues("perfumes", 1, OP_EQ, answer);
    return answer.get(0).no;
  }
  
  int advent16b() {
    ArrayList<Sue> answer = getSues("children", 3, OP_EQ, sues);
    answer = getSues("cats", 7, OP_EQ, answer);
    answer = getSues("samoyeds",2, OP_EQ, answer);
    answer = getSues("pomeranians", 3, OP_LT, answer);
    answer = getSues("akitas", 0, OP_EQ, answer);
    answer = getSues("vizslas", 0, OP_EQ, answer);
    answer = getSues("goldfish", 5, OP_LT, answer);
    answer = getSues("trees", 3, OP_GT, answer);
    answer = getSues("cars", 2, OP_GT, answer);
    answer = getSues("perfumes", 1, OP_EQ, answer);
    return answer.get(0).no;
  }

  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_16.txt");
    puzzle p = new puzzle();
    p.parse(input);
    System.out.println(p.advent16a());
    System.out.println(p.advent16b());
  }
}
