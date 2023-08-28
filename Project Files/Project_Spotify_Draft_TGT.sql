IF NOT EXISTS(SELECT * FROM sys.databases where name = 'testSpotify')
    CREATE DATABASE testSpotify
GO

-- DROP ASSETS
USE testSpotify
GO
-- Check if constraints exist
-- IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
--     WHERE CONSTRAINT_NAME = '<ADDCONSTRAINTNAME>')
--     ALTER TABLE jobs DROP CONSTRAINT <ADDCONSTRAINTNAME>

IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_items_genre_item_id')
    ALTER TABLE Items_Genre DROP CONSTRAINT fk_items_genre_item_id

IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_items_genre_genre_id')
    ALTER TABLE Items_Genre DROP CONSTRAINT fk_items_genre_genre_id

IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk2_item_playlists_playlist_id')
    ALTER TABLE Item_Playlists DROP CONSTRAINT fk2_item_playlists_playlist_id

IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk1_item_playlists_item_id')
    ALTER TABLE Item_Playlists DROP CONSTRAINT fk1_item_playlists_item_id

IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_settings_user_id')
    ALTER TABLE Settings DROP CONSTRAINT fk_settings_user_id

DROP TABLE IF EXISTS Artists
DROP TABLE IF EXISTS Songs
DROP TABLE IF EXISTS  Podcasts
DROP TABLE IF EXISTS Items_Type_Lookup
DROP TABLE IF EXISTS Items_Genre
DROP TABLE IF EXISTS Genres_Lookup
DROP TABLE IF EXISTS Item_Playlists
DROP TABLE IF EXISTS Items
DROP TABLE IF EXISTS Playlists
DROP TABLE IF EXISTS Settings
DROP TABLE IF EXISTS Users
GO

-- CREATE ASSETS
USE testSpotify
GO
CREATE TABLE Users (
    user_id INT IDENTITY NOT NULL,
    user_firstname VARCHAR(50) NOT NULL,
    user_lastname VARCHAR(50) NOT NULL,
    user_email VARCHAR(50) NOT NULL,
    user_password VARCHAR(50) NOT NULL,
    CONSTRAINT pk_users_user_id PRIMARY KEY(user_id),
    CONSTRAINT u_user_email UNIQUE(user_email),
    CONSTRAINT ck_user_password CHECK(user_password IS NOT NULL)
)
GO


USE testSpotify
CREATE TABLE Settings (
    setting_id INT IDENTITY NOT NULL,
    setting_language VARCHAR(100) NOT NULL,
    setting_normalize_volume INT ,
    setting_volume_level VARCHAR(15) NOT NULL,
    setting_stream_quality VARCHAR(10),
    setting_user_id INT NOT NULL,
    CONSTRAINT pk_settings_setting_id PRIMARY KEY(setting_id),
)
GO

ALTER TABLE Settings 
    ADD CONSTRAINT fk_settings_user_id FOREIGN KEY(setting_user_id) 
    REFERENCES Users(user_id)
GO

USE testSpotify
CREATE TABLE Playlists (
    playlist_id INT IDENTITY NOT NULL,
    playlist_name VARCHAR(50) NOT NULL,
    playlist_created_date DATETIME,
    playlist_liked_song_name VARCHAR(50) NOT NULL,
    playlist_user_id INT NOT NULL,
    playlist_item_id INT NOT NULL,
    CONSTRAINT pk_playlists_playlist_id PRIMARY KEY(playlist_id),
)
GO

USE testSpotify
CREATE TABLE Items (
    item_id INT IDENTITY NOT NULL,
    item_title VARCHAR(100) NOT NULL,
    item_genre VARCHAR(50) NOT NULL,
    item_duration TIME,
    item_album_id INT NOT NULL,
    item_album_name VARCHAR,
    item_album_record_label_id VARCHAR(50) NOT NULL,
    item_album_record_label VARCHAR(50) NOT NULL,
    item_album_song_count INT NOT NULL,
    item_release_date DATE NOT NULL,
    item_playlist_name VARCHAR(50),
    item_podcast_id INT NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    CONSTRAINT pk_items_item_id PRIMARY KEY(item_id)
)
GO

-- ALTER TABLE Items 
--     ADD CONSTRAINT fk1_items_item_type FOREIGN KEY (item_type)
--     REFERENCES Items_Type_Lookup(item_type)
-- GO

-- ALTER TABLE Item
--     ADD CONSTRAINT fk2_items_podcast_id FOREIGN KEY (item_podcast_id)
--     REFERENCES Podcasts(podcast_id)
-- GO


USE testSpotify
CREATE TABLE Item_Playlists (
    playlist_id INT NOT NULL,
    playlist_item_id INT NOT NULL
)
GO

ALTER TABLE Item_Playlists
    ADD CONSTRAINT fk1_item_playlists_item_id FOREIGN KEY (playlist_item_id)
    REFERENCES Items(item_id)
GO

ALTER TABLE Item_Playlists 
    ADD CONSTRAINT fk2_item_playlists_playlist_id FOREIGN KEY (playlist_id)
    REFERENCES Playlists(playlist_id)
GO

USE testSpotify
CREATE TABLE Genres_Lookup (
    genre_id INT NOT NULL,
    genre_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_genres_genre_id PRIMARY KEY(genre_id),
    CONSTRAINT u_genres_lookup_genre_name UNIQUE(genre_name)
)
GO

USE testSpotify
CREATE TABLE Items_Genre (
    genre_id INT NOT NULL,
    genre_item_id INT NOT NULL,
)
GO

ALTER TABLE Items_Genre
    ADD CONSTRAINT fk_items_genre_genre_id FOREIGN KEY (genre_id)
    REFERENCES Genres_Lookup(genre_id)
GO

ALTER TABLE Items_Genre
    ADD CONSTRAINT fk_items_genre_item_id FOREIGN KEY (genre_item_id)
    REFERENCES Items(item_id)
GO

USE testSpotify
CREATE TABLE Items_Type_Lookup (
    item_id INT NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    CONSTRAINT u_items_type_lookup_name UNIQUE(item_type)
)
GO 

USE testSpotify
CREATE TABLE Podcasts (
    podcast_id INT IDENTITY NOT NULL,
    podcast_name VARCHAR(100) NOT NULL,
    podcast_description VARCHAR(150),
    podcast_episode_number INT,
    podcast_artist_name VARCHAR(50) NOT NULL,
    podcast_item_id INT NOT NULL
)
GO

USE testSpotify
CREATE TABLE Songs (
    song_id INT IDENTITY NOT NULL,
    song_name VARCHAR(50) NOT NULL,
    song_artist_id INT NOT NULL,
    song_album_id INT NOT NULL,
    song_duration INT,
    song_release_date VARCHAR(50),
    song_genre_id INT,
    song_item_id INT NOT NULL
    CONSTRAINT pk_songs_song_id PRIMARY KEY(song_id),
)
GO

USE testSpotify
CREATE TABLE Artists (
    artist_id INT IDENTITY NOT NULL,
    artist_name VARCHAR(50) NOT NULL,
    artist_genre_id INT NOT NULL,
    CONSTRAINT pk_artists_artist_id PRIMARY KEY(artist_id),
    -- FOREIGN KEY(artist_genre_id) REFERENCES Genres(genre_id),
    -- FOREIGN KEY(artist_record_label_id) REFERENCES RecordLabels(label_id)
)
GO

-- -- -- UPDATE ASSETS Seed Data initially
USE testSpotify
INSERT INTO Users(user_firstname, user_lastname, user_email, user_password)
VALUES('Timothy', 'Tieng', 'Timsemail@email.com','PASSWORD123')

USE testSpotify
INSERT INTO Users(user_firstname, user_lastname, user_email, user_password)
VALUES('Gustavo', 'Gyotoku', 'GustavoEmail@syr.com','123qwe123')

USE testSpotify
INSERT INTO Users(user_firstname, user_lastname, user_email, user_password)
VALUES('Peter', 'Broecker', 'PeterB@email.com','PeterB!!')

USE testSpotify
INSERT INTO Settings(setting_language,setting_normalize_volume, setting_volume_level, setting_stream_quality, setting_user_id)
VALUES('English', 50, 'Medium', 'High Qual', 1 )

USE testSpotify
INSERT INTO Settings(setting_language,setting_normalize_volume, setting_volume_level, setting_stream_quality, setting_user_id)
VALUES('English', 100, 'High', 'High Qual', 2 )

USE testSpotify
INSERT INTO Settings(setting_language,setting_normalize_volume, setting_volume_level, setting_stream_quality, setting_user_id)
VALUES('Spanish', 25, 'Low', 'Med Qual', 3 )

USE testSpotify
INSERT INTO Genres_Lookup (genre_id, genre_name)
VALUES (1, 'Metal'); 

USE testSpotify
INSERT INTO Genres_Lookup (genre_id, genre_name)
VALUES (2, 'American Rock'); 

USE testSpotify
INSERT INTO Genres_Lookup (genre_id, genre_name)
VALUES (3, 'Electronic Dance Music'); 

USE testSpotify
INSERT INTO Genres_Lookup (genre_id, genre_name)
VALUES (4, 'Podcast'); 


USE testSpotify
INSERT INTO Items_Type_Lookup (item_id, item_type)
VALUES(1, 'Song')


USE testSpotify
INSERT INTO Items_Type_Lookup (item_id, item_type)
VALUES(2, 'Album')

USE testSpotify
INSERT INTO Items_Type_Lookup (item_id, item_type)
VALUES(3, 'Playlist')

USE testSpotify
INSERT INTO Items_Type_Lookup (item_id, item_type)
VALUES(4, 'Podcast')


USE testSpotify 
INSERT INTO Podcasts (podcast_name, podcast_description, podcast_episode_number, podcast_artist_name, podcast_item_id)
VALUES ('Neil deGrasse Tyson', 'NDT discusses his career with Joe Rogan', 1904, 'Joe Rogan',4) --All Podcasts wil have an item id of 4

USE testSpotify 
INSERT INTO Podcasts (podcast_name, podcast_description, podcast_episode_number, podcast_artist_name, podcast_item_id)
VALUES ('The Billion dollar pollution Solution', 'Could the same mechanism used to accelerate vaccine dev. lead to climate crisises', 250, 'TED Talks',4)

USE testSpotify 
INSERT INTO Podcasts (podcast_name, podcast_description, podcast_episode_number, podcast_artist_name, podcast_item_id)
VALUES ('Border Patrol Agent Turned Serial Killer', 'Learn how a Federal Agent became Americas Most Wanted', 15, 'True Crime Daily',4)

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration, song_release_date, song_item_id)
VALUES ('Master of Puppets (Remastered)', 1,1,1, 8, '01-02-1980',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Battery (Remastered)', 1,1,1, 5, '01-02-1980',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Welcome Home Sanitarium (Remastered)', 1,1,1, 6, '01-02-1980', 1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Africa', 2,2,2, 3, '02-12-1982',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Rosanna', 2,2,2, 3, '02-12-1982',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Good For You', 2,2,2, 3, '02-12-1982',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('There Might Be Coffee', 3,3,3, 7, '03-01-2012',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('The Veldt - 8 Minute Edit', 3,3,3, 8, '03-01-2012',1); 

USE testSpotify
INSERT INTO Songs (song_name, song_artist_id, song_album_id, song_genre_id, song_duration,song_release_date, song_item_id)
VALUES ('Sleepless', 3,3,3, 8, '03-01-2012',1); 


USE testSpotify
INSERT INTO Artists (artist_name, artist_genre_id)
VALUES ( 'Metallica', 1);

USE testSpotify
INSERT INTO Artists (artist_name, artist_genre_id)
VALUES ('Toto', 2);

USE testSpotify
INSERT INTO Artists (artist_name, artist_genre_id)
VALUES ('Deadmau5', 3);

-- -- -- VERIFY ASSETS OUTPUT
USE testSpotify
SELECT *
FROM Users;

USE testSpotify
SELECT *
FROM Settings;

-- Test via Join
Print'User Settings by Users'
SELECT u.user_id, u.user_firstname, u.user_lastname, u.user_email,s.setting_language, s.setting_normalize_volume, s.setting_stream_quality FROM Users u
JOIN Settings s ON s.setting_user_id = u.user_id

-- USE testSpotify
-- SELECT *
-- FROM Playlists;

-- USE testSpotify
-- SELECT *
-- FROM Item_Playlists;

-- USE testSpotify
-- SELECT *
-- FROM Items;

USE testSpotify
SELECT *
FROM Genres_Lookup;

-- USE testSpotify
-- SELECT *
-- FROM Items_Genre;

USE testSpotify
SELECT *
FROM Items_Type_Lookup;

USE testSpotify
SELECT *
FROM Podcasts;

-- Test Podcast withItem_type Loopup via join
SELECT * FROM Items_Type_Lookup itl 
JOIN Podcasts p ON p.podcast_item_id =itl.item_id
WHERE itl.item_type = 'Podcast'

USE testSpotify
SELECT *
FROM Songs;

USE testSpotify
SELECT *
FROM Artists;

-- Test Song/ARtist Relationship via Join
SELECT *
FROM Artists a 
JOIN Songs s  ON song_artist_id = artist_id
ORDER BY a.artist_name ASC;
