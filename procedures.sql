-- Creates a procedure to set salary to base level based on job title
CREATE OR REPLACE PROCEDURE set_salary_based_on_title()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE employee
    SET salary = job_title.base_salary
	FROM job_title
    WHERE employee.j_id = job_title.j_id;
END
$$;

-- Creates a procedure to add 3 months to temporary contracts
CREATE OR REPLACE PROCEDURE add_3_months_to_contracts()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE employee
    SET contract_end = contract_end + INTERVAL '3 MONTHS'
    WHERE contract_type = 'Temporary';
END
$$;

-- Creates a procedure to increase salaries by a given percentage (decimal). A maximum limit can also be given
-- for the salaries to be increased.
CREATE OR REPLACE PROCEDURE increase_salary_by_percentage(percentage numeric, max_limit integer default null)
LANGUAGE plpgsql
AS $$
BEGIN
	IF (max_limit IS NOT NULL AND max_limit != 0) THEN
		UPDATE employee
    	SET salary = salary + salary * percentage
    	WHERE salary <= max_limit;
	END IF;
	
	IF (max_limit IS NULL OR max_limit = 0) THEN
		UPDATE employee
    	SET salary = salary + salary * percentage;
	END IF;
END
$$;


-- A procedure that calculates the correct salary based on the acquired skills (skills may give a salary bonus and it is indicated in the database)
CREATE OR REPLACE PROCEDURE calculate_salary_based_on_skills()
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE employee
    SET salary = salary --base salary 
    + (SELECT SUM(salary_benefit_value) FROM skills WHERE s_id IN (SELECT s_id FROM employee_skills WHERE e_id = employee.e_id)); --salary bonus from skills
END
$$;
