package d17;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  int advent17a(ArrayList<Integer> input) {
    int success=0;
    int max = (int) Math.pow(2, input.size());
    int[] powers = new int[input.size()];
    for (int i=0; i<input.size(); i++) powers[i] = (int) Math.pow(2, i);
    
    for (int i=0; i<max; i++) {
      int sum=0;
      for (int j=0; j<input.size(); j++) {
        if ((i & powers[j])>0) sum+=input.get(j);
        if (sum>150) {
          break;
        } 
      }
      if (sum==150) success++;
    }
    return success;
  }
  
  void advent17b(ArrayList<Integer> input) {
    int[] sizes = new int[20];
    long max = (int) Math.pow(2, input.size());
    long[] powers = new long[input.size()];
    for (int i=0; i<input.size(); i++) powers[i] = (long) Math.pow(2, i);
    
    for (int i=0; i<max; i++) {
      int sum=0;
      byte sum_bits=0;
      for (int j=0; j<input.size(); j++) {
        if ((i & powers[j])>0) {
          sum+=input.get(j);
          sum_bits++;
        }
        if (sum>150) {
          break;
        } 
      }
      if (sum==150) sizes[sum_bits]++;
    }
    
    for (int i=0; i<sizes.length; i++) {
      if (sizes[i]>0) {
        System.out.println("Used "+i+" containers "+sizes[i]+" times");
        break;
      }
    }
   
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<Integer> input = Utils.toIntArrayList(Utils.readLines("../inputs/input_17.txt"));
    puzzle p = new puzzle();
    System.out.println(p.advent17a(input));
    p.advent17b(input);
  }
}
