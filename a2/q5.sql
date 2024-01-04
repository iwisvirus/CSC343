-- Uneven workloads.

-- You must not change the next 2 lines or the table definition.
SET search_path TO markus;
DROP TABLE IF EXISTS q5 CASCADE;

CREATE TABLE q5 (
	assignment_id integer NOT NULL,
	username varchar(25) NOT NULL,
	num_assigned integer NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
DROP VIEW IF EXISTS grader_declared CASCADE;
DROP VIEW IF EXISTS num_groups_assigned CASCADE;
DROP VIEW IF EXISTS good_range CASCADE;
DROP VIEW IF EXISTS answer CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW grader_declared AS
SELECT assignmentgroup.assignment_id, assignmentgroup.group_id, username
FROM assignmentgroup, grader
WHERE grader.group_id = assignmentgroup.group_id;

CREATE VIEW num_groups_assigned AS
SELECT assignment_id, count(group_id), username
FROM grader_declared
GROUP BY username, assignment_id;

CREATE VIEW good_range AS
SELECT assignment_id
FROM num_groups_assigned 
GROUP BY assignment_id
HAVING max(count) - min(count) > 10;

CREATE VIEW answer AS
SELECT assignment_id, username, count as num_assigned
FROM num_groups_assigned natural join good_range;



-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5 (SELECT * FROM answer);
