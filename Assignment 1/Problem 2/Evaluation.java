import java.util.Scanner;
import java.util.ArrayList;

// Main class for evaluation by TA1, TA2 and CC.
public class Evaluation {

	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);   // Scanner for taking inputs.

		boolean loop = true;      

		String username = "";    // Username for READ/WRITE of the data.

		boolean loggedIn = false;   // Boolean tp check for login.

		while(loop){
			while(!loggedIn) {
				System.out.println("To Login Use Username (CC, TA1 or TA2) And For Exit Use (Logout) :");
				System.out.println("------------------------------------------------------------------");
				username = input.nextLine();
				username = username.toUpperCase();
				if(username.equals("CC") || username.equals("TA1") || username.equals("TA2")){
					System.out.println("Logged In With Username " + username);
					System.out.println("-----------------------------------");
					loggedIn = true;
				}
				else if(username.equals("LOGOUT")) {
					loggedIn = true;
				}
				else{
					System.out.println("Login Failed. Try Again!");
					System.out.println("------------------------------"); 
				}
			}

			String require = "";
			String fileName = "";
			Integer roll = 0;
			String operate = "";
			Integer marks = 0;

			while(loggedIn){
				boolean allCheck = true;
				if(!username.equals("LOGOUT")){
					System.out.println("Type Your Requirement (Read , Update OR Logout) :");
					require = input.nextLine();
					require = require.toUpperCase();
					if(require.equals("LOGOUT")){
						username = require;
					}
					else if(require.equals("READ")){
						System.out.println("Enter Filename (Stud_Info OR Sorted_Roll OR Sorted_Name) :");
						fileName = input.nextLine();
						if(!fileName.equals("Stud_Info") && !fileName.equals("Sorted_Name") && !fileName.equals("Sorted_Roll")){
							System.out.println("Enter Correct FileName. Try Again!");
							allCheck = false;
						}
					}
					else if(require.equals("UPDATE")){
						System.out.println("Enter Roll Number :");
						roll = Integer.parseInt(input.nextLine());
						System.out.println("Enter Add/Sub To Add Or Subtract Marks :");
						operate = input.nextLine();
						operate = operate.toUpperCase();
						if(!operate.equals("ADD") && !operate.equals("SUB")){
							System.out.println("Enter Correct Operation. Try Again!");
							allCheck = false;
						}
						else{
							System.out.println("Enter Marks To Add/Sub :");
							marks = Integer.parseInt(input.nextLine());
						}
					}
					else{
						System.out.println("Enter Correct Requirement. Try Again!");
						allCheck = false;
					}
					System.out.println("--------------------------------------------------------------");
				}
				if(allCheck){
					if(username.equals("CC") || username.equals("TA1") || username.equals("TA2")) {
						if(require.equals("READ")){
							FileReadWrite file = new FileReadWrite();
							String loc = "./" +  fileName + ".txt";
							file.fileRead(loc);
							file.printRecord();
						}
						else if(require.equals("UPDATE")){
							fileName = "Stud_Info";
							FileReadWrite file = new FileReadWrite();
							String loc = "./" +  fileName + ".txt";
							file.fileReadWithoutLock(loc);
							boolean success = file.fileUpdate(roll, marks, operate, username);
							if(success){
								file.fileWrite("./Sorted_Roll.txt");
								file.fileWrite("./Sorted_Name.txt");
								file.fileWrite("./Stud_Info.txt");
							}
						}
					}
					else if(username.equals("LOGOUT")){
						System.out.println("Signed Out");
						System.out.println("----------");
						loggedIn = false;
						loop = false;
					}
				}
			}
		}
		return;
	}
}