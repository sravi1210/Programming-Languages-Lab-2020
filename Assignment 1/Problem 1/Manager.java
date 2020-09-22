import java.util.ArrayList;

// Manager class : An extension to the thread. The run() function runs whenever a thread is started.
public class Manager implements Runnable {
	
	Sock[] sock;                      // List of socks from one robot hand.
	Store store;                      // Store for the socks.

	// Constructor
	public Manager(Sock[] sock, Store store) {
		this.sock = sock;
		this.store = store;
	}

	// Prints if a pair is matched in any color
	public void PrintPair(Sock sock1, Sock sock2){
		if(sock1 != null && sock2 != null && sock1.color.equals(sock2.color)){
			System.out.println("Pair Formed :- " + "Color = " + sock1.color + " and sockId = (" + sock1.id + ", " + sock2.id + ")");
			return;
		}
		return;
	}

	// Runs whenever a thread is started.
	@Override
	public void run() {
		// Processing sock one by one.

		for(int i=0;i<sock.length; i++) {
			if(sock[i] == null) {
				break;
			}
			String color = sock[i].color;

			// If current sock is Blue.
			if(color.equals("Blue")){
				synchronized(store.blue){
					store.blue++;
					store.blue_sock.add(sock[i]);
					int size = store.blue_sock.size();
					if(size >= 2){
						while(size >= 2){
							Sock sock1 = store.blue_sock.get(0);
							store.blue_sock.remove(0);
							Sock sock2 = store.blue_sock.get(0);
							store.blue_sock.remove(0);
							PrintPair(sock1, sock2);
							size = store.blue_sock.size();
						}
					}
					store.blue = size;
				}
			}
			// If current sock is Black.
			else if(color.equals("Black")){
				synchronized(store.black){
					store.black++;
					store.black_sock.add(sock[i]);
					int size = store.black_sock.size();
					if(size >= 2){
						while(size >= 2){
							Sock sock1 = store.black_sock.get(0);
							store.black_sock.remove(0);
							Sock sock2 = store.black_sock.get(0);
							store.black_sock.remove(0);
							PrintPair(sock1, sock2);
							size = store.black_sock.size();
						}
					}
					store.black = size;
				}
			}
			// If current sock is Grey.
			else if(color.equals("Grey")){
				synchronized(store.grey){
					store.grey++;
					store.grey_sock.add(sock[i]);
					int size = store.grey_sock.size();
					if(size >= 2){
						while(size >= 2){
							Sock sock1 = store.grey_sock.get(0);
							store.grey_sock.remove(0);
							Sock sock2 = store.grey_sock.get(0);
							store.grey_sock.remove(0);
							PrintPair(sock1, sock2);
							size = store.grey_sock.size();
						}
					}
					store.grey = size;
				}
			}
			// If current sock is White.
			else if(color.equals("White")){
				synchronized(store.white){
					store.white++;
					store.white_sock.add(sock[i]);
					int size = store.white_sock.size();
					if(size >= 2){
						while(size >= 2){
							Sock sock1 = store.white_sock.get(0);
							store.white_sock.remove(0);
							Sock sock2 = store.white_sock.get(0);
							store.white_sock.remove(0);
							PrintPair(sock1, sock2);
							size = store.white_sock.size();
						}
					}
					store.white = size;
				}
			}
		}
	}



}