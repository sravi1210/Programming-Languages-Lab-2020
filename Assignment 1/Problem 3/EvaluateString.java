import java.util.Stack; 

// EvaluateString class to calculate the value of the given mathematical expression.
public class EvaluateString {

	public static Integer int_min = -2147483648;
	public static int res;

	public static String evaluate(String expression) { 
		char[] tokens = expression.toCharArray(); 

		// Stack for numbers: 'values' 
		Stack<Integer> values = new Stack<Integer>(); 

		// Stack for Operators: 'ops' 
		Stack<Character> ops = new Stack<Character>(); 

		for (int i = 0; i < tokens.length; i++) { 
			// Current token is a whitespace, skip it 
			if (tokens[i] == ' ') {
				continue; 
			}

			// Current token is a number, push it to stack for numbers 
			if (tokens[i] >= '0' && tokens[i] <= '9') { 
				StringBuffer sbuf = new StringBuffer(); 
				// There may be more than one digits in number 
				while (i < tokens.length && tokens[i] >= '0' && tokens[i] <= '9') {
					sbuf.append(tokens[i++]); 
				}
				values.push(Integer.parseInt(sbuf.toString())); 
			} 

			// Current token is an operator. 
			else if (tokens[i] == '+' || tokens[i] == '-' || 
					tokens[i] == '*' || tokens[i] == '/') 
			{ 
				// While top of 'ops' has same or greater precedence to current 
				// token, which is an operator. Apply operator on top of 'ops' 
				// to top two elements in values stack 
				while (!ops.empty() && hasPrecedence(tokens[i], ops.peek())) 
				values.push(applyOp(ops.pop(), values.pop(), values.pop())); 

				// Push current token to 'ops'. 
				ops.push(tokens[i]); 
			} 
		} 

		// Entire expression has been parsed at this point, apply remaining 
		// ops to remaining values 
		while (!ops.empty()) {
			res = applyOp(ops.pop(), values.pop(), values.pop());
			if(res == int_min){
				return "ERR";
			}
			values.push(res); 
		}
		// Top of 'values' contains result, return it 
		return values.pop().toString(); 
	} 

	// Returns true if 'op2' has higher or same precedence as 'op1', 
	// otherwise returns false. 
	public static boolean hasPrecedence(char op1, char op2) { 
		if ((op1 == '*' || op1 == '/') && (op2 == '+' || op2 == '-')) {
			return false; 
		}
		else {
			return true; 
		}
	} 

	// A utility method to apply an operator 'op' on operands 'a' 
	// and 'b'. Return the result. 
	public static int applyOp(char op, int b, int a) { 
		switch (op) { 
		case '+': 
			return a + b; 
		case '-': 
			return a - b; 
		case '*': 
			return a * b; 
		case '/': 
			if (b == 0) {
				return int_min;
			} 
			return a / b; 
		} 
		return 0; 
	}
}