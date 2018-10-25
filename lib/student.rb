require_relative "../config/environment.rb"
require "pry"
class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
    self.name = name 
    self.grade = grade
    @id = id
  end
  
  def self.create_table
    DB[:conn].execute("CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)")
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end
  
  def save
    if self.id 
       DB[:conn].execute("UPDATE students SET name = ?, grade = ?",self.name,self.grade)
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES(?,?)",self.name,self.grade)
      @id =  DB[:conn].execute("SELECT id FROM students DESC LIMIT 1").first.first
    end
  end
  
  def self.create(name, grade, id = nil)
    student = Student.new(name, grade, id)
    student.save
    student
  end
  
  def self.new_from_db(row)
    self.create(row[1], row[2], row[0])
  end
  
  def self.find_by_name(name)
     DB[:conn].execute("SELECT * FROM students WHERE name = ?",name).first
  end
end
