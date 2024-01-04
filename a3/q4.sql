SET search_path TO recording;
DROP TABLE IF EXISTS q4 CASCADE;

CREATE TABLE q4 (
	album_id integer NOT NULL,
	album_name varchar NOT NULL,
    session_count integer NOT NULL,
    people_count integer NOT NULL
);

DROP VIEW IF EXISTS album_session CASCADE;
DROP VIEW IF EXISTS band_member_playing CASCADE;
DROP VIEW IF EXISTS everyone_playing CASCADE;
DROP VIEW IF EXISTS album_session_count CASCADE;
DROP VIEW IF EXISTS album_people_count CASCADE;
DROP VIEW IF EXISTS most_sessions CASCADE;

CREATE VIEW album_session AS 
	SELECT DISTINCT album_id, name as album_name, session_id
	FROM Album NATURAL JOIN AlbumTrack 
    NATURAL JOIN TrackSegment NATURAL JOIN RecordingSegment;

CREATE VIEW band_member_playing AS 
	SELECT session_id, person_id
	FROM BandMember NATURAL JOIN BandPlaying;

CREATE VIEW everyone_playing AS 
	SELECT * FROM band_member_playing
    UNION
    SELECT * FROM PersonPlaying;

CREATE VIEW album_session_count AS 
    SELECT album_id, album_name, count(session_id) as session_count
    FROM album_session 
    GROUP BY album_id, album_name;

CREATE VIEW album_people_count AS 
    SELECT album_id, album_name, count(person_id) as people_count
    FROM album_session NATURAL JOIN everyone_playing 
    GROUP BY album_id, album_name;

CREATE VIEW most_sessions AS
    SELECT album_id, session_count
    FROM album_session_count 
    WHERE session_count = (SELECT MAX(session_count) as session_id
						   FROM album_session_count);


INSERT INTO q4

SELECT album_id, album_name, session_count, people_count
FROM most_sessions NATURAL JOIN album_people_count;

SELECT * FROM q4;