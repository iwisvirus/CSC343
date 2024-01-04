SET search_path TO recording;
DROP TABLE IF EXISTS q2 CASCADE;

CREATE TABLE q2 (
	person_id integer NOT NULL,
	session_count integer NOT NULL
);

DROP VIEW IF EXISTS band_member_playing CASCADE;
DROP VIEW IF EXISTS everyone_playing CASCADE;

CREATE VIEW band_member_playing AS 
	SELECT session_id, person_id
	FROM BandMember NATURAL JOIN BandPlaying;

CREATE VIEW everyone_playing AS 
	SELECT * FROM band_member_playing
    UNION
    SELECT * FROM PersonPlaying;

INSERT INTO q2

SELECT person_id, count(session_id) as session_count
FROM Person NATURAL LEFT JOIN everyone_playing 
GROUP BY person_id;

SELECT * FROM q2;