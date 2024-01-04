-- Steady work.

-- You must not change the next 2 lines or the table definition.
SET search_path TO markus;
DROP TABLE IF EXISTS q6 CASCADE;

CREATE TABLE q6 (
	group_id integer NOT NULL,
	first_file varchar(25) DEFAULT NULL,
	first_time timestamp DEFAULT NULL,
	first_submitter varchar(25) DEFAULT NULL,
	last_file varchar(25) DEFAULT NULL,
	last_time timestamp DEFAULT NULL,
	last_submitter varchar(25) DEFAULT NULL,
	elapsed_time interval DEFAULT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
DROP VIEW IF EXISTS groups_with_a1 CASCADE;
DROP VIEW IF EXISTS first_submission CASCADE;
DROP VIEW IF EXISTS first_submission_info CASCADE;
DROP VIEW IF EXISTS last_submission CASCADE;
DROP VIEW IF EXISTS last_submission_info CASCADE;
DROP VIEW IF EXISTS answer CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW groups_with_a1 AS
SELECT group_id, assignment.assignment_id
FROM assignmentgroup, assignment
WHERE description = 'A1' and assignment.assignment_id = assignmentgroup.assignment_id;

CREATE VIEW first_submission AS
SELECT submissions.group_id, min(submission_date) as first_time
FROM groups_with_a1 natural join submissions
GROUP BY submissions.group_id;

CREATE VIEW first_submission_info AS
SELECT first_submission.group_id, file_name as first_file, first_time, username as first_submitter
FROM first_submission, submissions
WHERE first_submission.group_id = submissions.group_id and submissions.submission_date = first_submission.first_time;

CREATE VIEW last_submission AS
SELECT submissions.group_id, max(submission_date) as last_time
FROM groups_with_a1 natural join submissions
GROUP BY submissions.group_id;

CREATE VIEW last_submission_info AS
SELECT last_submission.group_id, file_name as last_file, last_time, username as last_submitter
FROM last_submission, submissions
WHERE last_submission.group_id = submissions.group_id and submissions.submission_date = last_submission.last_time;

CREATE VIEW answer AS
SELECT group_id, first_file, first_time, first_submitter, last_file, last_time, last_submitter, last_time - first_time as elapsed_time
FROM first_submission_info natural join last_submission_info;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q6 (SELECT * from answer);
