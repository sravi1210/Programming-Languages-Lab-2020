import java.util.Scanner;
import java.util.ArrayList;

// Main class for evaluation by TA1, TA2 and CC.
public class Evaluation {

	public static void main(String[] args) {
		// Array to store the list of students from the file.
		ArrayList<Student> student = new ArrayList<Student>();

		FileReadWrite file = new FileReadWrite();
		student = file.fileRead("./Stud_Info.txt");

		file.fileWrite(student, "./Sorted_Roll.txt");
		file.fileWrite(student, "./Sorted_Name.txt");
		
	}
}