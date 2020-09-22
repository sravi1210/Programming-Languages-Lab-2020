// Student class : Stores all details of the student.
public class Student {
	Integer roll;          // Fields for each record of the students.
	String name;
	String mailId;
	Integer marks;
	String teacher;

	// Constructor
	public Student (Integer roll, String name, String mailId, Integer marks, String teacher) {
		this.roll = roll;
		this.name = name;
		this.mailId = mailId;
		this.marks = marks;
		this.teacher = teacher;
	}
}