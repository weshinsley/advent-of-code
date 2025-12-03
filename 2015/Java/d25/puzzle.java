package d25;

import tools.Utils;

public class puzzle {
  
  static long advent25(int r, int c) {
    int n=0;
    for (int i=2; i<=c; i++) n+=i;
    for (int j=0; j<r-1; j++) n+=(c+j);
    long x = 20151125;
    for (long i=0; i<n; i++)
      x = (x * 252533) % 33554393;
    return x;
  }
    
  public static void main(String[] args) throws Exception {
    String input = Utils.readLines("../inputs/input_25.txt").get(0);
    input = input.replace("To continue, please consult the code grid in the manual.  Enter the code at row ", "");
    input = input.replace(", column ", ",");
    input = input.replace(".", "");
    String[] bits = input.split(",");
    System.out.println(advent25(Integer.parseInt(bits[0]), Integer.parseInt(bits[1])));
  }
}
