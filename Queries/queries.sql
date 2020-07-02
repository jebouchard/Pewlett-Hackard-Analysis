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

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employee (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
	);
	
CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM departments;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Retirement eligibility
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_employee.to_date
FROM retirement_info
LEFT JOIN dept_employee
ON retirement_info.emp_no = dept_employee.emp_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_employee.to_date
FROM retirement_info
LEFT JOIN dept_employee
ON retirement_info.emp_no = dept_employee.emp_no;

SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_by_dept
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Mentorship eligibility-- Mentorship eligibility
		 
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
--INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM retirement_info

SELECT * FROM retirement_by_dept;

SELECT * FROM titles;

SELECT * FROM current_emp;

SELECT * FROM salaries;

-- Module 6 Challenge Deliverable 1
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
t.title,
t.from_date,
s.salary
INTO retirement_by_title
FROM titles as t
INNER JOIN current_emp AS ce
ON (t.emp_no = ce.emp_no)
INNER JOIN salaries AS s
ON (s.emp_no = ce.emp_no)
ORDER BY ce.emp_no;

SELECT * FROM retirement_by_title;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
first_name,
last_name,
title,
from_date,
salary
INTO retirement_by_title_no_dups
FROM (SELECT emp_no, first_name, last_name, title, from_date, salary,
ROW_NUMBER() OVER
(PARTITION BY emp_no ORDER BY from_date DESC) rn
	  FROM retirement_by_title
	  ) tmp WHERE rn=1;

SELECT * FROM retirement_by_title_no_dups;
SELECT * FROM employees;

-- Mentorship eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';
--WHERE de.to_date = ('9999-01-01');
SELECT ep.emp_no,
ep.first_name,
ep.last_name,
t.title,
t.from_date,
--t.to_date,
de.to_date

INTO mentor_eligibility
FROM employees AS ep 
INNER JOIN titles AS t
ON (ep.emp_no = t.emp_no)
INNER JOIN dept_employee AS de
ON (t.emp_no = de.emp_no)
WHERE de.to_date = ('9999-01-01');

-- Mentorship eligibility (correct to_date)

SELECT me.emp_no,
me.first_name,
me.last_name,
me.title,
me.from_date,
t.to_date
INTO mentor_eligibility_1
FROM mentor_eligibility AS me 
INNER JOIN titles AS t
ON (me.emp_no = t.emp_no)
WHERE t.to_date = ('9999-01-01');



-- Partition the data to show only most recent title per employee
SELECT emp_no,
first_name,
last_name,
title,
from_date,
to_date
INTO mentor_eligibility_no_dups
FROM (SELECT emp_no, first_name, last_name, title, from_date, to_date,
ROW_NUMBER() OVER
(PARTITION BY emp_no ORDER BY from_date DESC) rn
	  FROM mentor_eligibility_1
	  ) tmp WHERE rn=1;
	  
	  

SELECT * FROM dept_employee;

SELECT * FROM mentor_eligibility;
DROP TABLE mentor_eligibility_1;


--Speed Run

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;


-- Number of empolyees retiring (41,380)
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

-- joining departments and dept_manager table
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no
WHERE dm.to_date = ('9999-01-01');

DROP TABLE current_emp;

-- selecting current employees
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by deptartment number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee list with gender and salary
SELECT e.emp_no,
e.first_name,
e.last_name,
s.salary,
de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee as de
	ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

DROP TABLE manager_info;

-- List of managers per departments
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);


-- List of employees with departments
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_employee AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- List of Sales Employees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
	INTO sales_info
	FROM current_emp as ce
	INNER JOIN dept_employee as de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
	WHERE d.dept_name ='Sales';
	
-- List of Sales and Development
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO sales_dev
FROM current_emp as ce
	INNER JOIN dept_employee AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE d. dept_name IN ('Sales', 'Development')
ORDER BY ce. emp_no;	

SELECT * FROM sales_dev;

-- Challenge Part 2
-- Number of [titles] retiring
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO ret_titles
FROM current_emp as ce
	INNER JOIN titles as ti
		ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no;

SELECT * FROM ret_titles
ORDER BY ret_titles.emp_no;

-- Partition the data to show only the most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title
INTO unique_titles
FROM (
	SELECT emp_no,
	first_name,
	last_name,
	to_date,
	title, ROW_NUMBER() OVER
	(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM ret_titles
	) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM unique_titles;

SELECT * FROM ret_titles;
-- Counting the number of employees per title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- Creating a list of employees eligible for potential mentorship program
SELECT e.emp_no,
	e. first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship
FROM employees as e
INNER JOIN dept_employee as de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship;

DROP TABLE mentorship;

SELECT * FROM retirement_by_dept;
