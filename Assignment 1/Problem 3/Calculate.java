import java.awt.event.*;
import javax.swing.*;
import java.awt.Color;
import java.awt.KeyboardFocusManager;
import java.awt.KeyEventDispatcher;

// Calculate class to handle 'ENTER' and 'SPACE' functionalites.
public class Calculate {
	private final static int ONE_SECOND = 1500;       // Timer time limit.
	private static char keyPressed = 'a';            	// To keep track of the key pressed.
	public static String instr = "0";          // Equation generated before result.
	public static boolean resultShow = false;    // If result has been displayed.

	// Store function to store the next number of operation in the equation set.
	public static void store(String val){
		if(val.compareTo("0") >= 0 && val.compareTo("9") <= 0){     // If the next value is a number.
			if(resultShow){
				instr = "0";
				resultShow = false;
				store(val);
			}
			else{
				String last = "";
				if(instr.length() != 0){
				 	last = last + instr.charAt(instr.length()-1);
				}
				if(last.compareTo("0") == 0){
					if(instr.length() != 1){
						String secondLast = "" + instr.charAt(instr.length()-2);
						if((secondLast.compareTo("+") == 0) || (secondLast.compareTo("-") == 0) || (secondLast.compareTo("*") == 0) || (secondLast.compareTo("/") == 0)){
							instr = instr.substring(0, instr.length()-1) + val;
						}
						else{
							instr = instr + val;
						}
					}
					else{
						if(val.compareTo("0") != 0){
							instr = instr.substring(0, instr.length()-1) + val;
						}
					}
				}
				else{
					instr = instr + val;
				}
			}
		}
		else{                                          // If next value is a operation.
			if(resultShow){
				instr = "0";
				resultShow = false;
			}
			else{
				if(instr.length() != 0){
					String last = "" + instr.charAt(instr.length()-1);
					if(last.compareTo("0") >= 0 && last.compareTo("9") <= 0){
						instr = instr + val;
					}
					else if((last.compareTo("+") == 0) || (last.compareTo("-") == 0) || (last.compareTo("*") == 0) || (last.compareTo("/") == 0)){
						instr = instr.substring(0, instr.length()-1) + val;
					}
				}
			}
		}
		return;
	}

	// To calculate the result of the equation formed, or display ERR in case if error.
	public static String result(){
		String ans = "ERR";
		String expr = "";
		resultShow = true;

		for(int i=0;i<instr.length();i++){                // Create expression string with spaces between each token.
			if(instr.charAt(i) == '+' || instr.charAt(i) == '-' || instr.charAt(i) == '*' || instr.charAt(i) == '/'){
				expr = expr + " " + instr.charAt(i) + " ";
			}
			else{
				expr = expr + instr.charAt(i);
			}
		}
		if(expr.charAt(expr.length() - 1) == ' '){
			return ans;
		}

		EvaluateString evaluate = new EvaluateString();      // Evaluate string generated.
		ans = evaluate.evaluate(expr);
		return ans;
	}

	// Main function.
	public static void main(String[] args) {
		Calculator calculator = new Calculator();           // Create an instance of the calculator.
		ActionListener ticktock = new ActionListener() {       // Create an action listener for listening to the key press events continuously in concurrent with all programs.
			public void actionPerformed(ActionEvent evt){
				Integer index = calculator.highlighted_Button;
				if(keyPressed == '\n'){        				// If key pressed is an 'ENTER'.
					if(index.intValue() < 10){             
						String num = "0123456789";
						store("" + num.charAt(index.intValue()));
						calculator.screen.setText(instr);
					}
					else if(index.intValue() == 14){            // For 'Calculate Result'.
						instr = result().toString();
						calculator.screen.setText(instr);
					}
					else if(index.intValue() == 15){           // For clearing the screen of the calculator.
						instr = "0";
						calculator.screen.setText(instr);
					}
					System.out.println("Enter");
				}
				else if(keyPressed == ' '){                    // If key pressed is a 'SPACE'.
					if(index.intValue() >= 10 && index.intValue() < 14){
						String operation = "+-*/";
						store("" + operation.charAt(index.intValue()-10));
						calculator.screen.setText(instr);
					}
					System.out.println("Space");
				}
				keyPressed = 'a';
				calculator.button[calculator.highlighted_Button].setBackground(Color.WHITE);     // Creating the highlighting action on next number/operation with timer.
				calculator.highlighted_Button += 1;
				calculator.highlighted_Button %= 16;
				calculator.button[calculator.highlighted_Button].setBackground(Color.RED);
			}
		};
		Timer timer = new Timer(ONE_SECOND, ticktock);
		timer.start();

		KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(new KeyEventDispatcher() {       // KeyboardFocusManager to take inputs from the keypress events.
			@Override
			public boolean dispatchKeyEvent(KeyEvent e){
				keyPressed = e.getKeyChar();
				return false;
			}
		});
	}
}