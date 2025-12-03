package d05;

import java.util.Arrays;

import tools.WesUtils;

public class puzzle {
  char[] input;

  int advent5a(char[] the_input, int len) {
    int i=0; 
    int j=1;
    int chars = len;
    while (j<len) {
      if (Math.abs(the_input[i]-the_input[j])==32) {
        the_input[i]=0;
        the_input[j]=0;
        while ((i>=0) && (the_input[i]==0)) i--;
        if (i<0) i=0;
        j++;
        chars-=2;
      } else {
        i=j;
        j++;
      }
    }
      
    return chars;
  }

  int advent5b() {
    int best = Integer.MAX_VALUE;
    char[] newinput = new char[input.length];
    for (int i=0; i<26; i++) {
      int len = 0;
      for (int j=0; j<input.length; j++)
        if ((input[j]!=65+i) && (input[j]!=97+i)) 
          newinput[len++] = input[j];
      best = Math.min(best,advent5a(newinput, len));
    }
    return best;
  }

  public static void main(String[] args) throws Exception {
    puzzle w = new puzzle();
    w.input = WesUtils.readLines("../inputs/input_5.txt").get(0).toCharArray();
    char[] input_copy = Arrays.copyOf(w.input, w.input.length); 
    
    long time = -System.currentTimeMillis();
    System.out.print(w.advent5a(input_copy, w.input.length));
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" millis)");
    
    time = -System.currentTimeMillis();
    System.out.print(w.advent5b());
    time += System.currentTimeMillis();
    System.out.println(" ("+time+" millis)");
    
  }
}
