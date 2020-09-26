import javax.swing.*;
import java.awt.event.*;
import java.awt.Color;

public class Calculator {
	private final static int ONE_SECOND = 1500;
	JFrame frame;             // Frame of the calculator.
	JButton button[] = new JButton[16];   // Set of buttons for each number and operations. 
	JLabel screen;     // Screen to display the result and inputs.
	Integer highlighted_Button = 0;   // Highlighted button ID.

	// Constructor
	public Calculator(){
		// Designing the calculator GUI.
	    frame = new JFrame("Calculator Is Ready To Compute");

	    screen = new JLabel();    // Result output screen. 
	    screen.setText("0");
	    screen.setBounds(90, 100, 300, 40);
	    frame.add(screen);
	    
	    for(Integer i=1;i<10;i++){
	      button[i] = new JButton(i.toString());
	      button[i].setBounds(80 +((i-1)%3)*50, 150 + ((i-1)/3)*50, 50, 50);
	      button[i].setBackground(Color.WHITE);
	      frame.add(button[i]);
	    }

	    String operation = "+-*/";          // String of all operations that can be performed.

	    for(Integer i=0;i<4;i++){
	      button[i+10] = new JButton(""+operation.charAt(i));
	      button[i+10].setBounds(240 +(i%2)*50, 150 + (i/2)*50, 50, 50);
	      button[i+10].setBackground(Color.WHITE);
	      frame.add(button[i+10]);
	    }

	    button[0] = new JButton("0");
	    button[0].setBounds(240, 250, 100, 50);
	    button[0].setBackground(Color.WHITE);
	    frame.add(button[0]);

	    button[14] = new JButton("Calculate");  // Result calculation button.
	    button[14].setBounds(80, 310, 150, 50);
	    button[14].setBackground(Color.WHITE);
	    frame.add(button[14]);

	    button[15] = new JButton("Clear");
	    button[15].setBounds(240, 310, 100, 50);
	    button[15].setBackground(Color.WHITE);
	    frame.add(button[15]);

	    frame.setSize(500, 500);   // Basic setting of the frame to be displayed.
	    frame.setLayout(null);
	    frame.setVisible(true);
	    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  // Close button added default.
	}
}