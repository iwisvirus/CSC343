SET search_path TO recording;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1 (
    studio varchar(25) NOT NULL,
    manager_id integer NOT NULL,
    manager_surname varchar(15) NOT NULL,
    manager_first_name varchar(15) NOT NULL,
    num_albums integer NOT NULL

);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- minimum and maximum grade they have given 
DROP VIEW IF EXISTS current_manager CASCADE;
DROP VIEW IF EXISTS names CASCADE;
DROP VIEW IF EXISTS album_session CASCADE;
DROP VIEW IF EXISTS studio_num CASCADE;
DROP VIEW IF EXISTS answer CASCADE;


-- Define views for your intermediate steps here:
CREATE VIEW current_manager AS
SELECT m1.studio_id, m1.person_id
FROM Manages AS m1
WHERE m1.start_date = (
    SELECT MAX(m2.start_date)
    FROM Manages AS m2
    WHERE m2.studio_id = m1.studio_id
);

CREATE VIEW names AS
SELECT studio_id, name as studio, person.person_id as manager_id, surname as manager_surname, first_name as manager_first_name
FROM person natural join studio natural join current_manager;

-- number of albums each studio contributed
-- at least one recording segment recorded there is part of that album
CREATE VIEW album_session AS 
SELECT DISTINCT album_id, session_id
FROM Album NATURAL JOIN AlbumTrack NATURAL JOIN TrackSegment NATURAL JOIN RecordingSegment;

CREATE VIEW studio_num AS
SELECT DISTINCT studio_id, album_id
FROM Session natural join album_session;

CREATE VIEW answer AS
SELECT studio, manager_id, manager_surname, manager_first_name, count(album_id)
FROM studio_num natural right join names
GROUP BY studio, manager_id, manager_surname, manager_first_name;


-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1 (SELECT * FROM answer);

SELECT * FROM q1;