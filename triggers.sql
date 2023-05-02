--  Create three triggers for the database:
-- One for before inserting a new skill, make sure that the same skill does not already exist
CREATE OR REPLACE FUNCTION check_skill_exists()
RETURNS TRIGGER AS $$
  BEGIN
    IF EXISTS (SELECT * FROM skills WHERE skill = NEW.skill) THEN
      RAISE EXCEPTION 'Skill already exists';
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_skill_exists
BEFORE INSERT ON skills
FOR EACH ROW
EXECUTE PROCEDURE check_skill_exists();


-- One for after inserting a new project, check the customer country and select three employees from that
--  country to start working with the project (i.e. create new project roles)
CREATE OR REPLACE FUNCTION create_project_roles()
RETURNS TRIGGER AS $$
  DECLARE
    loc_id INT;
    country_name VARCHAR(20);
    country_id INT;
    employee_ids INT[];
    e_id INT;
  BEGIN
    -- Get the location of the customer
    SELECT l_id INTO loc_id FROM customer WHERE c_id = NEW.c_id;
    -- find the country of the customer
    SELECT geo_location.country INTO country_name FROM geo_location WHERE l_id = loc_id;
    -- Get the id of the country
    SELECT l_id INTO country_id FROM geo_location
      WHERE geo_location.country = country_name 
      AND geo_location.l_id IN (SELECT l_id FROM headquarters);
    -- Get three employees from that country
    SELECT ARRAY(SELECT public.employees_with_address.e_id FROM public.employees_with_address WHERE l_id = country_id LIMIT 3) INTO employee_ids;
    -- Create project role for each employee selected
    FOREACH e_id IN ARRAY employee_ids
    LOOP
      RAISE NOTICE 'Creating project role for employee %', e_id;
      INSERT INTO project_role (e_id, p_id, prole_start_date) VALUES (e_id, NEW.p_id, NEW.p_start_date);
    END LOOP;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER create_project_roles
AFTER INSERT ON project
FOR EACH ROW
EXECUTE PROCEDURE create_project_roles();


-- One for before updating the employee contract type, make sure that the contract start date is
--  also set to the current date and end date is either 2 years after the start date if contract is of Temporary type,
--  NULL otherwise. (Temporary contract in Finnish is "määräaikainen". It's a contract that has an end date specified).
CREATE OR REPLACE FUNCTION set_contract_dates()
RETURNS TRIGGER AS $$
  BEGIN
  raise notice '%', new.contract_start;
    IF NEW.contract_type = 'Temporary' AND NEW.contract_start IS NULL THEN
      NEW.contract_start = CURRENT_DATE;
      NEW.contract_end = CURRENT_DATE + INTERVAL '2 years';
    ELSIF NEW.contract_type != 'Temporary' AND NEW.contract_start IS NULL THEN
      NEW.contract_start = CURRENT_DATE;
      NEW.contract_end = NULL;
    ELSIF NEW.contract_type = 'Temporary' AND NEW.contract_start IS NOT NULL THEN
      NEW.contract_end = NEW.contract_start + INTERVAL '2 years';
    ELSIF NEW.contract_type != 'Temporary' AND NEW.contract_start IS NOT NULL THEN
      NEW.contract_end = NULL;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_contract_dates
BEFORE UPDATE ON employee
FOR EACH ROW
EXECUTE PROCEDURE set_contract_dates();


-- A trigger after insert on employee.
-- If employee's job title is HR secretary, add them to the HR user group.
 -- If employee's job matches word 'admin', add them to the Administration group.
 -- Everyone else is added to the employee group
CREATE OR REPLACE FUNCTION add_to_user_group()
RETURNS TRIGGER AS $$
  DECLARE
    job VARCHAR(20);
  BEGIN
    SELECT title INTO job FROM job_title WHERE j_id = NEW.j_id;
    IF job = 'HR secretary' THEN
      INSERT INTO employee_user_group (e_id, u_id, eug_join_date) VALUES (NEW.e_id, 6, CURRENT_DATE); -- HR user group
    ELSIF job LIKE '%admin%' THEN
      INSERT INTO employee_user_group (e_id, u_id, eug_join_date) VALUES (NEW.e_id, 3, CURRENT_DATE); -- Administration user group
    ELSE
      INSERT INTO employee_user_group (e_id, u_id, eug_join_date) VALUES (NEW.e_id, 9, CURRENT_DATE); -- Employee user group
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE OR Replace TRIGGER add_to_user_group
AFTER INSERT OR UPDATE ON employee
FOR EACH ROW
EXECUTE PROCEDURE add_to_user_group();