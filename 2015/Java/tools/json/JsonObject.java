package tools.json;

import java.util.ArrayList;

public class JsonObject extends JsonValue {
  private ArrayList<String> names = new ArrayList<String>();
  private ArrayList<JsonValue> values = new ArrayList<JsonValue>();
  public int size() { return names.size(); }
  public JsonValue getValue(int i) { return values.get(i); }
  public String getName(int i) { return names.get(i); }
  
  static JsonObject parseObject(String s, INT i) {
    if (s.charAt(i.get())=='{') i.inc();
    else {
      System.out.println("Expected object { - got "+s.substring(i.get()));
      return null;
    }
    JsonObject jo = new JsonObject();
    while (s.charAt(i.get())!='}') {
      jo.names.add(JsonString.parseString(s, i).get());
      if (s.charAt(i.get())==':') {
        i.inc();
      } else {
        System.out.println("Expected : at "+s.substring(i.get()));
        return null;
      }
      jo.values.add(JsonValue.parseValue(s,i));
      if (s.charAt(i.get()) == ',') i.inc();
    }
    i.inc();
    return jo;  
  }
  
  public boolean someValueIs(String s) {
    for (int i=0; i<values.size(); i++) {
      if (values.get(i).isString()) {
        if (((JsonString) (values.get(i))).get().equals(s)) {
          return true;
        }
      }
    }
    return false;
  }
}