import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class d18 {

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
  
  void test(int i1, int i2) {
    if (i1!=i2) {
      System.out.println("FAIL: "+i1+" != "+i2);
    } else {
      System.out.println("PASS: "+i1+" == "+i2);
    }
  }
  
  void test(String i1, String i2) {
    if (!i1.equals(i2)) {
      System.out.println("FAIL: "+i1+" != "+i2);
    } else {
      System.out.println("PASS: "+i1+" == "+i2);
    }
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
    d18 W = new d18();
    
    W.test(W.add_string("[1,2]", "[[3,4],5]"), "[[1,2],[[3,4],5]]");
    W.test(W.explode_string("[[[[[9,8],1],2],3],4]"), "[[[[0,9],2],3],4]");
    W.test(W.explode_string("[7,[6,[5,[4,[3,2]]]]]"), "[7,[6,[5,[7,0]]]]");
    W.test(W.explode_string("[[6,[5,[4,[3,2]]]],1]"), "[[6,[5,[7,0]]],3]");
    W.test(W.explode_string("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"), "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]");
    W.test(W.explode_string("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"), "[[3,[2,[8,0]]],[9,[5,[7,0]]]]");
    W.test(W.split_string("[[[[0,7],4],[15,[0,13]]],[1,1]]"), "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]");
    W.test(W.split_string("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"), "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]");
    
    W.test(W.reduce(W.add_string("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]")), "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]");
    W.test(W.assemble(W.read_input("../inputs/d18-test1.txt")),
        "[[[[1,1],[2,2]],[3,3]],[4,4]]");
    W.test(W.assemble(W.read_input("../inputs/d18-test2.txt")),
        "[[[[3,0],[5,3]],[4,4]],[5,5]]");
    W.test(W.assemble(W.read_input("../inputs/d18-test3.txt")),
        "[[[[5,0],[7,4]],[5,5]],[6,6]]");
    W.test(W.assemble(W.read_input("../inputs/d18-test4.txt")),
        "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]");
    W.test(W.assemble(W.read_input("../inputs/d18-test5.txt")),
        "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]");
      
    W.test(W.get_magnitude("[[9,1],[1,9]]"), 129);
    W.test(W.get_magnitude("[[1,2],[[3,4],5]]"), 143);
    W.test(W.get_magnitude("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"), 1384);    
    W.test(W.get_magnitude("[[[[1,1],[2,2]],[3,3]],[4,4]]"), 445); 
    W.test(W.get_magnitude("[[[[3,0],[5,3]],[4,4]],[5,5]]"), 791);
    W.test(W.get_magnitude("[[[[5,0],[7,4]],[5,5]],[6,6]]"), 1137);    
    W.test(W.get_magnitude("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"), 3488); 
    W.test(W.get_magnitude("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"), 4140);
    ArrayList<String> test5 = W.read_input("../inputs/d18-test5.txt");
    
    W.test(W.get_magnitude(W.assemble(test5)),4140);
    W.test(W.part2(test5), 3993);

    System.out.println("\n");
    ArrayList<String> input = W.read_input("../inputs/d18-input.txt");
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
