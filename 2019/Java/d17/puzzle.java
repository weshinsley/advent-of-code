package d17;

import java.util.ArrayList;
import d09.wes_computer;

public class puzzle {
  static final int[] dx = new int[] {0,1,0,-1};
  static final int[] dy = new int[] {-1,0,1,0};

  ArrayList<StringBuffer> get_screen(wes_computer wc) {
    ArrayList<StringBuffer> screen = new ArrayList<StringBuffer>();
    int y = 0;
    while (wc.output_available()) {
      long ch = wc.read_output();
      if (y >= screen.size()) screen.add(new StringBuffer());
      if (ch == 10) y++;
      else screen.get(y).append((char) ch);
    }
    screen.remove(screen.size() - 1);
    return screen;
  }
  
 // void print_screen(ArrayList<StringBuffer> screen) {
    //for (int j = 0; j < screen.size(); j++) System.out.println(screen.get(j));
  //}

  int intersections(ArrayList<StringBuffer> screen) {
    int sum = 0;
    for (int j = 1; j < screen.size() - 1; j++) {
      for (int i = 1; i < screen.get(j).length() - 1; i++) {
       
        if ((screen.get(j).charAt(i)=='#') && (screen.get(j-1).charAt(i)=='#') && (screen.get(j+1).charAt(i)=='#')
          && (screen.get(j).charAt(i+1)=='#') && (screen.get(j).charAt(i-1)=='#')) {
          sum+=(i*j);
          screen.get(j).setCharAt(i, 'O');
        }
      }
    }
    //print_screen(screen);
    return sum; 
  }
 
  int solve1(wes_computer wc) {
    wc.run();
    return intersections(get_screen(wc));
  }
  
  void terminal(wes_computer wc, String entry) {
    while (wc.output_available()) { wes_computer.printch(wc.read_output()); }
    wc.add_input(wes_computer.toLongs(entry+"!"));
    System.out.println(entry+"\n");
    wc.run();
  }
   
  void solve2(wes_computer wc) {
    // Umm... I solved the map easily by hand.
    // Coding it will take somewhat longer...
    
    String abc = "A,B,A,C,A,A,C,B,C,B";
    String proga = "L,12,L,8,R,12";
    String progb = "L,10,L,8,L,12,R,12";
    String progc = "R,12,L,8,L,10";
    wc.poke(0,2);
    wc.run();
    terminal(wc, abc);
    terminal(wc, proga);
    terminal(wc, progb);
    terminal(wc, progc);
    terminal(wc, "n");
    int count10s = 0;
    while (wc.output_available()) { 
      char ch = (char) wc.read_output();
      if (ch == 10) count10s++; else count10s=0;
      if (count10s == 2) break;
      //wes_computer.printch(ch);
    }
    System.out.println(wc.read_output());
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    System.out.println("Part 1: "+W.solve1(wes_computer.wc_from_input("../inputs/input_17.txt")));
    System.out.println("Part 2:\n\n");
    W.solve2(wes_computer.wc_from_input("../inputs/input_17.txt"));
  }
}
