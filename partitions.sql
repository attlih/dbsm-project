-- Creating 3 partitions on employee based on contract type
CREATE TABLE employees_part_time
PARTITION OF employee
FOR VALUES IN ('Part-time');

CREATE TABLE employees_full_time
PARTITION OF employee
FOR VALUES IN ('Full-time');

CREATE TABLE employees_temporary
PARTITION OF employee
FOR VALUES IN ('Temporary');

-- Attaching the created partitions
ALTER TABLE employee ATTACH PARTITION employees_part_time
PARTITION BY LIST (contract_type);

ALTER TABLE employee ATTACH PARTITION employees_full_time
PARTITION BY LIST (contract_type);

ALTER TABLE employee ATTACH PARTITION employees_temporary
PARTITION BY LIST (contract_type);