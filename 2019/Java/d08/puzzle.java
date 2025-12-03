package d08;

import java.io.BufferedReader;
import java.io.FileReader;

public class puzzle {
  String input;

  void readInput(String file) throws Exception {
    BufferedReader br = new BufferedReader(new FileReader(file));
    input = br.readLine();
    br.close();
  }

  int solve1(String data, int wid, int hei) {
    int layers = data.length() / (wid*hei);
    int index = 0;
    int least_zeros = Integer.MAX_VALUE;
    int best_answer = 0;
    for (int i = 0; i < layers; i++) {
      int n0 = 0,n1 = 0,n2 = 0;
      for (int y = 0; y < hei; y++) {
        for (int x = 0; x < wid; x++) {
          char ch = data.charAt(index++);
          if (ch == '0') n0++;
          else if (ch == '1') n1++;
          else if (ch == '2') n2++;
        }
      }
      if (n0 < least_zeros) {
        least_zeros = n0;
        best_answer = n1*n2;
      }
    }
    return best_answer;
  }

  String solve2(String data, int wid, int hei) {
    StringBuilder sb = new StringBuilder();
    int layers = data.length() / (wid * hei);
    char[] pixel = new char[] {' ','#','T'};
    for (int y = 0; y < hei; y++) {
      for (int x = 0; x < wid; x++) {
        int col = -1;
        for (int layer = 0; layer < layers; layer++) {
          col = data.charAt((layer * wid * hei) + (wid * y) + x);
          if (col != '2') break;
        }
        sb.append(pixel[col - '0']);
      }
      sb.append('\n');
    }
    return sb.toString();
  }

  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.readInput("../inputs/input_8.txt");
    System.out.println("Part 1 : " + W.solve1(W.input, 25,  6));
    if (!W.solve2("0222112222120000",2, 2).equals(" #\n# \n")) System.out.println("Test failed");
    System.out.println("Part 2 : \n\n" + W.solve2(W.input, 25, 6));
  }
}
