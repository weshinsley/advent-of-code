package d10;
import tools.Utils;

public class wes {
  
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
  
  public void test() throws Exception {
    Utils.test(part1(new int[] {3, 4, 1, 5}, 5), 12);
    Utils.test(part2(""), "a2582a3a0e66e6e86e3812dcb672a272");
    Utils.test(part2("AoC 2017"), "33efeb34ea91902bb2f59c9920caa6cd");
    Utils.test(part2("1,2,3"), "3efbe78a8d82f29979031a4aa0b16a9d");
    Utils.test(part2("1,2,4"), "63960835bcdc130f0b66d7ff4f6a5a8e");
  }

  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    int[] input = Utils.readIntGrid_ji("../R/10/input.txt", ",")[0];
    System.out.println(w.part1(input, 256));
    System.out.println(w.part2(Utils.readLines("../R/10/input.txt").get(0)));
   }
}
