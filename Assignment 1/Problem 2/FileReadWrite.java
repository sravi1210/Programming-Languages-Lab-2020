import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.ArrayList;

public class FileReadWrite {

	ArrayList<Student> student;   // Array to store the list of students from the file.
  
	// Constructor
	public FileReadWrite() {
		this.student = new ArrayList<Student>();
	}

	// Function to read contents of the file at location 'loc'.
	public void fileRead(String loc){
		try {
			File file = new File(loc);                               // Open the file.
			Scanner input = new Scanner(file);
			
			while(input.hasNextLine()) {                             // Read the file.
				String data = input.nextLine();
				StringTokenizer token = new StringTokenizer(data);   // Tokenize the single line from the file into student record details.
				String word = "";
				Integer roll = 0;
				String name = "";
				String mailId = "";
				Integer marks = 0;
				String teacher = "";

				if(token.hasMoreTokens()){
					word = token.nextToken();
					roll = Integer.parseInt(word);
				}
				
				while(token.hasMoreTokens()){
					word = token.nextToken();
					if(word.contains("@")){
						mailId = word;
						break;
					}
					else{
						if(name.isEmpty()){
							name = word;
						}
						else{
							name = name + " " + word;
						}
					}
				}

				if(token.hasMoreTokens()){
					word = token.nextToken();
					marks = Integer.parseInt(word);
				}
				if(token.hasMoreTokens()){
					word = token.nextToken();
					teacher = word;
				}
				// Student object from one single row of the file.
				Student child = new Student(roll, name, mailId, marks, teacher);

				this.student.add(child);
			}
			input.close();
		}catch (FileNotFoundException e) {              // In case of exception - FILE NOT FOUND.
			System.out.println("File Not Found");
			e.printStackTrace();
		}
		return;
	}

	// Function to write contents of 'children' in file at location 'loc'.
	public void fileWrite(String loc){
		ArrayList<Student> children = this.student;
		if(loc.equals("./Sorted_Roll.txt")){
			children.sort((stud1, stud2) -> stud1.roll.compareTo(stud2.roll));
		}
		else if(loc.equals("./Sorted_Name.txt")){	
			children.sort((stud1, stud2) -> stud1.name.compareTo(stud2.name));
		}
		try {
			FileWriter writer = new FileWriter(loc);
			for(int i=0;i<children.size();i++){
				Student child = children.get(i);
				writer.write(child.roll + " " + child.name + " " + child.mailId + " " + child.marks + " " + child.teacher + "\n");
			}
			writer.close();
		}catch (IOException e){
			System.out.println("Cannot Write Into File");
			e.printStackTrace();
		}
		return;
	}

	// Function to update the file contents with different users.
	public boolean fileUpdate(Integer roll, Integer marks, String operate, String username) {
		for(int i=0;i<this.student.size();i++){
			Student child = this.student.get(i);
			if(child.roll.intValue() == roll.intValue()){
				if((username.equals("TA1") || username.equals("TA2")) && (child.teacher.equals("CC"))){
					System.out.println("Cannot Update Marks. Update By CC. Try Again!");
					return false;
				} 
				else{
					Integer newMarks = child.marks;
					if(operate.equals("ADD")){
						newMarks += marks;
					}
					else{
						newMarks -= marks;
					}
					this.student.get(i).marks = newMarks;
					this.student.get(i).teacher = username;
					child = this.student.get(i);
					System.out.println("Updated Row: " + child.roll + " " + child.name + " " + child.mailId + " " + child.marks + " " + child.teacher);
					return true;
				}
			}
		}
		System.out.println("Roll Number Does Not Exist. Try Again!");
		return false;
	}


	// Function to print student records.
	public void printRecord(){
		System.out.println("-------------------------------------------------------------------------");
		for(int i=0;i<this.student.size();i++){
			Student child = this.student.get(i);
			System.out.println(child.roll + " " + child.name + " " + child.mailId + " " + child.marks + " " + child.teacher);
		}
		System.out.println("-------------------------------------------------------------------------");
	}

}