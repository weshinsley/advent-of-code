package d13;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.awt.image.BufferedImage;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class wes_screen extends JFrame {
  public static final int BLANK = 0;
  public static final int WALL = 1;
  public static final int BLOCK = 2;
  public static final int PADDLE = 3;
  public static final int BALL = 4;
  FontMetrics fm;
  Font courier = new Font("Courier New", Font.BOLD, 36);
  
  
  private static final long serialVersionUID = 1L;
  ImagePanel ip = new ImagePanel();
 
  class ImagePanel extends JPanel {
    private static final long serialVersionUID = 1L;
    
    BufferedImage bi = new BufferedImage(688,480,BufferedImage.TYPE_3BYTE_BGR);
    
    ImagePanel() {
      setPreferredSize(new Dimension(688,480));
      setDoubleBuffered(true);
    }
    public void paintComponent(Graphics g) {
      //super.paintComponent(g);
      g.drawImage(bi,  0,  0, null);
    }  
    
    public void update( Graphics g ) {  
      paint(g);
    }
  }
  
  public void draw(int x, int y, int object) {
    x*=16;
    y*=16;
    Graphics2D g = (Graphics2D) (ip.bi.getGraphics());
    g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
       RenderingHints.VALUE_TEXT_ANTIALIAS_GASP);
    if (object == BLANK) {
      g.setColor(Color.BLACK);
      g.fillRect(x, y, 16, 16);
    } else if (object == WALL) {
      g.setColor(Color.RED);
      g.fillRect(x, y, 16, 16);
    } else if (object == BLOCK) {
      g.setColor(Color.YELLOW);
      g.fillRect(x+1, y+1,  14,  14);
    } else if (object == PADDLE) {
      g.setColor(Color.GREEN);
      g.drawLine(x+2,y+2,x+12,y+2);
      g.drawLine(x+1,y+3,x+14,y+3);
      g.drawLine(x+2,y+4,x+12,y+4);
    } else if (object == BALL) {
      g.setColor(Color.BLUE);
      g.fillOval(x+2, y+2, 14, 14);
    }
  }
  
  public void score(int score) {
    String s = String.valueOf(score);
    Graphics2D g = ip.bi.createGraphics();
    g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_GASP);
    g.setFont(courier);
    fm = g.getFontMetrics();
    g.setColor(Color.BLACK);
    g.fillRect(300, 410, 388, 40);
    g.setColor(Color.WHITE);
    g.drawString(s, 660 - fm.stringWidth(s), 440);
  }
  
  public wes_screen() {
    super();
    EventHandler eh = new EventHandler();
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    addWindowListener(eh);
    setSize(688,540);
    setContentPane(ip);
  }
  
  class EventHandler implements WindowListener {
    @Override
    public void windowOpened(WindowEvent e) {}
    public void windowClosing(WindowEvent e) {}
    public void windowClosed(WindowEvent e) { System.exit(0); }
    public void windowIconified(WindowEvent e) {}
    public void windowDeiconified(WindowEvent e) {}
    public void windowActivated(WindowEvent e) {}
    public void windowDeactivated(WindowEvent e) {}
  }
}
