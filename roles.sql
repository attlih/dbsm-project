-- Database Schema is named "Project"
-- Database has following tables: customer, department, employee, employee_skills, employee_user_group, geo_location, headquarters, job_title, project, project_role, skills, user_group
-- Create three roles - admin, employee, trainee.

CREATE ROLE admin;
CREATE ROLE employee;
CREATE ROLE trainee;

-- Give admin all administrative rights (same rights as postgres superuser would have)
GRANT ALL ON ALL TABLES IN SCHEMA public TO admin;
-- Give employee rights to read all information in the database but no rights to write
GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee;
-- Give trainee rights to read ONLY project, customer, geo_location, and project_role tables as well as limited access to employee table (only allow reading employee id, name, email)
GRANT SELECT ON project, customer, geo_location, project_role TO trainee;




