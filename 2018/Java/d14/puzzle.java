package d14;

import tools.WesUtils;

public class puzzle {
  void advent14(String input, boolean part_b) {
    int input_len = input.length();
    int input_val = Integer.parseInt(input);
    String input_str = String.valueOf(input);
    StringBuilder list = new StringBuilder("37");
    int elf_pos1 = 0;
    int elf_pos2 = 1;
    byte elf1 = 3;
    byte elf2 = 7;
    int r=0;
    while (r < input_val) {
      int digits_added = 1;
      int combine = elf1 + elf2;
      int i = list.length();
      list.append(combine % 10);
      combine = combine / 10;
      while (combine>0) {
        list.insert(i,combine % 10);
        combine = combine / 10;
        digits_added++;
      }
      i = list.length();
      elf_pos1 = (elf_pos1 + (1 + elf1)) % i;
      elf_pos2 = (elf_pos2 + (1 + elf2)) % i;
      elf1 = Byte.parseByte(""+list.charAt(elf_pos1));
      elf2 = Byte.parseByte(""+list.charAt(elf_pos2));
      if (!part_b) r++;
      else {
        if (list.length()>input_len + digits_added) {
          if (list.substring(list.length()-(input_len + digits_added)).indexOf(input_str)>=0) {
            System.out.println(list.indexOf(input_str));
            return;
          }
        }
      }
    }
    if (!part_b) System.out.println(list.substring(input_val, input_val + 10));
  }

  
  public static void main(String[] args) throws Exception {
    String input = WesUtils.readLines("../inputs/input_14.txt").get(0);
    new puzzle().advent14(input, false);
    new puzzle().advent14(input, true);
  }
}
