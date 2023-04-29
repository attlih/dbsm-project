-- Create view to show all employees and their skills
CREATE OR REPLACE VIEW employee_skills AS
SELECT employee.e_id AS employee_id, employee.emp_name AS employee_name, STRING_AGG(DISTINCT skills.skill, ', ') AS skill
FROM employee
INNER JOIN employee_skills ON employee.e_id = employee_skills.e_id
INNER JOIN skills ON skills.s_id = employee_skills.s_id
GROUP BY employee_id, employee_name;

-- Create view to show all headquarters and their locations
CREATE OR REPLACE VIEW headquarter_locations AS
SELECT h_id, hq_name, street, city, country FROM headquarters
INNER JOIN geo_location ON geo_location.l_id = headquarters.l_id;

-- Create view to show employees department, headquarters and location
CREATE OR REPLACE VIEW employees_in_department AS
SELECT e_id, emp_name, dep_name, hq_name, street, city, country, geo_location.l_id FROM employee, department, headquarters, geo_location
WHERE employee.d_id = department.d_id
AND department.hid = headquarters.h_id
AND headquarters.l_id = geo_location.l_id;
