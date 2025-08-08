import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="localhost",        
        user="root",             
        password="",              
        database="ucrs_db"       
    )

def view_courses():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT c.course_id, c.title, d.dept_name, c.credits
        FROM Course c
        JOIN Department d ON c.dept_id = d.dept_id
    """)
    print("\nAvailable Courses:")
    print("-" * 60)
    for row in cursor.fetchall():
        print(f"Course ID: {row[0]}, Title: {row[1]}, Dept: {row[2]}, Credits: {row[3]}")
    cursor.close()
    conn.close()

def enroll_student():
    student_id = input("Enter Student ID: ")
    course_id = input("Enter Course ID: ")
    semester = input("Enter Semester (e.g., Fall 2025): ")

    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Enrollment (student_id, course_id, semester, grade)
            VALUES (%s, %s, %s, NULL)
        """, (student_id, course_id, semester))
        conn.commit()
        print("Student enrolled successfully!")
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    finally:
        cursor.close()
        conn.close()

def list_students_in_course():
    course_id = input("Enter Course ID: ")
    semester = input("Enter Semester: ")

    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT s.student_id, s.name, s.email
        FROM Enrollment e
        JOIN Student s ON e.student_id = s.student_id
        WHERE e.course_id = %s AND e.semester = %s
    """, (course_id, semester))

    students = cursor.fetchall()
    if students:
        print("\nEnrolled Students:")
        for s in students:
            print(f"ID: {s[0]}, Name: {s[1]}, Email: {s[2]}")
    else:
        print("No students found for this course and semester.")
    cursor.close()
    conn.close()

def menu():
    while True:
        print("\n--- University Course Registration System ---")
        print("1. View All Courses")
        print("2. Enroll Student in Course")
        print("3. List Students in a Course")
        print("4. Exit")
        choice = input("Enter choice: ")

        if choice == "1":
            view_courses()
        elif choice == "2":
            enroll_student()
        elif choice == "3":
            list_students_in_course()
        elif choice == "4":
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    menu()
