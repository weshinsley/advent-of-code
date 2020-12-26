package tools.json;

class INT {
  private int i=0;
  public int get() { return i; }
  public void set(int _i) { i = _i; }
  public void inc() { i++; }
  public void inc(int j) { i+=j; }
  public INT(int _i) { i = _i; } 
  
}

class JsonString extends JsonValue {
  String s;
  String get() { return s; }
  
  JsonString(String _s) { s = new String(_s); }
  
  static JsonString parseString(String s, INT i) {
    StringBuffer sb = new StringBuffer();
    if (s.charAt(i.get())!='"') {
      System.out.println("Expected string; quote not found at "+s.substring(i.get()));
      return null;
    } else {
      sb.append('"');
      i.inc();
      boolean done = false;
      while (!done) {
        while ((s.charAt(i.get()) != '"') && (s.charAt(i.get()) != '\\')) {
          sb.append(s.charAt(i.get()));
          i.inc();
        }
        if (s.charAt(i.get()) == '"') {
          sb.append('"');
          i.inc();
          done = true;
        } else if (s.charAt(i.get()) == '\\') {
          i.inc();
          char c = s.charAt(i.get());
          if (c=='t') sb.append('\t');
          else if (c=='n') sb.append('\n');
          else if (c=='r') sb.append('\r');
          else if (c=='\\') sb.append('\\');
          else if (c=='"') sb.append('"');
          else if (c=='/') sb.append('/');
          else if (c=='b') sb.append('\b');
          else if (c=='f') sb.append('\f');
          else if (c=='u') {
            sb.append(s.substring(i.get()-1,i.get()+5).toCharArray()[0]);
            i.inc(4);
          } else System.out.println("Unknown escape character in string, at "+s.substring(i.get()));
          i.inc(1);
        } else System.out.println("Expected character in string, at "+s.substring(i.get()));
      }
      return new JsonString(sb.toString());
    }
  }    
}

class JsonConst extends JsonValue {
  public static final byte JSON_TRUE = 5;
  public static final byte JSON_FALSE = 6;
  public static final byte JSON_NULL = 7;
  byte type;
  JsonConst(byte t) { type = t; }
    
  static JsonConst JsonTrue() { return new JsonConst(JSON_TRUE); }
  static JsonConst JsonFalse() { return new JsonConst(JSON_FALSE); }
  static JsonConst JsonNull() { return new JsonConst(JSON_NULL); }
}

public class Json {
  JsonValue parent;
  public JsonValue getParent() { return parent; }
  public Json(String s) {
    s = s.trim();
    if (s.charAt(0) == '[') parent = JsonArray.parseArray(s,new INT(0)); 
    else if (s.charAt(0) == '{') {
      parent = JsonObject.parseObject(s,new INT(0));
    } else System.out.println("Unknown start symbol");
  }
}
