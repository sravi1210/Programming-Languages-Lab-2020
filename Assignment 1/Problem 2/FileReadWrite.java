import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.StringTokenizer;
import java.util.ArrayList;

import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.channels.OverlappingFileLockException;

// Class to handle file read write and corresponding locks with files.
public class FileReadWrite {

	ArrayList<Student> student;   // Array to store the list of students from the file.
  
	// Constructor
	public FileReadWrite() {
		this.student = new ArrayList<Student>();
	}

	// Function to read contents of the file after the lock permissions given.
	public void fileReadWithoutLock(String loc){
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

				if(token.hasMoreTokens()){           // Parsing the content of a row for a object in Student class.
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

	// Funtion to write contents into the file after lock permission given.
	public void fileWriteWithoutLock(String loc){
		ArrayList<Student> children = this.student;
		if(loc.equals("./Sorted_Roll.txt")){                     // Sort the children arraylist on parameter 'roll' if Sorted_Roll.txt is to be written.
			children.sort((stud1, stud2) -> stud1.roll.compareTo(stud2.roll));
		}
		else if(loc.equals("./Sorted_Name.txt")){	             // Sort the children arraylist on parameter 'name' if Sorted_Name.txt is to be written.
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
			return;
		}
		return;
	}

	// Function to read contents of the file at location 'loc'.
	public void fileRead(String loc){
		File file = new File(loc);
		FileChannel fileChannel;
		try{
			fileChannel = new RandomAccessFile(file, "r").getChannel();   // Open the channel with file in read mode.
		}catch(FileNotFoundException e){
			e.printStackTrace();
			return;
		}

		FileLock lock = null;

		while(lock == null){              // Try acquiring the read-lock to read the contents. 
			try{
				lock = fileChannel.tryLock(0, Long.MAX_VALUE, true);
				if(lock != null){
					fileReadWithoutLock(loc);       // After lock acquired, simply read the contents of the file.
					lock.release();
					fileChannel.close();
					return;
				}
			}catch(OverlappingFileLockException |IOException e){     // Catch exception of input/output OR overlapping locks.
				e.printStackTrace();
				return;
			}
		}
		return;
	}

	// Function to write contents of 'children' in file at location 'loc'.
	public void fileWrite(Integer roll, Integer marks, String operate, String username){
		File file1 = new File("./Stud_Info.txt");
		File file2 = new File("./Sorted_Name.txt");
		File file3 = new File("./Sorted_Roll.txt");
		FileChannel fileChannel1;
		FileChannel fileChannel2;
		FileChannel fileChannel3;

		try{
			fileChannel1 = new RandomAccessFile(file1, "rw").getChannel();           // Open three channels for every file in read/write mode.
			fileChannel2 = new RandomAccessFile(file2, "rw").getChannel();
			fileChannel3 = new RandomAccessFile(file3, "rw").getChannel();
		}catch(FileNotFoundException e){
			e.printStackTrace();
			return;
		}

		FileLock lock1 = null;
		FileLock lock2 = null;
		FileLock lock3 = null;

		while(lock1 == null || lock2 == null || lock3 == null){        // Try and acquire lock on each file before updating any of them.
			try{
				if(lock1 == null){
					lock1 = fileChannel1.tryLock();
				}
				if(lock2 == null){
					lock2 = fileChannel2.tryLock();
				}
				if(lock3 == null){
					lock3 = fileChannel3.tryLock();
				}
				if(lock1 != null && lock2 != null && lock3 != null){         // When write lock on all the three files have been acquired, update the contents.
					fileReadWithoutLock("./Stud_Info.txt");
					boolean success = fileUpdate(roll, marks, operate, username);
					if(success){
						fileWriteWithoutLock("./Stud_Info.txt");
						fileWriteWithoutLock("./Sorted_Name.txt");
						fileWriteWithoutLock("./Sorted_Roll.txt");
					}

					lock1.release();          // Release the lock after the update is complete.
					lock2.release();
					lock3.release();
					fileChannel1.close();       // Close the file channels.
					fileChannel2.close();
					fileChannel3.close();
					return;
				}
			}catch(IOException e){        // Catch IOException for input/output.
				e.printStackTrace();
				return;
			}			
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
					Integer newMarks = child.marks;           // Update the marks and teacher for the record getting updated.
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
		for(int i=0;i<this.student.size();i++){
			Student child = this.student.get(i);
			System.out.println(child.roll + " " + child.name + " " + child.mailId + " " + child.marks + " " + child.teacher);
		}
		System.out.println("------------------------------------------------------------------");
	}

}
