import java.awt.event.*;
import javax.swing.*;
import java.awt.Color;
import java.awt.KeyboardFocusManager;
import java.awt.KeyEventDispatcher;

// Calculate class to handle 'ENTER' and 'SPACE' functionalites.
public class Calculate {
	private final static int ONE_SECOND = 1000;
	private static char keyPressed = 'a';
	// Main function.
	public static void main(String[] args) {
		Calculator calculator = new Calculator();
		ActionListener ticktock = new ActionListener() {
			public void actionPerformed(ActionEvent evt){
				if(keyPressed == '\n'){
					System.out.println("Enter");
				}
				else if(keyPressed == ' '){
					System.out.println("Space");
				}
				keyPressed = 'a';
				calculator.button[calculator.highlighted_Button].setBackground(Color.WHITE);
				calculator.highlighted_Button += 1;
				calculator.highlighted_Button %= 15;
				calculator.button[calculator.highlighted_Button].setBackground(Color.RED);
			}
		};
		Timer timer = new Timer(ONE_SECOND, ticktock);
		timer.start();

		KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(new KeyEventDispatcher() {
			@Override
			public boolean dispatchKeyEvent(KeyEvent e){
				keyPressed = e.getKeyChar();
				return false;
			}
		});



	}
}