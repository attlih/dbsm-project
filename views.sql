-- Create view to show all employees and their skills
CREATE OR REPLACE VIEW employees_and_skills AS
SELECT employee.e_id AS employee_id, employee.emp_name AS employee_name, STRING_AGG(DISTINCT skills.skill, ', ') AS skill
FROM employee
INNER JOIN employee_skills ON employee.e_id = employee_skills.e_id
INNER JOIN skills ON skills.s_id = employee_skills.s_id
GROUP BY employee_id, employee_name;

-- Create view to show all headquarters and their locations
CREATE OR REPLACE VIEW headquarter_locations AS
SELECT h_id AS hq_id, hq_name, street, city, country FROM headquarters
INNER JOIN geo_location ON geo_location.l_id = headquarters.l_id;

-- Create view to show all projects and their customers, sorted by due date
CREATE OR REPLACE VIEW projects_and_customers AS
SELECT c_name AS customer, project_name AS project, budget, p_start_date AS start_date, p_end_date AS due_date FROM customer
INNER JOIN project ON project.c_id = customer.c_id
ORDER BY due_date;

-- Create view to show employees department, headquarters and location
CREATE OR REPLACE VIEW employees_in_department AS
SELECT e_id, emp_name, dep_name, hq_name, geo_location.l_id, street, city, country FROM employee
LEFT JOIN department ON employee.d_id = department.d_id
LEFT JOIN headquarters ON department.hid = headquarters.h_id
LEFT JOIN geo_location ON headquarters.l_id = geo_location.l_id;

-- Create view to show the amount of employees in different departments
CREATE OR REPLACE VIEW people_in_departments AS
SELECT dep_name, COUNT(*) FROM department
INNER JOIN employee ON employee.d_id = department.d_id
GROUP By dep_name;

-- Create view to show all supervisors
CREATE OR REPLACE VIEW all_supervisors AS
SELECT DISTINCT emp_name, employee.e_id FROM employee
INNER JOIN employee_user_group ON employee.e_id = employee_user_group.e_id
INNER JOIN user_group ON employee_user_group.u_id = user_group.u_id AND group_title = 'Supervisor group'
ORDER BY emp_name, employee.e_id;
