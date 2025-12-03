package d25;

import java.io.File;
import java.nio.file.Files;
import java.util.List;

public class puzzle {
  
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
    List<String> wes = Files.readAllLines(new File("../inputs/input_25.txt").toPath());
    System.out.println("Advent of Code 2020 - Day 25\n----------------------------");
    System.out.println("Part 1: "+encrypt(Long.parseLong(wes.get(0)), 
                                          get_loop_size(7, Long.parseLong(wes.get(1)))));
  }

  public static void main(String[] args) throws Exception {
    new puzzle().run();
  }
}
