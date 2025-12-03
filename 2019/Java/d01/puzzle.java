package d01;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  
  ArrayList<Integer> readInput(String s) throws Exception {
    ArrayList<Integer> input = new ArrayList<Integer>();
    BufferedReader br = new BufferedReader(new FileReader(s));
    String s2 = br.readLine();
    while (s2!=null) {
      input.add(Integer.parseInt(s2));
      s2 = br.readLine();
    }
    br.close();
    return input;
  }

  int solve(boolean part1, int mass) {
    if (part1) return (mass/3) -2;
    else return recursive_fuel(mass);
  }

  int solve(boolean part1, ArrayList<Integer> input) {
    int total = 0;
    for (int i=0; i<input.size(); i++) {
      total += solve(part1, input.get(i));
    }
    return total;
  }

  int recursive_fuel(int mass) {
    int f = (mass/3) - 2;
    if (f > 0) return f + recursive_fuel(f);
    else return 0;
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    ArrayList<Integer> input = W.readInput("../inputs/input_1.txt");
    System.out.println("Part1: " + W.solve(true, input));
    System.out.println("Part2: " + W.solve(false, input));
  }
}
