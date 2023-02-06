--  Data is from https://github.com/vrajmohan/pgsql-sample-data/tree/master/employee
-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

-- Retriving emp_no, first_name, last_name, title, from_date, to_date,

SELECT emp_no, first_name, last_name
FROM employees; 

SELECT title, from_date, to_date
FROM titles; 


--Creating table retirement_titles; confirmed data matched challenge before running INTO 

SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti 
ON (e.emp_no = ti.emp_no) 
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no; 


-- Use the DISTINCT ON statement to retrieve the first occurrence of the employee number

SELECT emp_no, first_name, last_name, title
FROM retirement_titles;

SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title, to_date
FROM retirement_titles; 

SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title, to_date
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;


-- Retrieve the number of employees by their most recent job title who are about to retire.

SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC; 


-- Query to create a Mentorship Eligibility table that holds the employees 


SELECT emp_no, first_name, last_name, birth_date 
FROM employees; 
SELECT emp_no, from_date, to_date
FROM dept_emp;
select emp_no, title
FROM titles;
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, ti.from_date, ti.to_date, ti.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN titles as ti
	ON  e.emp_no = ti.emp_no
INNER JOIN dept_emp as de
	ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND ti.to_date = '9999-01-01'
ORDER BY e.emp_no;



SELECT * FROM mentorship_eligibility;