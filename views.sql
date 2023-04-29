-- All employees and their skills
SELECT employee.e_id AS employee_id, employee.emp_name AS employee_name, STRING_AGG(DISTINCT skills.skill, ', ') AS skill
FROM employee
INNER JOIN employee_skills ON employee.e_id = employee_skills.e_id
INNER JOIN skills ON skills.s_id = employee_skills.s_id
GROUP BY employee_id, employee_name;

-- All headquarters and their locations
SELECT h_id, hq_name, street, city, country FROM headquarters
INNER JOIN geo_location ON geo_location.l_id = headquarters.l_id;
