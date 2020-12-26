package tools.json;

public class JsonNum extends JsonValue {
  String n;
  String get() { return n; }
  JsonNum(String _s) { n = new String(_s); }
  public double getDouble() { return Double.parseDouble(n); }
  public int getInt() { return Integer.parseInt(n); } 
  
  static JsonNum parseNum(String s, INT i) {
    StringBuffer sb = new StringBuffer();
    
    if (s.charAt(i.get()) == '-') { sb.append("-"); i.inc(); }
    
    if (("123456789").indexOf(s.charAt(i.get()))>=0) {
      sb.append(s.charAt(i.get()));
      i.inc();
      while (("0123456789").indexOf(s.charAt(i.get()))>=0) {
        sb.append(s.charAt(i.get()));
        i.inc();   
      }
      
    } else if (s.charAt(i.get()) == '0') {
      sb.append(s.charAt(i.get()));
      i.inc();
      
    } else {
      System.out.println("Unrecognised number format at "+s.substring(i.get()));
      return null;
    }
    
    if (s.charAt(i.get()) == '.') {
      sb.append(".");
      i.inc();
      if (("0123456789").indexOf(s.charAt(i.get()))==-1) {
        System.out.println("Unrecognised number format after dec point: "+s.substring(i.get()));
        return null;
      }
      while (("0123456789").indexOf(s.charAt(i.get()))>=0) {
        sb.append(s.charAt(i.get()));
        i.inc();
      }  
    }
    
    if ((s.charAt(i.get())=='e') || (s.charAt(i.get()) == 'E')) {
      sb.append(s.charAt(i.get()));
      i.inc();
      if ((s.charAt(i.get())=='+') || (s.charAt(i.get()) == '-')) {
        sb.append(s.charAt(i.get()));
        i.inc();
      }
      if (("0123456789").indexOf(s.charAt(i.get()))==-1) {
        System.out.println("Unrecognised number format in exponent: "+s.substring(i.get()));
        return null;
      } 
      while (("0123456789").indexOf(s.charAt(i.get()))>=0) {
        sb.append(s.charAt(i.get()));
        i.inc();
      }  
    }
    return new JsonNum(sb.toString());             
  }
}