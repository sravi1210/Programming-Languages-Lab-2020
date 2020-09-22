import java.util.ArrayList;

// Store class : Store for the socks.
public class Store {
	public static Integer black;                    // Number of the socks of different colors.
	public static Integer blue;
	public static Integer grey;
	public static Integer white;
	public static ArrayList<Sock> black_sock;       // ArrayList of same color of socks clubbed together.      
	public static ArrayList<Sock> blue_sock;
	public static ArrayList<Sock> grey_sock;
	public static ArrayList<Sock> white_sock;

	// Constructor
	public Store() {
		black = 0;
		blue = 0;
		grey = 0;
		white = 0;
		black_sock = new ArrayList<Sock>();
		blue_sock = new ArrayList<Sock>();
		white_sock = new ArrayList<Sock>();
		grey_sock = new ArrayList<Sock>();
	}
}