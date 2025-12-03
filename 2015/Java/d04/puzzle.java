package d04;
import java.math.BigInteger;
import java.security.MessageDigest;

import tools.Utils;

public class puzzle {
  
  public static int advent4a(String s, String starts) throws Exception {
    MessageDigest md = MessageDigest.getInstance("MD5");
    int i=0;
    while (true) {
      byte[] bytesOfMessage = (s+String.valueOf(i)).getBytes("UTF-8");
      md.update(bytesOfMessage, 0, bytesOfMessage.length);
      String hex = String.format("%1$032X",  new BigInteger(1, md.digest()));
      if (hex.startsWith(starts)) break;
      i++;
    }
    return i;
      
  }
  public static void main(String[] args) throws Exception {
    String input = Utils.readLines("../inputs/input_4.txt").get(0);
    Utils.test(advent4a("abcdef", "00000"),609043);
    Utils.test(advent4a("pqrstuv", "00000"), 1048970);
    System.out.println(advent4a(input,"00000"));
    System.out.println(advent4a(input,"000000"));
  }
}
