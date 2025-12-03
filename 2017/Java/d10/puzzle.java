package d10;
import tools.Utils;

public class puzzle {
  
  int[] hash(int[] input, int length, int rounds) {
    int[] thing = new int[length];
    for (int i=0; i<length; i++) thing[i] = i;
    int skip = 0;
    int pos = 0;
    for (int r=0; r<rounds; r++) {
      for (int i=0; i<input.length; i++) {
        int[] rev = new int[input[i]];
        for (int j=pos; j<pos + input[i]; j++) {
          rev[j-pos] = thing[j % length];
        }
        for (int j=pos; j<pos + input[i]; j++) {
          thing[j % length] = rev[(input[i] - 1) - (j - pos)]; 
        }
        pos = (pos + skip + input[i]) % length;
        skip++;
      }
    }
    return thing;
  }
  
  int part1(int[] input, int length) {
    int[] thing = hash(input, length, 1);
    return thing[0] * thing[1];
  }
  
  public String part2(String input) {
    int[] new_input = new int[input.length() + 5];
    for (int i=0; i<input.length(); i++) {
      new_input[i] = (int) input.charAt(i);
    }
    new_input[new_input.length - 1] = 23;
    new_input[new_input.length - 2] = 47;
    new_input[new_input.length - 3] = 73;
    new_input[new_input.length - 4] = 31;
    new_input[new_input.length - 5] = 17;
    int[] thing = hash(new_input, 256, 64);
    StringBuilder hex = new StringBuilder();
    for (int i=0; i<16; i++) {
      int val = thing[i*16];
      for (int j=1; j<16; j++) {
        val = val ^ thing[(i*16) + j];
      }
      String h = Integer.toHexString(val);
      if (h.length()==1) hex.append("0");
      hex.append(h);
    }
    return hex.toString();
  }
  
  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    int[] input = Utils.readIntGrid_ji("../inputs/input_10.txt", ",")[0];
    System.out.println(w.part1(input, 256));
    System.out.println(w.part2(Utils.readLines("../inputs/input_10.txt").get(0)));
   }
}
