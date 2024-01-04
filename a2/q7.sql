-- High coverage.

SET search_path TO markus;
DROP TABLE IF EXISTS q7 CASCADE;

CREATE TABLE q7 (
	grader varchar(25) NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW grader_assigned AS
SELECT assignment_id, username, group_id
FROM grader natural join assignmentgroup ;

CREATE VIEW assignment_username AS
SELECT username
FROM grader_assigned
WHERE assignment_id = ALL
(SELECT assignment_id FROM assignment)
GROUP BY username;

-- for all students, there exists at least one ass
-- such that the grader has been assigned to grade
-- that student 
CREATE VIEW student_exists AS





-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q7
