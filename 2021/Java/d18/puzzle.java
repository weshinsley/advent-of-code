package d18;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {

  String explode_string(String s) {
    StringBuffer sb = new StringBuffer(s);
    
    int depth = 0;
    for (int i = 0; i < sb.length(); i++) {
      if (sb.charAt(i) == '[') {
        depth++;
      } else if (sb.charAt(i) == ']') {
        depth--;
      } else if (sb.charAt(i) != ',') {
        
      }
      if (depth == 5) {
        String[] s2 = sb.substring(i + 1, sb.indexOf("]", i)).split(",");
        
        int j = sb.indexOf("]", i); 
        while ((j < sb.length()) && ("[,]".indexOf(sb.charAt(j)) != -1)) j++;
        if (j < sb.length()) {
          int j2 = j;
          while ((j2 < sb.length()) && ("[,]".indexOf(sb.charAt(j2)) == -1)) j2++;
          int right_num = Integer.parseInt(sb.substring(j, j2));
          right_num = right_num + Integer.parseInt(s2[1]);
          sb.delete(j, j2);
          sb.insert(j, right_num);
        }
        
        sb.delete(i, sb.indexOf("]", i) + 1);
        sb.insert(i, 0);
        
        j = i - 1;
        while ((j >= 0) && ("[,]".indexOf(sb.charAt(j)) != -1)) j--;
        if (j >= 0) {
          int j2 = j;
          while ((j2 >= 0) && ("[,]".indexOf(sb.charAt(j2)) == -1)) j2--;
          int left_num = Integer.parseInt(sb.substring(j2 +1, j+1));
          left_num = left_num + Integer.parseInt(s2[0]);
          sb.delete(j2 + 1, j+1);
          sb.insert(j2 + 1, left_num);
        }
        
        break;
      }
    }
    return sb.toString();
  }
  
  String split_string(String s) {
    StringBuffer sb = new StringBuffer(s);
    for (int i=0; i<sb.length(); i++) {
      if ("[,]".indexOf(sb.charAt(i)) == -1) {
        int j=i+1;
        while ("[,]".indexOf(sb.charAt(j)) == -1) j++;
        int num = Integer.parseInt(sb.substring(i, j));
        if (num >= 10) {
          sb.delete(i, j);
          sb.insert(i, "[" + num / 2 + "," + (num - (num / 2)) + "]");
          break;
        }
        while ("[,]".indexOf(sb.charAt(i)) == -1) i++;
      }
    }
    return sb.toString();
  }
  
  String add_string(String s1, String s2) {
    return "["+s1+","+s2+"]";
  }
  
  String reduce(String s) {
    while(true) {
      String s2 = explode_string(s);
      while (!s.equals(s2)) {
        s = s2;
        s2 = explode_string(s2);
      }
      s = s2;
      s2 = split_string(s2);
      if (s.equals(s2)) { 
        return s2;
      }
      s = s2;
    }    
  }
   
  public String assemble(ArrayList<String> input)  {
    String thing;
    thing = input.get(0);
    for (int j = 1; j<input.size(); j++) { 
      thing = reduce(add_string(thing, input.get(j)));
    }
    return thing;
  }
  
  public int part2(ArrayList<String> input) {
    int min_mag = 0;
    for (int i=0; i<input.size(); i++) {
      for (int j=0; j<input.size(); j++) {
        if (i!=j) {
          ArrayList<String> bodge = new ArrayList<String>();
          bodge.add(input.get(i));
          bodge.add(input.get(j));
          min_mag = Math.max(min_mag, get_magnitude(assemble(bodge)));
        }
      }
    }
    return min_mag;
  }
  
  int get_magnitude(String s) {
    int mag = 0;
    if (s.startsWith("[")) {
      s = s.substring(1, s.length() - 1);

    // Split into two - find unnested comma.
      
      int dep = 0;
      int comma = -1;
      for (int j=0; j < s.length(); j++) {
        if (s.charAt(j) == '[') {
          dep++;
        } else if (s.charAt(j) == ']') {
          dep--;
        } else if ((s.charAt(j) == ',') && (dep == 0)) {
          comma = j;
          break;
        }
      }
      String left = s.substring(0, comma);
      String right = s.substring(comma + 1);
      
      if (left.indexOf(",") == -1) {
        mag = mag + (Integer.parseInt(left) * 3);
      } else {
        mag = mag + (get_magnitude(left) * 3);
      }
      if (right.indexOf(",") == -1) {
        mag = mag + (Integer.parseInt(right) * 2);
      } else {
        mag = mag + (get_magnitude(right) * 2);
      }
    }
    return mag;
  }
  
  ArrayList<String> read_input(String f) throws Exception {
    ArrayList<String> buf = new ArrayList<String>();
    BufferedReader br = new BufferedReader(new FileReader(f));
    String s = br.readLine();
    while (s!=null) {
      buf.add(s);
      s = br.readLine();
    }
    br.close();
    return buf;
  }
  
  /**
   * @param args
   * @throws Exception
   */
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    
    ArrayList<String> input = W.read_input("../inputs/input_18.txt");
    long time = System.currentTimeMillis();
    System.out.print("Part 1: "+W.get_magnitude(W.assemble(input)));
    long t2 = System.currentTimeMillis();
    System.out.println(" in "+(t2-time)+" ms");
    
    time = System.currentTimeMillis();
    System.out.print("Part 2: "+W.part2(input));
    t2 = System.currentTimeMillis();
    System.out.println(" in "+(t2-time)+" ms");
  }
}
