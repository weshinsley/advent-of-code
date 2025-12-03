package d19;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  ArrayList<String> rep_from = new ArrayList<String>();
  ArrayList<String> rep_to = new ArrayList<String>();
  String molecule = "";
  
  void parse(ArrayList<String> input) {
    int i=0;
    while (input.get(i).length()>0) {
      String[] bits = input.get(i).split("\\s+");
      rep_from.add(bits[0]);
      rep_to.add(bits[2]);
      i++;
    }
    molecule = input.get(i+1);
  }
 
  int advent19a() {
    ArrayList<String> result = new ArrayList<String>();
    for (int i=0; i<rep_from.size(); i++) {
      int j=0;
      while (molecule.indexOf(rep_from.get(i), j)>=0) {
        j = molecule.indexOf(rep_from.get(i),j);
        String m2 = molecule.substring(0,j) +
                    rep_to.get(i) +
                    molecule.substring(j+rep_from.get(i).length());
        if (result.indexOf(m2)==-1) result.add(m2);
        j++;
      }
    }
    return result.size();
  }
  
  int replace_all(String a, String b) {
    int r=0;
    if ((rep_to.indexOf(a)==-1) || (rep_from.indexOf(b)==-1)) {
      System.out.println("Dubious rule, "+a+" => "+b);
    }
    while (molecule.indexOf(a)>=0) {
      molecule = molecule.substring(0, molecule.indexOf(a)) + b +
          molecule.substring(molecule.indexOf(a)+a.length());
      r++;
    }
    return r;
  }
  
  int advent19b() {
    // This is going to be quite a specific solution, not a general one.
    // I can't figure out how to do it very generally, although I'm
    // probably on the right lines:-
    
    // Rn, Ar, and Y only appear in the "to" column.
    // Rn and Ar always exist together, sometimes with Y between them.
    // which looks a bit like (...) and (...,...)
    
    // Then, the Si out of Si(F,F) can't be changed, so Si(..,..) has
    // to become Si(F,F) somehow... and I carried on visually.
    
    int r=0;
    
    // Just for easy reading.
    molecule = molecule.replace("Rn", "(");
    molecule = molecule.replace("Ar", ")");
    molecule = molecule.replace("Y",  ",");
    
    for (int i=0; i<rep_to.size(); i++) {
      rep_to.set(i, rep_to.get(i).replace("Rn", "("));
      rep_to.set(i, rep_to.get(i).replace("Ar", ")"));
      rep_to.set(i, rep_to.get(i).replace("Y", ","));
    }
    
    r += replace_all("CaF", "F");
    r += replace_all("BF", "Mg");
    r += replace_all("Si(Mg)", "Ca");
    r += replace_all("CaF","F");
    r += replace_all("Si(F)", "P");
    r += replace_all("Si(Mg)", "Ca");
    r += replace_all("Si(F,F)", "Ca");
    r += replace_all("CaF", "F");
    r += replace_all("Th(F)", "Al");
    r += replace_all("Si(F,F)", "Ca");
    r += replace_all("BP", "Ti");
    r += replace_all("TiMg", "Mg");
    r += replace_all("Si(Mg)", "Ca");
    r += replace_all("P(F)", "Ca");
    r += replace_all("Si(F)", "P");
    r += replace_all("PMg", "F");
    r += replace_all("CaF", "F");
    r += replace_all("SiTh", "Ca");
    r += replace_all("CaCa", "Ca");
    r += replace_all("TiTi", "Ti");
    r += replace_all("CaF", "F");
    r += replace_all("BF", "Mg");
    r += replace_all("TiMg", "Mg");
    r += replace_all("SiAl", "F");
    r += replace_all("PTi", "P");
    r += replace_all("PMg", "F");
    r += replace_all("CaF", "F");
    r += replace_all("Si(F,F)", "Ca");
    r += replace_all("P(F)", "Ca");
    r += replace_all("CaCa", "Ca");
    r += replace_all("PB", "Ca");
    r += replace_all("CaCa", "Ca");
    r += replace_all("CaF", "F");
    r += replace_all("P(F)", "Ca");
    r += replace_all("CaF", "F");
    r += replace_all("ThF", "Al");
    r += replace_all("C(F)", "N");
    r += replace_all("NAl", "e");
    return r;
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_19.txt");
    puzzle p = new puzzle();
    p.parse(input);
    System.out.println(p.advent19a());
    System.out.println(p.advent19b()); 
   

  }
}
