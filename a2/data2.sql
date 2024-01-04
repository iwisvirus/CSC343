SET SEARCH_PATH TO markus;


INSERT INTO 
	MarkusUser(username, surname, firstname, type) 
VALUES
	('blahblah', 'blah', 'blabla', 'student'),
	('solostudent', 'solo', 'solsol', 'student'),
	('someoneelse', 'some', 'somsom', 'student'),
	('tlmyta', 'tlmy', 'tlmtlm', 'TA');


INSERT INTO 
	Assignment(assignment_id, description, due_date, group_min, group_max)
VALUES
	(1, 'A1', '2023-10-10 23:59', 1, 1),
	(2, 'A2', '2023-11-13 23:59', 1, 1),
	(3, 'A3', '2023-12-05 23:59', 1, 1);


INSERT INTO 
	AssignmentGroup(assignment_id, repo) 
VALUES
	-- A1
	(1, 'https://markus.teach.cs.toronto.edu/2023-01/courses/22/group_1'), -- group 1
	(1, 'https://markus.teach.cs.toronto.edu/2023-01/courses/22/group_2'), -- group 2
	(2, 'https://markus.teach.cs.toronto.edu/2023-01/courses/22/group_3'), -- group 3
	(2, 'https://markus.teach.cs.toronto.edu/2023-01/courses/22/group_4'), -- group 4
	(3, 'https://markus.teach.cs.toronto.edu/2023-01/courses/22/group_5'); -- group 5
	
	 

INSERT INTO 
	Membership(username, group_id)
VALUES
	-- A1
	('blahblah', 4),
	('blahblah', 5),
	('solostudent', 1),
	('someoneelse', 2),
	('someoneelse', 3);

INSERT INTO
	Submissions(submission_id, file_name, username, group_id, submission_date)
VALUES
	-- A1
	(1, 'a1.txt', 'solostudent', 1, '2023-10-07 11:00'),
	(2, 'a1.txt', 'someoneelse', 2, '2023-10-09 15:34'),
	(3, 'a2.txt', 'someoneelse', 3, '2023-10-08 12:00'),
	(4, 'a2.txt', 'blahblah', 4, '2023-10-10 23:30'),
	(5, 'a3.txt', 'blahblah', 5, '2023-10-10 18:05');


INSERT INTO 
	Grader(group_id, username)
VALUES
	(1, 'tlmyta'),
	(2, 'tlmyta'),
	(3, 'tlmyta'),
	(4, 'tlmyta'),
	(5, 'tlmyta');


INSERT INTO
	RubricItem(rubric_id, assignment_id, name, out_of, weight)
VALUES
	-- A1
	(1, 1, 'Criteria 1', 100, 100.0),
	(2, 2, 'Criteria 2', 100, 100.0),
	(3, 3, 'Criteria 3', 100, 100.0);


INSERT INTO 
	Grade(group_id, rubric_id, grade)
VALUES
	-- A1
	-- Group 1
	(1, 1, 90),
	(2, 1, 100),
	(3, 2, 100),
	(4, 2, 10),
	(5, 3, 70);


INSERT INTO
	Result(group_id, mark, released)
VALUES
	(1, 90, true),
	(3, 100, false),
	(4, 10, true);
	



