import java.util.Scanner;

// Main class
public class MatchingMachine {
	public static void main(String[] args) {
		// Number of threads which will run the input simultaneously.
		int NUM_ROBOTS = 2;

		// Input scanner object for the command line input
		Scanner input = new Scanner(System.in);
		boolean check = true;
		int num_sock = 0;
		num_sock = Integer.parseInt(input.nextLine());
		if(num_sock < 2){
			System.out.println("No pairs can be formed.");
			return;
		}

		int size = (int) Math.ceil(((float) num_sock)/((float) NUM_ROBOTS));

		Sock[][] sock = new Sock[NUM_ROBOTS][size];

		int j = 0;

		// Distribute the socks almost equally among the different robot hands.
		for(int i=0;i<num_sock;i++){
			String color;
			color = input.nextLine();
			color = color.substring(0, 1).toUpperCase() + color.substring(1);    // Capitalize first letter.
			if(!color.equals("White") && !color.equals("Grey") && !color.equals("Blue") && !color.equals("Black")){
				System.out.println("Please enter color among Blue Grey Black and White only.");
				input.close();
				return;
			}
			sock[j][i/NUM_ROBOTS] = new Sock(color);
			j = (j+1) % NUM_ROBOTS;
		}

		input.close();


		Store store = new Store();

		// Create and run parallel threads. Each thread will run throughly on the same number of socks.
		for(int k=0; k<num_sock && k<NUM_ROBOTS; k++){
			Manager manager = new Manager(sock[k], store);
			Thread thread = new Thread(manager);
			thread.start();
		}
	}
}