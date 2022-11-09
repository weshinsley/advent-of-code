package d15;

import java.util.ArrayList;

import tools.Utils;

public class wes {
  long gena_start;
  long genb_start;
  long gena_factor = 16807;
  long genb_factor = 48271;
  long wrap = 2147483647;
  
  
  void parse(ArrayList<String> input) {
    gena_start = Integer.parseInt(input.get(0).substring(24));
    genb_start = Integer.parseInt(input.get(1).substring(24));
  }
  
  int part1() {
    long gena = gena_start;
    long genb = genb_start;
    int hit=0;
    for (long x = 0; x < 40000000; x++) {
      gena = (gena * gena_factor) % wrap;
      genb = (genb * genb_factor) % wrap;
      if ((gena & 65535) == (genb & 65535)) hit++;
    }
    return hit;
  }
  
  int part2() {
    long gena = gena_start;
    long genb = genb_start;
    int hit=0;
    for (long x = 0; x < 5000000; x++) {
      do {
        gena = (gena * gena_factor) % wrap;
      } while ((gena % 4) != 0);
      
      do {
        genb = (genb * genb_factor) % wrap;
      } while ((genb % 8) != 0);
      
      if ((gena & 65535) == (genb & 65535)) hit++;
    }
    return hit;
  }
  
  void test() throws Exception {
    gena_start = 65;
    genb_start = 8921;
    Utils.test(part1(),  588);
    Utils.test(part2(),  309);
  }
  
  public static void main(String[] args) throws Exception {
    wes w = new wes();
    w.test();
    w.parse(Utils.readLines("../R/15/input.txt"));
    System.out.println(w.part1());
    System.out.println(w.part2());
  }
}
