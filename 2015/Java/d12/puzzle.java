package d12;

import tools.Utils;
import tools.json.Json;
import tools.json.JsonArray;
import tools.json.JsonNum;
import tools.json.JsonObject;
import tools.json.JsonValue;

public class puzzle {
  
  static int advent12a(String s) {
    s = s.replaceAll("[a-zA-Z{}:\\[\\]\"]",",");
    String[] bits = s.split(",");
    int c=0;
    for (int i=0; i<bits.length; i++) {
      if (bits[i].length()>0) c += Integer.parseInt(bits[i]);
    }
    return c;
  }
  
  
  static int traverse(JsonValue jv) {
    if (jv.isNumber()) return ((JsonNum)jv).getInt();
    else if (jv.isArray()) {
      int t=0;
      for (int i=0; i<((JsonArray)(jv)).size(); i++) {
        t+= traverse(((JsonArray)(jv)).get(i));
      }
      return t;
    } else if (jv.isObject()) {
      int t=0;
      for (int i=0; i<((JsonObject)(jv)).size(); i++) {
        t+= traverse(((JsonObject)(jv)).getValue(i));
      }
      return t;
    }
    return 0;
  }
  
  static int advent12a(Json j) {
    int total = 0;
    if (j.getParent().isArray()) {
      JsonArray ja = (JsonArray) (j.getParent());
      for (int i=0; i<ja.size(); i++) {
        total += traverse(ja.get(i));
        
      }
    } else if (j.getParent().isObject()) {
      JsonObject jo = (JsonObject) (j.getParent());
      for (int i=0; i<jo.size(); i++) { 
        total += traverse(jo.getValue(i));
      }
    }
    return total;
  }
  
  static int traverse2(JsonValue jv) {
    if (jv.isNumber()) return ((JsonNum)jv).getInt();
    else if (jv.isArray()) {
      int t=0;
      for (int i=0; i<((JsonArray)(jv)).size(); i++) {
        t+= traverse2(((JsonArray)(jv)).get(i));
      }
      return t;
    } else if (jv.isObject()) {
      int t=0;
      if (!((JsonObject)jv).someValueIs("\"red\"")) {
        for (int i=0; i<((JsonObject)(jv)).size(); i++) {
          t+= traverse2(((JsonObject)(jv)).getValue(i));
        }
      }
      return t;
    }
    return 0;
  }
  static int advent12b(Json j) {
    int total = 0;
    if (j.getParent().isArray()) {
      JsonArray ja = (JsonArray) (j.getParent());
      for (int i=0; i<ja.size(); i++) {
        total += traverse2(ja.get(i));
        
      }
    } else if (j.getParent().isObject()) {
      JsonObject jo = (JsonObject) (j.getParent());
      if (!jo.someValueIs("\"red\"")) {
        for (int i=0; i<jo.size(); i++) { 
          total += traverse2(jo.getValue(i));
        }
      }
    }
    return total;
  }
  
  public static void main(String[] args) throws Exception {
    String input = Utils.readLines("../inputs/input_12.txt").get(0);
    System.out.println("Hack method: "+advent12a(input));
    Json j = new Json(input);
    System.out.println("Json method: "+advent12a(j));
    System.out.println(advent12b(j));
  }
}
