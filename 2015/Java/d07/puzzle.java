package d07;

import java.util.ArrayList;

import tools.Utils;

public class puzzle {
  static byte AND = 1;
  static byte OR = 2;
  static byte LSHIFT = 3;
  static byte RSHIFT = 4;
  static byte EQ = 5;
  static byte NOT = 6;
  
  class Wire {
    String name;
    Gate feeder;
    int val = -1;
    Wire(String n) { name = n; }
    int eval() {
      if (val==-1) val = feeder.eval();
      return val;
    }
  }
  
  abstract class Gate {
    abstract int eval();
  }
  
  class GateSingle extends Gate {
    Wire in1;
    int type;
    GateSingle(Wire i1, int t) { in1 = i1; type = t;}
    int eval() { 
      if (type == NOT) return 65535 - in1.eval();
      else return in1.eval();
    }
  }
  
  class GateDouble extends GateSingle {
    GateDouble(Wire i1, Wire i2, byte t) {
      super(i1, t);
      in2 = i2;
    }
    Wire in2;
    
    int eval() {
      if (type == AND) return in1.eval() & in2.eval();
      else if (type == OR) return in1.eval() | in2.eval();
      else if (type == LSHIFT) return (in1.eval() << in2.eval()) & 65535;
      else return in1.eval() >> in2.eval();
    }
  }
 
  Wire getWire(ArrayList<Wire> wires, String n) {
    for (int i=0; i<wires.size(); i++) {
      if (wires.get(i).name.equals(n)) return wires.get(i); 
    }
    Wire w = new Wire(n);
    wires.add(w);
    return w;
  }
  
  ArrayList<Wire> buildTree(ArrayList<String> input) {
    ArrayList<Wire> wires = new ArrayList<Wire>();
    for (int i=0; i<input.size(); i++) {
      String[] bits = input.get(i).split("\\s+");
      // 1 -> x  or a -> b
      if (bits.length == 3) {
        if (Utils.isInt(bits[0])) {
          getWire(wires, bits[2]).val = Integer.parseInt(bits[0]);
        }
        else getWire(wires, bits[2]).feeder = new GateSingle(getWire(wires, bits[0]), EQ);
      }
      // NOT 1 -> x or NOT a -> b
      else if (bits.length == 4) {
        if (Utils.isInt(bits[1])) getWire(wires, bits[2]).val = 65535 - Integer.parseInt(bits[1]);
        else getWire(wires, bits[3]).feeder = new GateSingle(getWire(wires, bits[1]), NOT);
      }
      
      // x op y -> z
      else if (bits.length == 5) {
        Wire o1 = getWire(wires, bits[4]);
        Wire w1, w2;
        if (Utils.isInt(bits[0])) {
          w1 = new Wire("");
          w1.val = Integer.parseInt(bits[0]);
        } else w1 = getWire(wires,bits[0]);
        if (Utils.isInt(bits[2])) {
          w2 = new Wire("");
          w2.val = Integer.parseInt(bits[2]);
        } else w2 = getWire(wires,bits[2]);
        
        if (bits[1].equals("AND")) o1.feeder = new GateDouble(w1, w2, AND);
        else if (bits[1].equals("OR")) o1.feeder = new GateDouble(w1, w2, OR);
        else if (bits[1].equals("LSHIFT")) o1.feeder = new GateDouble(w1, w2, LSHIFT);
        else if (bits[1].equals("RSHIFT")) o1.feeder = new GateDouble(w1, w2, RSHIFT);
      }
    }
    return wires;
  }
  
  int advent7a(ArrayList<String> input) {
    return getWire(buildTree(input), "a").eval();
  }
  
  int advent7b(ArrayList<String> input, int a) {
    ArrayList<Wire> wires = buildTree(input);
    getWire(wires,"b").val=a;
    return getWire(wires, "a").eval();
  }
  
  public static void main(String[] args) throws Exception {
    ArrayList<String> input = Utils.readLines("../inputs/input_7.txt");
    puzzle p = new puzzle();
    int a = p.advent7a(input);
    System.out.println(a);
    System.out.println(p.advent7b(input, a));
  }
}
