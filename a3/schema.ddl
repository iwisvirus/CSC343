-- Could not:
-- We cannot enforce the constraint that Each session 
-- has at most 3 recording engineers without using assertions 
-- and triggers as we need to check with a predicate that has an 
-- aggregrate method to enforce the max number of recording engineers.

-- We cannot enforce the constraint that Each album has at least 2 tracks 
-- without using assertions and triggers as we need to check with a predicate 
-- that has an aggregrate method to enforce the min number of tracks for an 
-- album.

-- Did not:
-- We did not enforce the constraint that Each session has at least 1 engineer
-- without using assertions and triggers because then we would need to include
-- the engineer into the Session table. 
-- This will cause redundancy in the Session table that we do not want.

-- We did not enforce the constraint that Each band has at 
-- least 1 member without using assertions and triggers to avoid redundancy.
-- To enforce this, 
-- we would need to include a member column into the Band table. Since a band 
-- has no upper bound for its members, we would allow many redundancy in the 
-- table. 
-- Therefore, we added it as an assumption that every band is included in the 
-- BandMember table.

-- We did not enforce the constraint that Each track must appear on at least 
-- one album without using assertions and triggers to avoid redundancy. 
-- To enforce this, we would need to include an album column column into the 
-- Track table. 
-- Since a track has no upper bound for its album appearances, we would allow
-- many redundancy in the table. 
-- Therefore, we added it as an assumption that every track is included in the 
-- AlbumTrack table.

-- We did not enforce the constraint that Each session has at least 1 person
-- playing without using assertions and triggers to avoid redundancy. 
-- To enforce this, we would need to include a player column into the Session 
-- table. Since a session has no upper bound for person or band playing, 
-- we would allow many redundancy in the table. 

-- Extra constraints:
-- Length of a segment must be greater than 0.
-- Session fee must a positive float number (not negative)


-- Assumption:
-- Every band is included the BandMember table
-- Band[band_id] = BandMember[band_id]

-- Every Track is included in AlbumTrack
-- Track[track_id] = AlbumTrack[track_id]

-- Every Session is included in BandPlaying natural join PersonPlaying
-- Session[session_id] = BandPlaying[session_id] natural join 
-- PersonPlaying[session_id] 

-- Every Studio is included in Manages.

-- Person_id in RecordingEngineer is the id of a recording engineer.

-- There are no gaps in managements. (provided in assignment)

-- A person, person_id in PersonPlaying, is not part of a band in BandPlaying 
-- with the same session_id




-- A person in PersonPlaying for a session is not a part of a band in 
-- BandPlaying for that same session.
DROP SCHEMA IF EXISTS recording CASCADE;
CREATE SCHEMA recording;
SET SEARCH_PATH TO recording;


-- A studio registered as a recording studio.
CREATE TABLE Studio (
    studio_id SERIAL PRIMARY KEY, 
    name varchar(25) NOT NULL,
    address varchar(50) NOT NULL
);

CREATE DOMAIN positiveFloat AS real
    DEFAULT NULL
    CHECK (VALUE > 0.0);

-- A session booked at a recording studio.
-- <start_time> is the start time of its booking.
-- <end_time> is the end time of its booking.
-- <fee> is the cost for the booking.
CREATE TABLE Session (
    session_id SERIAL PRIMARY KEY, 
    studio_id integer REFERENCES Studio ON DELETE CASCADE,
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    fee positiveFloat NOT NULL,
    UNIQUE (studio_id, start_time),
    CHECK (start_time < end_time)
);

-- Person in this database
-- <email> is their email address.
-- <phone> is their phone number. We assume the format is XXX-XXX-XXXX
CREATE TABLE Person (
    person_id integer PRIMARY KEY,
    surname varchar(15) NOT NULL,
    first_name varchar(15) NOT NULL,
    email varchar(40) NOT NULL,
    phone varchar(12) NOT NULL
);

-- A Recording Engineer for a session
-- Assumption:
--      Person_id is the id of a recording engineer.
CREATE TABLE RecordingEngineer (
    session_id integer REFERENCES Session ON DELETE CASCADE,
    person_id integer REFERENCES Person ON DELETE CASCADE, 
    PRIMARY KEY (session_id, person_id)
);

-- A certification for a recording engineer
CREATE TABLE Certification (
    certification_id SERIAL PRIMARY KEY,
    person_id integer REFERENCES Person ON DELETE CASCADE, 
    certification varchar(50) NOT NULL,
    UNIQUE (person_id, certification)
);

-- The person assigned as a manager for a studio.
-- <start_date> is the date they became the manager.
-- Assumption:
--      There are no gaps in managements. (provided in assignment)
--      Every Studio is included in Manages.
CREATE TABLE Manages (
    studio_id integer REFERENCES Studio ON DELETE CASCADE,
    person_id integer REFERENCES Person ON DELETE CASCADE, 
    start_date date NOT NULL,
    PRIMARY KEY (studio_id, start_date)
);

-- A Band.
CREATE TABLE Band (
    band_id SERIAL PRIMARY KEY, 
    name varchar(25) NOT NULL
);

-- A member of a band.
-- Assumption: 
--      Every Band included in BandMember
--      ie. Band[band_id] = BandMember[band_id]
CREATE TABLE BandMember (
    band_id integer REFERENCES Band ON DELETE CASCADE, 
    person_id integer REFERENCES Person ON DELETE CASCADE,
    PRIMARY KEY (band_id, person_id)
);

-- Assumption:
--      Every Session included in BandPlaying join PersonPlaying
--      ie. Session[session_id] = BandPlaying[session_id] natural join 
--      PersonPlaying[session_id]

-- A band playing in a session
CREATE TABLE BandPlaying (
    session_id integer REFERENCES Session ON DELETE CASCADE,
    band_id integer REFERENCES Band ON DELETE CASCADE, 
    PRIMARY KEY (session_id, band_id)
);


-- A person playing in a session
-- Assumption:
--      A person, person_id, is not part of a band in BandPlaying with the 
--      same session_id

CREATE TABLE PersonPlaying (
    session_id integer REFERENCES Session ON DELETE CASCADE,
    person_id integer REFERENCES Person ON DELETE CASCADE, 
    PRIMARY KEY (session_id, person_id)
);

-- An album.
CREATE TABLE Album (
    album_id SERIAL PRIMARY KEY,
    name varchar(50) NOT NULL,
    release_date date NOT NULL
);

-- A recording track.
CREATE TABLE Track (
    track_id SERIAL PRIMARY KEY,
    name varchar(50) NOT NULL
);

-- Track <track_id> has been declared to appear on album <album_id>.
-- Assumption: 
--      Every Track included in AlbumTrack
--      ie. Track[track_id] = AlbumTrack[track_id]
CREATE TABLE AlbumTrack (
    album_id integer REFERENCES Album ON DELETE CASCADE,
    track_id integer REFERENCES Track ON DELETE CASCADE,
    PRIMARY KEY (album_id, track_id)
);


-- A segment of a recording for a session
-- <length> is the length of the recording.
-- <format> is the format it was recorded in.
CREATE TABLE RecordingSegment (
    segment_id SERIAL PRIMARY KEY,
    session_id integer REFERENCES Session ON DELETE CASCADE,
    length integer NOT NULL,
    format varchar(5) NOT NULL,
    CHECK (length > 0)
);

-- Segment <segment_id> has been used for track <track_id>.
CREATE TABLE TrackSegment (
    track_id integer REFERENCES Track ON DELETE CASCADE,
    segment_id integer REFERENCES RecordingSegment ON DELETE CASCADE,
    PRIMARY KEY (track_id, segment_id)
);