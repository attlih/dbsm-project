--Creating a new table to partition project based on budget thresholds
DROP TABLE IF EXISTS project_partition;
CREATE TABLE project_partition (
 	p_id integer NOT NULL,
 	project_name character varying(100),
 	budget numeric,
 	commission_percentage numeric,
 	p_start_date date,
 	p_end_date date,
	c_id integer
) PARTITION BY RANGE (budget);

-- Creating partitions based on low (0-10M), medium (10M-50M) and high (50M-100M) budgets.
DROP TABLE IF EXISTS project_budget_low;
CREATE TABLE project_budget_low
PARTITION OF project_partition
FOR VALUES FROM (0)
TO (10000000);

DROP TABLE IF EXISTS project_budget_medium;
CREATE TABLE project_budget_medium
PARTITION OF project_partition
FOR VALUES FROM (10000001)
TO (50000000);;

DROP TABLE IF EXISTS project_budget_high;
CREATE TABLE project_budget_high
PARTITION OF project_partition
FOR VALUES FROM (50000001)
TO (100000000);;

INSERT INTO project_partition SELECT * FROM project;

