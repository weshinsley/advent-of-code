package d16;

import java.io.BufferedReader;
import java.io.FileReader;

public class puzzle {
    
  String to_string(int[] i, int start) {
    StringBuffer sb = new StringBuffer();
    for (int j=0; j<8; j++) sb.append(String.valueOf(i[j+start]));
    return sb.toString();
  }
  
  int[] to_array(String s) {
    int[] i = new int[s.length()];
    for (int j=0; j<s.length(); j++) i[j] = Integer.parseInt(""+s.charAt(j));
    return i;
  }
  
  int[] readInput(String f) throws Exception{
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    br.close();
    return(to_array(s));
  }
  
  int[] fft(int[] input) {
    
    int[] output = new int[input.length];
    int[] base = new int[] {0, 1, 0, -1};
    for (int row = 0; row<input.length; row++) {
      int val=0;
      int base_pointer=0;
      int freq = 1 + row;
      int count = 1;
      int col_start = 0;
      // Skip first
      
      if (count != freq) {
        col_start=freq-1;
      }
      count = 0;
      base_pointer++;

      for (int col=col_start; col<input.length; col++) {
        
        val+=input[col] * base[base_pointer];
        //System.out.print(input[col]+"*"+base[base_pointer]+"  +  ");
        count++;
        if (count == freq) {
          count = 0;
          base_pointer = (base_pointer + 1) % base.length;
          if (base[base_pointer] == 0) {
            col+=freq;
            base_pointer++;
          }
        }
      }
      //System.out.println(" = " + Math.abs(val % 10));
      
      output[row] = Math.abs(val) % 10;
    }
    return output;
  }
  
  String solve1(int[] input, int phases) {
    for (int i=0; i<phases; i++) input = fft(input);
    return to_string(input, 0);
  }
  
  
  String solve1(String sinput, int phases) {
    return solve1(to_array(sinput), phases);
  }
  
  // solve2 only works when the offset is in the second half of the list...
  // (hence all the pattern elements are 1)
  
  String solve2(int[] small_input, int phases) {
    int offset = small_input[6]+(10*small_input[5])+(100*small_input[4])+(1000*small_input[3])+
        (10000*small_input[2]) + (100000*small_input[1]) + (1000000*small_input[0]);
    int[] big_input = new int[10000 * small_input.length];
    int p=0;
    for (int i=0; i<10000; i++) 
      for (int j=0; j<small_input.length; j++)
        big_input[p++] = small_input[j];
    for (int i=0; i<phases; i++) {
      int sum=0;
      for (int j=big_input.length-1; j>=offset; j--) {
        sum += big_input[j];
        big_input[j]=sum % 10;
      }
    }
    
    return to_string(big_input, offset);
    
  }
  
   String solve2(String s ,int phases) {
     return solve2(to_array(s), phases);
   }
  
   
  void test(boolean part1) {
    if (part1) {
      if (!solve1("12345678", 1).equals("48226158")) System.out.println("12345678 (1) is not 48226158");
      if (!solve1("12345678", 2).equals("34040438")) System.out.println("12345678 (1) is not 34040438"); 
      if (!solve1("12345678", 3).equals("03415518")) System.out.println("12345678 (1) is not 03415518"); 
      if (!solve1("12345678", 4).equals("01029498")) System.out.println("01029498 (1) is not 01029498");
      if (!solve1("80871224585914546619083218645595", 100).equals("24176176")) System.out.println("Big Example 1 doesn't start with 24176176");
      if (!solve1("19617804207202209144916044189917", 100).equals("73745418")) System.out.println("Big Example 2 doesn't start with 73745418");
      if (!solve1("69317163492948606335995924319873", 100).equals("52432133")) System.out.println("Big Example 3 doesn't start with 52432133");
    } else {
      if (!solve2("03036732577212944063491565474664", 100).equals("84462026")) System.out.println("Part 2 Example 1 is not 84462026");
      if (!solve2("02935109699940807407585447034323", 100).equals("78725270")) System.out.println("Part 2 Example 2 is not 78725270");
      if (!solve2("03081770884921959731165446850517", 100).equals("53553731")) System.out.println("Part 2 Example 3 is not 53553731");
    }
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.test(true);
    System.out.println("Part 1: "+W.solve1(W.readInput("../inputs/input_16.txt"),100));
    W.test(false);
    System.out.println("Part 2: "+W.solve2(W.readInput("../inputs/input_16.txt"),100));
  }
}
