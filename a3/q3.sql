SET search_path TO recording;
DROP TABLE IF EXISTS q3 CASCADE;

CREATE TABLE q3 (
    person_id integer NOT NULL,
    surname varchar(15) NOT NULL,
    first_name varchar(15) NOT NULL

);


DROP VIEW IF EXISTS sum_seg CASCADE;
DROP VIEW IF EXISTS max_seg CASCADE;
DROP VIEW IF EXISTS band_member_playing CASCADE;
DROP VIEW IF EXISTS everyone_playing CASCADE;
DROP VIEW IF EXISTS answer CASCADE;

CREATE VIEW sum_seg AS 
SELECT session_id, sum(length)
FROM RecordingSegment
GROUP BY session_id;

CREATE VIEW max_seg AS 
SELECT session_id 
FROM sum_seg as s1
WHERE s1.sum = (
    SELECT max(s2.sum) 
    FROM sum_seg AS s2
);

CREATE VIEW band_member_playing AS 
SELECT session_id, person_id
FROM BandMember natural join BandPlaying natural join max_seg;

CREATE VIEW everyone_playing AS 
SELECT * FROM band_member_playing
UNION
SELECT * FROM PersonPlaying natural join max_seg;

CREATE VIEW answer AS 
SELECT person_id, surname, first_name
FROM everyone_playing natural join person;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3 (SELECT * FROM answer);

SELECT * FROM q3;