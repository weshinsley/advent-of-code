package tools.json;

public abstract class JsonValue {
  
  static JsonValue parseValue(String s, INT i) {
    if (s.charAt(i.get()) == '"') return JsonString.parseString(s, i);
    else if (s.charAt(i.get()) == '[') return JsonArray.parseArray(s,i);
    else if (s.charAt(i.get()) == '{') return JsonObject.parseObject(s, i);
    else if (("0123456789-").indexOf(s.charAt(i.get()))>=0) return JsonNum.parseNum(s, i);
    else if (s.startsWith("true",i.get())) { i.inc(4); return JsonConst.JsonTrue(); }
    else if (s.startsWith("false",i.get())) { i.inc(5); return JsonConst.JsonFalse(); }
    else if (s.startsWith("null",i.get())) { i.inc(4); return JsonConst.JsonNull(); }
    else {
      System.out.println("Value not recognised at "+s.substring(i.get()));
      return null;
    }    
  }
  
  public boolean isArray() { return (this instanceof JsonArray); }
  public boolean isNumber() { return (this instanceof JsonNum); }
  public boolean isString() { return (this instanceof JsonString); }
  public boolean isObject() { return (this instanceof JsonObject); }

}
