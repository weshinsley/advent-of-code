package d14;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;


public class puzzle {
  class Stuff {
    long quantity;
    String thing;
    Stuff(long q, String t) { quantity = q; thing = new String(t); }
  }
  
  class Reaction {
    Stuff output;
    Stuff[] input;
    
    Reaction(String in) {
      String[] bits = in.replaceAll(" => ", ",").split(",");
      input = new Stuff[bits.length-1];
      for (int i=0; i<bits.length; i++) {
        String[] bits2 = bits[i].trim().split("\\s+");
        if (i<bits.length-1) input[i] = new Stuff(Integer.parseInt(bits2[0].trim()), bits2[1].trim());
        else output = new Stuff(Integer.parseInt(bits2[0].trim()), bits2[1].trim());
      }
    }
  }
    
  ArrayList<Reaction> readInput(String f) throws Exception{
    BufferedReader br = new BufferedReader(new FileReader(f));
    ArrayList<Reaction> rr = new ArrayList<Reaction>();
    String s = br.readLine();
    while (s!=null) {
      rr.add(new Reaction(s));
      s = br.readLine();
    }
    br.close();
    return rr;
  }
  
  Reaction findReaction(ArrayList<Reaction> rr, String make) {
    for (int i=0; i<rr.size(); i++) 
      if (rr.get(i).output.thing.equals(make)) return rr.get(i);
    return null;
  }
  
  HashMap<String, Stuff> needed = new HashMap<String, Stuff>();
  HashMap<String, Stuff> stock = new HashMap<String, Stuff>();
  
  void recurse(ArrayList<Reaction> rr, String thing_to_make) {
    long amount_needed = needed.get(thing_to_make).quantity;
    if (!stock.containsKey(thing_to_make)) stock.put(thing_to_make, new Stuff(0, thing_to_make));
    long stock_avail = stock.get(thing_to_make).quantity;
    Reaction r = findReaction(rr, thing_to_make);
    int count = (int) Math.ceil((amount_needed - stock_avail) / (double) r.output.quantity);
    stock.get(thing_to_make).quantity += (count * r.output.quantity);
    for (int i=0; i<r.input.length; i++) {
      if (!needed.containsKey(r.input[i].thing)) needed.put(r.input[i].thing,  new Stuff(0, r.input[i].thing));
      needed.get(r.input[i].thing).quantity += count * r.input[i].quantity;
    }
    for (int i=0; i<r.input.length; i++) {
      if (!r.input[i].thing.equals("ORE")) recurse(rr, r.input[i].thing);
    }
  }
    
  long solve1(ArrayList<Reaction> rr, long how_much_fuel) {
    needed.clear();
    stock.clear();
    needed.put("FUEL", new Stuff(how_much_fuel, "FUEL"));
    recurse(rr, "FUEL");
    return needed.get("ORE").quantity;
  }
  
  long solve2(ArrayList<Reaction> rr) {
    long ore = 1000000000000L;
    
    long fuel = 1L;
    while (solve1(rr, fuel) <= ore) fuel*=2;
    long start = (fuel/2);
    long end = fuel;
    while (start <= end) {
      int mid = (int) ((start + end) / 2);
      if (solve1(rr, mid) < ore) start = mid + 1;
      else if (solve1(rr, mid) > ore) end = mid-1; 
    }
    return start-1;
  }
 
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    ArrayList<Reaction> mine = W.readInput("../inputs/input_14.txt");
    System.out.println("Part 1 : "+W.solve1(mine ,1L));
    System.out.println("Part 2 : "+W.solve2(mine));
  }
}
