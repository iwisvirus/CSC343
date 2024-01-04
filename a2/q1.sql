-- Distributions.

-- You must not change the next 2 lines or the table definition.
SET search_path TO markus;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1 (
	assignment_id integer NOT NULL,
	average_mark_percent real DEFAULT NULL,
	num_80_100 integer NOT NULL,
	num_60_79 integer NOT NULL,
	num_50_59 integer NOT NULL,
	num_0_49 integer NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
DROP VIEW IF EXISTS together CASCADE;
DROP VIEW IF EXISTS rubric_count CASCADE;
DROP VIEW IF EXISTS graded_item CASCADE;
DROP VIEW IF EXISTS completed CASCADE;
DROP VIEW IF EXISTS mark_per_rubric CASCADE;
DROP VIEW IF EXISTS weight_cal CASCADE;
DROP VIEW IF EXISTS total_mark CASCADE;
DROP VIEW IF EXISTS graded_group CASCADE;
DROP VIEW IF EXISTS average_mark CASCADE;
DROP VIEW IF EXISTS num_a CASCADE;
DROP VIEW IF EXISTS num_a_zero CASCADE;
DROP VIEW IF EXISTS num_b CASCADE;
DROP VIEW IF EXISTS num_b_zero CASCADE;
DROP VIEW IF EXISTS num_c CASCADE;
DROP VIEW IF EXISTS num_c_zero CASCADE;
DROP VIEW IF EXISTS num_d CASCADE;
DROP VIEW IF EXISTS num_d_zero CASCADE;
DROP VIEW IF EXISTS answer CASCADE;



-- Define views for your intermediate steps here:
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

CREATE VIEW graded_group AS 
SELECT total_mark.group_id, assignment_id, total_mark
FROM result, total_mark
WHERE result.group_id = total_mark.group_id;

CREATE VIEW average_mark AS
SELECT assignment.assignment_id, avg(total_mark) as average_mark_percent
FROM assignment
LEFT JOIN graded_group on assignment.assignment_id = graded_group.assignment_id
GROUP BY assignment.assignment_id;

CREATE VIEW num_a AS
SELECT assignment.assignment_id, count(total_mark) as num_80_100
FROM assignment
left join graded_group on assignment.assignment_id = graded_group.assignment_id
WHERE total_mark >=80 and total_mark <=100
GROUP BY assignment.assignment_id;

CREATE VIEW num_a_zero AS
SELECT assignment.assignment_id, COALESCE(num_80_100,0) as num_80_100
FROM assignment 
left join num_a on num_a.assignment_id = assignment.assignment_id;

CREATE VIEW num_b as
SELECT assignment_id, count(total_mark) as num_60_79
FROM graded_group 
WHERE total_mark >=60 and total_mark <=79
GROUP BY assignment_id;

CREATE VIEW num_b_zero AS
SELECT assignment.assignment_id, COALESCE(num_60_79,0) as num_60_79
FROM assignment 
left join num_b on num_b.assignment_id = assignment.assignment_id;

CREATE VIEW num_c AS
SELECT assignment_id, count(total_mark) as num_50_59 
FROM graded_group
WHERE total_mark >=50 and total_mark <=59
GROUP BY assignment_id;

CREATE VIEW num_c_zero AS
SELECT assignment.assignment_id, COALESCE(num_50_59,0) as num_50_59
FROM assignment 
left join num_c on num_c.assignment_id = assignment.assignment_id;

CREATE VIEW num_d AS
SELECT assignment_id, count(total_mark) as num_0_49
FROM graded_group
WHERE total_mark >=0 and total_mark <=49
GROUP BY assignment_id;

CREATE VIEW num_d_zero AS
SELECT assignment.assignment_id, COALESCE(num_0_49,0) as num_0_49
FROM assignment 
left join num_d on num_d.assignment_id = assignment.assignment_id;

CREATE VIEW answer AS
SELECT average_mark.assignment_id, average_mark_percent, num_80_100, num_60_79, num_50_59, num_0_49
FROM average_mark 
join num_a_zero on average_mark.assignment_id = num_a_zero.assignment_id
join num_b_zero on average_mark.assignment_id = num_b_zero.assignment_id
join num_c_zero on average_mark.assignment_id = num_c_zero.assignment_id
join num_d_zero on average_mark.assignment_id = num_d_zero.assignment_id;



-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1 (SELECT * FROM answer);
