import javax.swing.*;
import java.awt.event.*;

public class Calculator implements Runnable {
	JFrame frame;
	JButton button[];
	JLabel screen;

	// Constructor
	public Calculator(){
		// Designing the calculator GUI.
	    frame = new JFrame("Calculator Is Ready To Compute");

	    screen = new JLabel();    // Result output screen. 
	    screen.setText("Enter Some Numbers...");
	    screen.setBounds(90, 100, 300, 40);
	    frame.add(screen);

	    JButton button[] = new JButton[15]; // Set of buttons for each number and operations. 
	    
	    for(Integer i=1;i<10;i++){
	      button[i] = new JButton(i.toString());
	      button[i].setBounds(80 +((i-1)%3)*50, 150 + ((i-1)/3)*50, 50, 50);
	      frame.add(button[i]);
	    }

	    String operation = "+-*/";          // String of all operations that can be performed.

	    for(Integer i=0;i<4;i++){
	      button[i+10] = new JButton(""+operation.charAt(i));
	      button[i+10].setBounds(240 +(i%2)*50, 150 + (i/2)*50, 50, 50);
	      frame.add(button[i+10]);
	    }

	    button[0] = new JButton("0");
	    button[0].setBounds(240, 250, 100, 50);
	    frame.add(button[0]);

	    button[14] = new JButton("Calculate When Highlighted");
	    button[14].setBounds(80, 310, 260, 50);
	    frame.add(button[14]);





	    frame.setSize(500, 500);
	    frame.setLayout(null);
	    frame.setVisible(true);
	    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	@Override
	public void run() {
		return;
	}

}