SET SEARCH_PATH TO recording;

INSERT INTO
    Studio(studio_id, name, address)
VALUES
    (1, 'Pawnee Recording Studio', '123 Valley spring lane, Pawnee, Indiana'),
    (2, 'Pawnee Sound', '353 Western Ave, Pawnee, Indiana'),
    (3, 'Eagleton Recording Studio', '829 Division, Eagleton, Indiana');

INSERT INTO
    Session(session_id, studio_id, start_time, end_time, fee)
VALUES  
    (1, 1, '2023-01-08 10:00', '2023-01-08 15:00', 1500),
    (2, 1, '2023-01-10 13:00', '2023-01-11 14:00', 1500),
    (3, 1, '2023-01-12 18:00', '2023-01-13 20:00', 1500),
    (4, 1, '2023-03-10 11:00', '2023-03-10 23:00', 2000),
    (5, 1, '2023-03-11 13:00', '2023-03-12 15:00', 2000),
    (6, 1, '2023-03-13 10:00', '2023-03-13 20:00', 1000),
    (7, 3, '2023-09-25 11:00', '2023-09-26 23:00', 1000),
    (8, 3, '2023-09-29 11:00', '2023-09-30 23:00', 1000);

INSERT INTO
    Person(person_id, surname, first_name, email, phone)
VALUES
    (1000, 'Silver', 'Duke', 'duke@gmail.com', '4161234578'),
    (1231, 'Ludgate', 'April', 'april@gmail.com', '4161234569'),
    (1232, 'Knope', 'Leslie', 'leslie@gmail.com', '4161234570'),
    (1233, 'Meagle', 'Donna', 'donna@gmail.com' , '4161234567'),
    (1234, 'Haverford', 'Tom', 'tom@gmail.com', '4161234568'),
    (2224, 'Chang', 'Michael', 'michael@gmail.com', '4161234576'),
    (4523, 'Burlinson', 'Andrew', 'andrew@gmail.com', '4161234575'),
    (5678, 'Wyatt', 'Ben', 'ben@gmail.com', '4161234571'),
    (6521, 'Traeger', 'Chris', 'chris@gmail.com', '4161234573'),
    (6754, 'Dwyer', 'Andy', 'andy@gmail.com', '4161234574'),
    (7832, 'Pierson', 'James', 'james@gmail.com', '4161234577'),
    (9942, 'Perkins', 'Ann', 'ann@gmail.com', '4161234572');

INSERT INTO
    RecordingEngineer(session_id, person_id)
VALUES
    (1, 5678),
    (1, 9942),
    (2, 5678),
    (2, 9942),
    (3, 5678),
    (3, 9942),
    (4, 5678),
    (5, 5678),
    (6, 6521),
    (7, 5678),
    (8, 5678);

INSERT INTO
    Certification(certification_id, person_id, certification)
VALUES
    (1, 5678, 'ABCDEFGH-123I'),
    (2, 5678, 'JKLMNOPQ-456R'),
    (3, 9942, 'SOUND-123-AUDIO');

INSERT INTO
    Manages(studio_id, person_id, start_date)
VALUES
    (1, 1233, '2018-12-02'),
    (1, 1234, '2017-01-13'),
    (1, 1231, '2008-03-21'),
    (2, 1233, '2011-05-07'),
    (3, 1232, '2020-09-05'),
    (3, 1234, '2016-09-05'),
    (3, 1232, '2010-09-05');

INSERT INTO
    Band(band_id, name)
VALUES
    (1, 'Mouse Rat');

INSERT INTO
    BandMember(band_id, person_id)
VALUES
    (1, 6754),
    (1, 4523),
    (1, 2224),
    (1, 7832);

INSERT INTO
    BandPlaying(session_id, band_id)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1);

INSERT INTO
    PersonPlaying(session_id, person_id)
VALUES
    (1, 1000),
    (2, 1000),
    (3, 1000),
    (6, 6754),
    (6, 1234),
    (7, 6754),
    (8, 6754); 

INSERT INTO 
    Album(album_id, name, release_date)
VALUES
    (1, 'The Awesome Album', '2023-05-25'),
    (2, 'Another Awesome Album', '2023-10-29');

INSERT INTO
    Track(track_id, name)
VALUES
    (1, '5,000 Candles in the Wind'),
    (2, 'Catch Your Dream'),
    (3, 'May Song'),
    (4, 'The Pit'),
    (5, 'Remember'),
    (6, 'The Way You Look Tonight'),
    (7, 'Another Song');

INSERT INTO
    AlbumTrack(album_id, track_id)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (2, 7);

DO $$
BEGIN
    FOR i in 1..10 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 1, 60, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 11..15 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 2, 60, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 16..19 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 3, 60, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 20..21 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 4, 120, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 22..26 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 6, 60, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 27..35 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 7, 180, 'AIFF');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 36..41 LOOP
    INSERT INTO RecordingSegment(segment_id, session_id, length, format) 
        values(i, 8, 180, 'WAV');
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 11..15 LOOP
    INSERT INTO TrackSegment(track_id, segment_id) 
        values(1, i);
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 16..21 LOOP
    INSERT INTO TrackSegment(track_id, segment_id) 
        values(2, i);
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 22..26 LOOP
    INSERT INTO TrackSegment(track_id, segment_id) 
        values(1, i);
    END LOOP;
END;
$$;

DO $$
BEGIN
    FOR i in 22..26 LOOP
    INSERT INTO TrackSegment(track_id, segment_id) 
        values(2, i);
    END LOOP;
END;
$$;

INSERT INTO
    TrackSegment(track_id, segment_id)
VALUES
    (3, 32),
    (3, 33),
    (4, 34),
    (4, 35),
    (5, 36),
    (5, 37),
    (6, 38),
    (6, 39),
    (7, 40),
    (7, 41);
