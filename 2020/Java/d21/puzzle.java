package d21;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

public class puzzle {
  
  ArrayList<String> allergens = new ArrayList<String>();
  ArrayList<HashSet<String>> might_be_in = new ArrayList<HashSet<String>>();
  HashMap<String, Integer> ingredients = new HashMap<String, Integer>();
  HashSet<String> used = new HashSet<String>(); 
      
  void read_input(String f) throws Exception {
    List<String> lines = Files.readAllLines(new File(f).toPath());
    allergens.clear();
    might_be_in.clear();
    ingredients.clear();
    for (int i=0; i<lines.size(); i++) {
      String s = lines.get(i);
      String[] bits = s.split("\\(contains ");
      bits[1] = bits[1].replace(")", "");
      List<String> ings = Arrays.asList(bits[0].split("\\s+"));
      String[] alls = bits[1].split(", ");
      for (int j=0; j<alls.length; j++) {
        int index = allergens.indexOf(alls[j]);
        if (index == -1) {
          allergens.add(alls[j]);
          HashSet<String> options = new HashSet<String>();
          for (int k=0; k<ings.size(); k++) options.add(ings.get(k));
          might_be_in.add(options);
        } else {
          HashSet<String> options = might_be_in.get(index);
          HashSet<String> options2 = new HashSet<String>();
          for (String opt : options)
            if (ings.contains(opt)) options2.add(opt);
          might_be_in.set(index,  options2);
        }
      }
      for (int j=0; j<ings.size(); j++) {
        if (!ingredients.containsKey(ings.get(j))) 
          ingredients.put(ings.get(j), 1);
        else {
          int count = ingredients.get(ings.get(j));
          ingredients.remove(ings.get(j));
          ingredients.put(ings.get(j), count + 1);
        }
      }
    }
  }
    
  int solve1() {
    used.clear();
    boolean done=false;
    while (!done) {
      done=true;
      for (int i=0; i<allergens.size(); i++) {
        if (might_be_in.get(i).size() == 1) {
          for (String single : might_be_in.get(i)) {
            used.add(single);
            for (int j=0; j<allergens.size(); j++) {
              if (i!=j) might_be_in.get(j).remove(single);
            }
          }
        } else done = false;
      }
    }
    int count=0;
    for (Map.Entry<String, Integer> ing : ingredients.entrySet()) {
      if (!used.contains(ing.getKey())) count += ing.getValue();
    }
    return count;
  }
  
  String solve2() {
    String result = "";
    while (allergens.size()>0) {
      int best = 0;
      for (int i=1; i<allergens.size(); i++) {
        if (allergens.get(i).compareTo(allergens.get(best)) < 0) best = i;
      }
      result += "," + might_be_in.get(best);
      might_be_in.remove(best);
      allergens.remove(best);
    }
    result = result.replaceAll("\\[", "");
    result = result.replaceAll("\\]", "");
    return result.substring(1);
  }
  
   void run() throws Exception {
     System.out.println("Advent of Code 2020 - Day 21\n----------------------------");
     read_input("../inputs/input_21.txt");
     System.out.println("Part 1: "+solve1());
     System.out.println("Part 2: "+solve2());

   }

   public static void main(String[] args) throws Exception {
     new puzzle().run();
   }
}
