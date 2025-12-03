package tools.json;

import java.util.ArrayList;

public class JsonArray extends JsonValue {
  private ArrayList<JsonValue> values = new ArrayList<JsonValue>();
  public JsonValue get(int i) { return values.get(i); }
  public int size() { return values.size(); }
  
  static JsonArray parseArray(String s, INT i) {
    if (s.charAt(i.get())=='[') i.inc();
    else {
      System.out.println("Expected array [ - got "+s.substring(i.get()));
      return null;
    }
   
    JsonArray ja = new JsonArray();
    while(s.charAt(i.get())!=']') {
      ja.values.add(JsonValue.parseValue(s, i));
      if (s.charAt(i.get())==',') i.inc();
    }
    i.inc();
    return ja;
  }
}
