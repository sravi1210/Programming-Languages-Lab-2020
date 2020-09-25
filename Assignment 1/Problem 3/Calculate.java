// Calculate class to handle 'ENTER' and 'SPACE' functionalites.
public class Calculate {
	// Main function.
	public static void main(String[] args) {
		Calculator calculator = new Calculator();
		Thread thread = new Thread(calculator);
		thread.start();
	}
}