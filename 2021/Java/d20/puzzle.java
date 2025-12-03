package d20;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;

public class puzzle {
  
  String alg;
  ArrayList<StringBuffer> image;
  
  void read_input(String f) throws Exception {
    image = new ArrayList<StringBuffer>();
    BufferedReader br = new BufferedReader(new FileReader(new File(f)));
    alg = br.readLine();
    br.readLine();
    String s = br.readLine();
    while (s!=null) {
      if (s.length() > 0) {
        image.add(new StringBuffer(s));
      }
      s = br.readLine();
    }
    br.close();
  }

  public void pad(int no) {
    for (int k=0; k<no; k++) {
      for (int j=0; j<image.size(); j++) {
        image.get(j).insert(0, ".");
        image.get(j).append(".");
      }
      String blank= "";
      for (int i=0; i<image.get(0).length(); i++) blank+=".";
      image.add(0, new StringBuffer(blank));
      image.add(new StringBuffer(blank));
    }
  }
  
    
  public void step(int t) {
    ArrayList<StringBuffer> newImage = new ArrayList<StringBuffer>();
    for (int j=0; j<image.size(); j++) {
      newImage.add(new StringBuffer(image.get(j).toString()));
    }
    
    for (int j=1; j<image.size() - 1; j++) {
      for (int i=1; i<image.get(j).length() - 1; i++) {
      
        int sum = (image.get(j-1).charAt(i-1) == '#' ? 256 : 0) +
                  (image.get(j-1).charAt(i) == '#' ? 128 : 0) +
                  (image.get(j-1).charAt(i+1) == '#' ? 64 : 0) +
                  (image.get(j).charAt(i-1) == '#' ? 32 : 0) +
                  (image.get(j).charAt(i) == '#' ? 16 : 0) +
                  (image.get(j).charAt(i+1) == '#' ? 8 : 0) +
                  (image.get(j+1).charAt(i-1) == '#' ? 4 : 0) +
                  (image.get(j+1).charAt(i) == '#' ? 2 : 0) +
                  (image.get(j+1).charAt(i+1) == '#' ? 1 : 0);
   
        newImage.get(j).setCharAt(i, alg.charAt(sum));
      }
    }
    
    // Hack for infinite edges - it seems I get two columns of '#'
    
    if (t % 2 == 1) {
      for (int j=0; j<newImage.size(); j++) {
        newImage.get(j).setCharAt(1, '.');
        newImage.get(j).setCharAt(newImage.get(j).length()-2, '.');
      }
    }
    
    image = newImage;
  }
  
  int solve(int iter) {
    pad(iter * 2);
    int sum = 0;
    for (int z=0; z<iter; z++) {
      step(z);
	}
    sum = 0;
    for (int j=0; j<image.size(); j++) {
      for (int i=0; i<image.get(j).length(); i++) {
        sum += (image.get(j).charAt(i) == '#') ? 1 : 0;
      }
    }
    return sum;
  }
   
  public static void main(String[] args) throws Exception {
    puzzle W = new puzzle();
    W.read_input("../inputs/input_20.txt");
    System.out.println(W.solve(2));
    W.read_input("../inputs/input_20.txt");
    System.out.println(W.solve(50));
  }
  

}
