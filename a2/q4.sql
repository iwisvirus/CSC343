-- Grader report.

-- You must not change the next 2 lines or the table definition.
SET search_path TO markus;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
	assignment_id integer NOT NULL,
	username varchar(25) NOT NULL,
	num_marked integer NOT NULL,
	num_not_marked integer NOT NULL,
	min_mark real DEFAULT NULL,
	max_mark real DEFAULT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- minimum and maximum grade they have given 
DROP VIEW IF EXISTS grader_declared CASCADE;
DROP VIEW IF EXISTS released_or_not CASCADE;
DROP VIEW IF EXISTS together CASCADE;
DROP VIEW IF EXISTS graded_item CASCADE;
DROP VIEW IF EXISTS completed CASCADE;
DROP VIEW IF EXISTS mark_per_rubric CASCADE;
DROP VIEW IF EXISTS weight_cal CASCADE;
DROP VIEW IF EXISTS rubric_count CASCADE;
DROP VIEW IF EXISTS total_mark CASCADE;
DROP VIEW IF EXISTS with_the_total CASCADE;
DROP VIEW IF EXISTS marked_or_not CASCADE;
DROP VIEW IF EXISTS min_max CASCADE;
DROP VIEW IF EXISTS no_mark CASCADE;
DROP VIEW IF EXISTS answer CASCADE;

-- Define views for your intermediate steps here:
-- for each assignment that has any graders declared

CREATE VIEW grader_declared AS 
SELECT assignment_id, username, assignmentgroup.group_id
FROM assignmentgroup, grader
WHERE assignmentgroup.group_id = grader.group_id;

CREATE VIEW released_or_not AS
SELECT assignment_id, username, group_id, mark as released
FROM grader_declared natural full join result;

-- total mark
CREATE VIEW together AS
SELECT group_id, assignment_id, grade.rubric_id, grade
FROM grade, rubricitem
WHERE rubricitem.rubric_id=grade.rubric_id;

CREATE VIEW rubric_count AS
SELECT count(rubric_id), assignment_id 
FROM rubricitem 
GROUP BY assignment_id;

CREATE VIEW graded_item AS
SELECT count(rubric_id), assignment_id, group_id
FROM together
GROUP BY group_id, assignment_id;

CREATE VIEW completed AS
SELECT group_id
FROM graded_item, rubric_count
WHERE graded_item.count=rubric_count.count and graded_item.assignment_id = rubric_count.assignment_id;

CREATE VIEW mark_per_rubric AS 
SELECT grade.group_id, sum(grade/out_of * weight) as rubric_mark, assignment_id
FROM rubricitem, grade, completed
WHERE rubricitem.rubric_id=grade.rubric_id and completed.group_id=grade.group_id
GROUP BY grade.group_id, assignment_id;

CREATE VIEW weight_cal AS
SELECT assignment_id, sum(weight) as total_weight
FROM rubricitem
GROUP BY assignment_id;

CREATE VIEW total_mark AS
SELECT group_id, mark_per_rubric.assignment_id, (rubric_mark/total_weight) * 100 as total_mark
FROM mark_per_rubric, weight_cal
WHERE mark_per_rubric.assignment_id = weight_cal.assignment_id;

CREATE VIEW with_the_total AS
SELECT * from total_mark natural full join released_or_not;

-- marked or not
CREATE VIEW marked_or_not AS
SELECT assignment_id, username, count(*)-count(released) AS num_not_marked, count(released) AS num_marked
FROM with_the_total
GROUP BY assignment_id, username;

CREATE VIEW min_max AS
SELECT assignment_id, username, min(total_mark) as min_mark, max(total_mark) as max_mark
FROM with_the_total
WHERE released IS NOT NULL
GROUP BY assignment_id, username;

CREATE VIEW no_mark as 
SELECT assignment_id, username, NULL as min_mark, NULL as max_mark
FROM marked_or_not
WHERE NOT EXISTS(
	SELECT * FROM min_max
	WHERE marked_or_not.assignment_id=min_max.assignment_id 
	and marked_or_not.username=min_max.username);

CREATE VIEW answer as
SELECT assignment_id, username, num_marked, num_not_marked, min_mark, max_mark 
FROM min_max natural full join marked_or_not;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q4 (SELECT * FROM answer);
