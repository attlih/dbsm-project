-- Do the following changes to the database:
-- Add zip_code column to Geo_location (you don't have to populate it with data)
-- Add a NOT NULL constraint to customer email and project start date
-- Add a check constraint to employee salary and make sure it is more than 1000.
-- You may have to update the salary information to be able to add the constraint
-- (unless you have already done so)

ALTER TABLE geo_location ADD COLUMN zip_code VARCHAR(10);
ALTER TABLE customer ALTER COLUMN email SET NOT NULL;
ALTER TABLE project ALTER COLUMN p_start_date SET NOT NULL;
ALTER TABLE employee ADD CONSTRAINT salary_check CHECK (salary > 1000);
