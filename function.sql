-- Create a function that returns all projects that were ongoing based on the given date (end date is after the given date)
-- e.g. get_running_projects(date) that returns the project table data joined with the customer data

CREATE OR REPLACE FUNCTION get_running_projects(date)
	RETURNS TABLE (
		p_id integer, 
		project_name varchar,
		budget numeric,
		commission_percentage numeric,
		p_start_date date,
		p_end_date date,
		c_id integer,
		c_name varchar,
		c_type varchar,
		phone varchar,
		email varchar,
		l_id integer
) AS $$
BEGIN
  RETURN QUERY
    SELECT
	project.p_id integer, 
	project.project_name varchar,
	project.budget numeric, 
	project.commission_percentage numeric,
	project.p_start_date date, 
	project.p_end_date date,
	project.c_id integer, 
	customer.c_name varchar,
	customer.c_type varchar,
	customer.phone varchar,
	customer.email varchar,
	customer.l_id integer
	FROM project
      INNER JOIN customer ON project.c_id = customer.c_id
      WHERE project.p_end_date > $1;
END
$$ LANGUAGE plpgsql;




