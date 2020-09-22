// Sock class : Stores all details of the sock input
public class Sock {
	static int sock_count = 0;      // Maintains total number of socks till now
	String color;					// Color of the sock
	int id;                         // Unique sock id

	// Constructor
	public Sock (String color) {
		this.color = color;
		this.id = ++sock_count;
	}
}