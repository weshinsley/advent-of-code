
public class T2016_16 {
  public static void main(String[] args) {
    StringBuilder sb = new StringBuilder("00101000101111010");
    int i = sb.length();
    while (i<35651584) {
      StringBuilder sb2 = new StringBuilder(sb.toString());
      sb.append("0");
      for (int j=0; j<sb2.length(); j++) sb.append(sb2.charAt(sb2.length()-(j+1))=='0'?"1":"0");
      i = sb.length();
    }
    sb.setLength(35651584);
    i=35651584;
    while (i%2 == 0) {
      StringBuilder sb2 = new StringBuilder();
      for (int j=0; j<sb.length(); j+=2) {
        sb2.append(sb.charAt(j)==sb.charAt(j+1)?'1':'0');
      }
      sb=new StringBuilder(sb2.toString());
      i=sb.length();
    }
    System.out.println("Result: "+sb.toString());
  }
}
