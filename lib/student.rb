class Student
  attr_accessor :id, :name, :grade

  # def initialize(id = nil, name = nil, grade= nil)
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end 



  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  
  def self.find_by_name(name_input)
    # find the student in the database given a name
    # return a new instance of the Student class
     sql = <<-SQL
      SELECT * FROM students 
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name_input)[0]
    self.new_from_db(row)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students 
        WHERE grade = 9
      SQL

      rows = DB[:conn].execute(sql)
      rows
  end 

  def self.students_below_12th_grade
      sql = <<-SQL
      SELECT * FROM students 
        WHERE grade < 12
      SQL

      rows = DB[:conn].execute(sql)
      rows
  end 

    def self.first_x_students_in_grade_10(x)
      sql = <<-SQL
      SELECT * FROM students 
        WHERE grade = 10 LIMIT #{x}
      SQL

      rows = DB[:conn].execute(sql)
      rows
  end 

    def self.first_student_in_grade_10
      sql = <<-SQL
      SELECT * FROM students 
        WHERE grade = 10 ORDER BY id 
        ASC 
        LIMIT 1
      SQL

      row = DB[:conn].execute(sql).first
      self.new_from_db(row)
  end 

    def self.all_students_in_grade_x(x)
      sql = <<-SQL
      SELECT * FROM students 
        WHERE grade = ?
      SQL

      rows = DB[:conn].execute(sql, x)
      rows
  end 

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
      sql = <<-SQL
      SELECT * FROM students 
      SQL

      rows = DB[:conn].execute(sql)
      rows.map do |row|
        self.new_from_db(row)
      end 

  end 



end 

