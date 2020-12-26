package d25;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

public class wes {
  
  long get_loop_size(long subject_num, long public_key) {
    long loop_size = 0;
    long val=1;
    while (val != public_key) {
      val = (val * subject_num) % 20201227;
      loop_size++;
    }     
    return loop_size;
  }
  
  long encrypt(long subject_num, long loop_size) {
    long val = 1;
    for (int i=0; i<loop_size; i++)
      val = (val * subject_num) % 20201227;
    return val;
  }
  
  void run() throws Exception {
    if (get_loop_size(7, 5764801)!=8) System.out.println("Test 1 failed");
    if (get_loop_size(7, 17807724)!=11) System.out.println("Test 2 failed");
    if (encrypt(5764801, get_loop_size(7, 17807724)) != 14897079L) System.out.println("Test 3 failed");
    if (encrypt(17807724, get_loop_size(7, 5764801)) != 14897079L) System.out.println("Test 4 failed");
    
    List<String> wes = Files.readAllLines(new File("d25/wes-input.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 25\n----------------------------");
    System.out.println("Part 1: "+encrypt(Long.parseLong(wes.get(0)), 
                                          get_loop_size(7, Long.parseLong(wes.get(1)))));
  }

  public static void main(String[] args) throws Exception {
    new wes().run();
  }
}
