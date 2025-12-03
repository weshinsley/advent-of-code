package d13;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  
  class Person {
    String name;
    ArrayList<Person> others = new ArrayList<Person>();
    ArrayList<Integer> happiness = new ArrayList<Integer>();
    Person(String n) { name = new String(n); }
  }
  
  ArrayList<Person> family = new ArrayList<Person>();
  
  int score(ArrayList<Person> seating) {
    int score=0;
    for (int i=0; i<seating.size(); i++) {
      Person mid = seating.get(i);
      Person right = seating.get((i+1) % seating.size());
      Person left = seating.get((i + (seating.size()-1)) % seating.size());
      score += mid.happiness.get(mid.others.indexOf(left));
      score += mid.happiness.get(mid.others.indexOf(right));
    }
    return score;
  }
  
  public void parse(ArrayList<String> input) {
    ArrayList<String> sfamily = new ArrayList<String>();
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split("\\s+");
      if (sfamily.indexOf(bits[0])==-1) sfamily.add(bits[0]);
    }
    for (int i=0; i<sfamily.size(); i++) {
      family.add(new Person(sfamily.get(i)));
    }
    for (int i=0; i<input.size(); i++) {
      String s = input.get(i);
      s = s.replace("would gain ", "");
      s = s.replace("would lose ", "-");
      s = s.replace("happiness units by sitting next to ", "");
      s = s.replace(".","");
      String[] bits = s.split("\\s+");
      Person p1 = family.get(sfamily.indexOf(bits[0]));
      Person p2 = family.get(sfamily.indexOf(bits[2]));
      p1.others.add(p2);
      p1.happiness.add(Integer.parseInt(bits[1]));
    }
  }
  
  public int permute(int best_score, ArrayList<Person> spares, ArrayList<Person> seated) {
    if (spares.size()==0) {
      return Math.max(best_score, score(seated));
    } else {
      for (int i=0; i<spares.size(); i++) {
        Person p = spares.get(i);
        spares.remove(p);
        seated.add(p);
        best_score = Math.max(best_score, permute(best_score, spares, seated));
        seated.remove(p);
        spares.add(p);
      }
      return best_score;
    }
  }
  
  public int advent13a() {
    return permute(0, family, new ArrayList<Person>());
  }
  
  public int advent13b() {
    Person p = new Person("Me");
    for (int i=0; i<family.size(); i++) {
      p.happiness.add(0);
      p.others.add(family.get(i));
      family.get(i).others.add(p);
      family.get(i).happiness.add(0);
    }
    family.add(p);
    return permute(0, family, new ArrayList<Person>());
  }
  
  
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_13.txt");
    puzzle p = new puzzle();
    p.parse(input);
    System.out.println(p.advent13a());
    System.out.println(p.advent13b());
  }
}
