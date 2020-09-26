import java.awt.event.*;
import javax.swing.*;
import java.awt.Color;
import java.awt.KeyboardFocusManager;
import java.awt.KeyEventDispatcher;

// Calculate class to handle 'ENTER' and 'SPACE' functionalites.
public class Calculate {
	private final static int ONE_SECOND = 1500;
	private static char keyPressed = 'a';
	public static String instr = "";
	public static boolean resultShow = false;

	public static void store(String val){
		if(val.compareTo("0") >= 0 && val.compareTo("9") <= 0){
			if(resultShow){
				instr = "";
				resultShow = false;
				store(val);
			}
			else{
				String last = "";
				if(instr.length() != 0){
				 	last = last + instr.charAt(instr.length()-1);
				}
				if(last.compareTo("0") == 0){
					if(val.compareTo("0") != 0){
						instr = instr.substring(0, instr.length()-1) + val;
					}
				}
				else{
					instr = instr + val;
				}
			}
		}
		else{
			if(resultShow){
				instr = "";
				resultShow = false;
			}
			else{
				if(instr.length() != 0){
					String last = "" + instr.charAt(instr.length()-1);
					if(last.compareTo("0") >= 0 && last.compareTo("9") <= 0){
						instr = instr + val;
					}
				}
			}
		}
		return;
	}

	public static String result(){
		String ans = "ERR";
		String expr = "";
		resultShow = true;

		for(int i=0;i<instr.length();i++){
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

		EvaluateString evaluate = new EvaluateString();
		ans = evaluate.evaluate(expr);
		return ans;
	}

	// Main function.
	public static void main(String[] args) {
		Calculator calculator = new Calculator();
		ActionListener ticktock = new ActionListener() {
			public void actionPerformed(ActionEvent evt){
				Integer index = calculator.highlighted_Button;
				if(keyPressed == '\n'){
					if(index.intValue() < 10){
						String num = "0123456789";
						store("" + num.charAt(index.intValue()));
						calculator.screen.setText(instr);
					}
					else if(index.intValue() == 14){
						instr = result().toString();
						calculator.screen.setText(instr);
					}
					else if(index.intValue() == 15){
						instr = "";
						calculator.screen.setText(instr);
					}
					System.out.println("Enter");
				}
				else if(keyPressed == ' '){
					if(index.intValue() >= 10 && index.intValue() < 14){
						String operation = "+-*/";
						store("" + operation.charAt(index.intValue()-10));
						calculator.screen.setText(instr);
					}
					System.out.println("Space");
				}
				keyPressed = 'a';
				calculator.button[calculator.highlighted_Button].setBackground(Color.WHITE);
				calculator.highlighted_Button += 1;
				calculator.highlighted_Button %= 16;
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