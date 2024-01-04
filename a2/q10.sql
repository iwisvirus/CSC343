-- A1 report.

-- You must not change the next 2 lines or the table definition.
SET search_path TO markus;
DROP TABLE IF EXISTS q10 CASCADE;

CREATE TABLE q10 (
	group_id bigint NOT NULL,
	mark real DEFAULT NULL,
	compared_to_average real DEFAULT NULL,
	status varchar(5) DEFAULT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
DROP VIEW IF EXISTS groups_with_a1 CASCADE;
DROP VIEW IF EXISTS groups_completed_grading CASCADE;
DROP VIEW IF EXISTS mark_per_rubric CASCADE;
DROP VIEW IF EXISTS weight_cal CASCADE;
DROP VIEW IF EXISTS total_mark CASCADE;
DROP VIEW IF EXISTS average_mark CASCADE;
DROP VIEW IF EXISTS compare CASCADE;
DROP VIEW IF EXISTS status_update CASCADE;
DROP VIEW IF EXISTS answer CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW groups_with_a1 AS
SELECT group_id, assignment.assignment_id
FROM assignmentgroup, assignment
WHERE description = 'A1' and assignment.assignment_id = assignmentgroup.assignment_id;

CREATE VIEW groups_completed_grading AS
SELECT result.group_id, assignment_id
FROM groups_with_a1, result
WHERE result.group_id = groups_with_a1.group_id;

CREATE VIEW mark_per_rubric AS 
SELECT grade.group_id, sum(grade/out_of * weight) as rubric_mark, rubricitem.assignment_id
FROM rubricitem, grade, groups_completed_grading
WHERE rubricitem.rubric_id=grade.rubric_id and groups_completed_grading.group_id=grade.group_id and groups_completed_grading.assignment_id = rubricitem.assignment_id
GROUP BY grade.group_id, rubricitem.assignment_id;

CREATE VIEW weight_cal AS
SELECT assignment_id, sum(weight) as total_weight
FROM rubricitem
GROUP BY assignment_id;

CREATE VIEW total_mark AS
SELECT group_id, (rubric_mark/total_weight) * 100 as mark
FROM mark_per_rubric, weight_cal
WHERE mark_per_rubric.assignment_id = weight_cal.assignment_id;

CREATE VIEW average_mark AS
SELECT avg(mark) as average
FROM total_mark;

CREATE VIEW compare AS
SELECT group_id, mark, mark-average as compared_to_average
FROM total_mark, average_mark;

CREATE VIEW status_update AS
(SELECT group_id, mark, compared_to_average, 'above' as status
FROM compare
WHERE compared_to_average > 0)
UNION
(SELECT group_id, mark, compared_to_average, 'at' as status
FROM compare
WHERE compared_to_average = 0)
UNION
(SELECT group_id, mark, compared_to_average, 'below' as status
FROM compare
WHERE compared_to_average < 0);

CREATE VIEW answer AS
SELECT groups_with_a1.group_id, mark, compared_to_average, status
FROM groups_with_a1 
LEFT JOIN status_update ON groups_with_a1.group_id = status_update.group_id;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q10 (SELECt * FROM answer);
