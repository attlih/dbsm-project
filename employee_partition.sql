--Creating a new table to partition employee based on contract type
DROP TABLE IF EXISTS employee_partition;
CREATE TABLE employee_partition (
  e_id integer NOT NULL,
  emp_name character varying(100),
  email character varying(100),
  contract_type character varying(50) NOT NULL,
  contract_start date NOT NULL,
  contract_end date,
  salary numeric(10,2),
  supervisor integer,
  d_id integer,
  j_id integer
) PARTITION BY LIST (contract_type);

-- Creating partitions
DROP TABLE IF EXISTS employees_part_time;
CREATE TABLE employees_part_time
PARTITION OF employee_partition
FOR VALUES IN ('Part-time');

DROP TABLE IF EXISTS employees_full_time;
CREATE TABLE employees_full_time
PARTITION OF employee_partition
FOR VALUES IN ('Full-time');

DROP TABLE IF EXISTS employees_temporary;
CREATE TABLE employees_temporary
PARTITION OF employee_partition
FOR VALUES IN ('Temporary');

INSERT INTO employee_partition SELECT * FROM employee;
