import javax.swing.*;
import java.awt.event.*;

public class Calculator implements Runnable {
	JFrame frame;
	JButton button[];
	JLabel screen;
	JTextField input;
	JButton exit;
	boolean exitNow = false;

    // x axis, y axis, width, height
	public Calculator(){
	    frame = new JFrame();

	    screen = new JLabel();
	    screen.setText("Enter Some Numbers...");
	    screen.setBounds(90, 100, 300, 40);
	    frame.add(screen);

	    JButton button[] = new JButton[14];
	    for(Integer i=0;i<10;i++){
	      button[i] = new JButton(i.toString());
	      button[i].setBounds(90 +(i%5)*50, 150 + (i/5)*50, 50, 50);
	      frame.add(button[i]);
	    }

	    String operation = "+-*/";

	    for(Integer i=0;i<4;i++){
	      button[i+10] = new JButton(""+operation.charAt(i));
	      button[i+10].setBounds(90 +(i%5)*50, 250 + (i/5)*50, 50, 50);
	      frame.add(button[i+10]);
	    }
	    
	    exit = new JButton("Exit");
	    exit.setBounds(90, 310, 250, 50);

	    exit.addActionListener(new ActionListener() {
	      @Override
	      public void actionPerformed(ActionEvent e) {
	      	exitNow = true;
	        System.out.println("Exit Calculator");
	      }
	    });

	    frame.add(exit);

	    input = new JTextField();
	    input.setBounds(90, 370, 250, 50);
	    frame.add(input);

	    frame.setSize(500, 500);
	    frame.setLayout(null);
	    frame.setVisible(true);
	}

	@Override
	public void run() {
		return;
	}

}