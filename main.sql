-- -----------------------------------------------------
-- Creación de la BASE.
-- -----------------------------------------------------

CREATE DATABASE IF NOT EXISTS AnimeManagement;
USE AnimeManagement;

-- -----------------------------------------------------
-- Creación de las TABLAS.
-- -----------------------------------------------------

-- Create table AnimeStatus
CREATE TABLE AnimeStatus (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

--

-- Create table AuthorRoleTypes
CREATE TABLE AuthorRoleTypes (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_role_name (role_name)
);

--

-- Create table Anime
CREATE TABLE Anime (
    anime_id INT PRIMARY KEY AUTO_INCREMENT,
    anime_title VARCHAR(255) NOT NULL UNIQUE,
    anime_synopsis TEXT,
    anime_status_id INT,
    FOREIGN KEY (anime_status_id) REFERENCES AnimeStatus(status_id),
    INDEX idx_anime_title (anime_title)
);

--

-- Create table AnimeHistory
CREATE TABLE AnimeHistory (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    anime_id INT,
    old_anime_title VARCHAR(255),
    new_anime_title VARCHAR(255),
    old_anime_synopsis TEXT,
    new_anime_synopsis TEXT,
    old_anime_status_id INT,
    new_anime_status_id INT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id)
);

--

-- Create table Genre
CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_genre_name (genre_name)
);

--

-- Create table AnimeGenres
CREATE TABLE AnimeGenres (
    anime_id INT,
    genre_id INT,
    PRIMARY KEY (anime_id, genre_id),
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id),
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);

--

-- Create table Country
CREATE TABLE Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_country_name (country_name)
);

--

-- Create table Author
CREATE TABLE Author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL UNIQUE,
    author_birth_date DATE,
    author_country_id INT,
    FOREIGN KEY (author_country_id) REFERENCES Country(country_id) ON DELETE SET NULL,
    INDEX idx_author_name (author_name)
);

--

-- Create table AuthorRoles
CREATE TABLE AuthorRoles (
    author_role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT,
    author_id INT,
    anime_id INT,
    FOREIGN KEY (role_id) REFERENCES AuthorRoleTypes(role_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Author(author_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE
);

--

-- Create table Episode
CREATE TABLE Episode (
    episode_id INT PRIMARY KEY AUTO_INCREMENT,
    episode_title VARCHAR(255) NOT NULL UNIQUE,
    episode_number INT NOT NULL CHECK (episode_number >= 0),
    episode_air_date DATE,
    anime_id INT,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE,
    UNIQUE (anime_id, episode_number)
);

--

-- Create table User
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL UNIQUE,
    user_email VARCHAR(255) NOT NULL UNIQUE,
    user_password VARCHAR(255) NOT NULL,
    country_id INT,
    user_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES Country(country_id) ON DELETE SET NULL,
    INDEX idx_user_name (user_name),
    INDEX idx_user_email (user_email)
);

--

-- Create table EpisodeComments
CREATE TABLE EpisodeComments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    comment_content TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    episode_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE CASCADE
);

--

-- Create table Review
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    review_content TEXT,
    review_rating DECIMAL(2, 1) NOT NULL CHECK (review_rating >= 1 AND review_rating <= 10),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    anime_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE,
    INDEX idx_review_rating (review_rating),
    INDEX idx_review_date (review_date)
);

--

-- Create table UserFavorites
CREATE TABLE UserFavorites (
    user_id INT,
    anime_id INT,
    PRIMARY KEY (user_id, anime_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE
);

--

-- Create table Notifications
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT,
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

-- -----------------------------------------------------
-- Inserción de Datos.
-- -----------------------------------------------------

-- Insert data into table AnimeStatus
INSERT INTO AnimeStatus (status_name) VALUES
('Airing'),
('Completed'),
('Upcoming'),
('On Hold');

--

-- Insert data into table AuthorRoleTypes
INSERT INTO AuthorRoleTypes (role_name) VALUES
('Director'),
('Writer'),
('Music Composer'),
('Producer'),
('Animator'),
('Illustrator');


--

-- Insert data into table Anime
INSERT INTO Anime (anime_title, anime_synopsis, anime_status_id) VALUES
('Naruto', 'Naruto Uzumaki, a young ninja with sealed demon fox spirit, seeks recognition and dreams of becoming Hokage.', 2),
('One Piece', 'Monkey D. Luffy sets out to become the Pirate King by finding the legendary treasure One Piece.', 1),
('Attack on Titan', 'Eren Yeager vows to rid the world of the giant humanoid Titans after his hometown is destroyed.', 2),
('Death Note', 'A high school student discovers a supernatural notebook that allows him to kill anyone whose name he writes in it.', 2),
('My Hero Academia', 'In a world where nearly every human has a unique power, a powerless boy enrolls in a hero academy.', 1),
('Demon Slayer', 'A young boy becomes a demon slayer to avenge his family and cure his sister of a demon curse.', 1),
('Fullmetal Alchemist: Brotherhood', 'Two brothers search for a Philosopher\'s Stone after an attempt to revive their deceased mother goes awry.', 2),
('Dragon Ball Z', 'After Goku grows up, he faces even more dangerous enemies from space.', 2),
('Sword Art Online', 'Players of a virtual reality MMORPG are trapped in the game and must fight their way to freedom.', 2),
('Tokyo Ghoul', 'A college student becomes a half-ghoul after a violent encounter, struggling to fit into the ghoul society.', 2),
('Bleach', 'Ichigo Kurosaki gains the abilities of a Soul Reaper and protects the living world from evil spirits and other supernatural threats.', 2),
('Fairy Tail', 'Lucy, a celestial wizard, joins the notorious Fairy Tail guild and partners with Natsu, a dragon slayer wizard, on various adventures.', 2),
('Hunter x Hunter', 'Gon Freecss becomes a Hunter to find his father, encountering strange and dangerous adventures along the way.', 2),
('Steins;Gate', 'A group of friends create a device that can send messages to the past, leading them into a complex world of conspiracy and time travel.', 2),
('Sword Art Online II', 'Kirito is asked to investigate a new VRMMO game called Gun Gale Online where players are mysteriously dying in real life.', 2),
('Code Geass: Lelouch of the Rebellion', 'Lelouch Lamperouge, a Britannian prince in hiding, gains the power of Geass and uses it to lead a rebellion against the Holy Britannian Empire.', 2),
('No Game No Life', 'Siblings Sora and Shiro are transported to a world where everything is decided by games and aim to conquer it.', 2),
('Re:Zero - Starting Life in Another World', 'Subaru Natsuki is transported to a fantasy world where he discovers he has the ability to "Return by Death," resetting time upon his death.', 2),
('Your Lie in April', 'A piano prodigy who loses his ability to hear the piano after his mother\'s death is brought back into the music world by a spirited violinist.', 2),
('Black Clover', 'Asta, a boy born without magic in a world where everyone has magic, aims to become the Wizard King.', 1);

--

-- Insert data into table Genre
INSERT INTO Genre (genre_name) VALUES
('Action'),
('Adventure'),
('Comedy'),
('Drama'),
('Fantasy'),
('Magic'),
('Mystery'),
('Psychological'),
('Romance'),
('Sci-Fi');

--

-- Insert data into table AnimeGenres
INSERT INTO AnimeGenres (anime_id, genre_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7), (4, 8),
(5, 9), (5, 10),
(6, 1), (6, 3),
(7, 2), (7, 4),
(8, 5), (8, 7),
(9, 6), (9, 8),
(10, 9), (10, 10),
(11, 1), (11, 2),
(12, 3), (12, 4),
(13, 5), (13, 6),
(14, 7), (14, 8),
(15, 9), (15, 10),
(16, 1), (16, 3),
(17, 2), (17, 4),
(18, 5), (18, 7),
(19, 6), (19, 8),
(20, 9), (20, 10);

--

-- Insert data into table Country
INSERT INTO Country (country_name) VALUES
('Japan'),
('United States'),
('South Korea'),
('China'),
('Canada'),
('France'),
('Germany'),
('India'),
('Brazil'),
('United Kingdom');

--

-- Insert data into table Author
INSERT INTO Author (author_name, author_birth_date, author_country_id) VALUES
('Hayao Miyazaki', '1941-01-05', 1),
('Makoto Shinkai', '1973-02-09', 1),
('Satoshi Kon', '1963-10-12', 1),
('Mamoru Hosoda', '1967-09-19', 1),
('Naoko Yamada', '1984-11-28', 1),
('Hiroyuki Imaishi', '1971-10-04', 1),
('Shinichirō Watanabe', '1965-05-24', 1),
('Yoko Kanno', '1964-03-18', 1),
('Gen Urobuchi', '1972-12-20', 1),
('Yoshiyuki Tomino', '1941-11-05', 1);

--

-- Insert data into table AuthorRoles
INSERT INTO AuthorRoles (role_id, author_id, anime_id) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(1, 5, 5),
(1, 6, 6),
(1, 7, 7),
(3, 8, 8),
(2, 9, 9),
(1, 10, 10),
(1, 1, 11),
(1, 2, 12),
(1, 3, 13),
(1, 4, 14),
(1, 5, 15),
(1, 6, 16),
(1, 7, 17),
(3, 8, 18),
(2, 9, 19),
(1, 10, 20),
(5, 4, 1);

--

-- Insert data into table Episode
INSERT INTO Episode (episode_title, episode_number, episode_air_date, anime_id) VALUES
('Enter: Naruto Uzumaki!', 1, '2002-10-03', 1),
('My Name is Konohamaru!', 2, '2002-10-10', 1),
('Sasuke and Sakura: Friends or Foes?', 3, '2002-10-17', 1),
('Survival Exercise: The Super Secret Scroll', 1, '1999-10-20', 2),
('The Man in the Straw Hat', 2, '1999-10-27', 2),
('Tell No Tales', 3, '1999-11-03', 2),
('To You, in 2000 Years: The Fall of Shiganshina, Part 1', 1, '2013-04-07', 3),
('That Day: The Fall of Shiganshina, Part 2', 2, '2013-04-14', 3),
('A Dim Light Amid Despair: Humanity\'s Comeback, Part 1', 3, '2013-04-21', 3),
('Rebirth', 1, '2006-10-04', 4),
('Confrontation', 2, '2006-10-11', 4),
('Dealings', 3, '2006-10-18', 4),
('Izuku Midoriya: Origin', 1, '2016-04-03', 5),
('What It Takes to Be a Hero', 2, '2016-04-10', 5),
('Roaring Muscles', 3, '2016-04-17', 5),
('Cruelty', 1, '2019-04-06', 6),
('Trainer Sakonji Urokodaki', 2, '2019-04-13', 6),
('Sabito and Makomo', 3, '2019-04-20', 6),
('Fullmetal Alchemist', 1, '2009-04-05', 7),
('The First Day', 2, '2009-04-12', 7),
('City of Heresy', 3, '2009-04-19', 7),
('The New Threat', 1, '1989-04-26', 8),
('Reunions', 2, '1989-05-03', 8),
('Unlikely Alliance', 3, '1989-05-10', 8),
('The World of Swords', 1, '2012-07-08', 9),
('Beater', 2, '2012-07-15', 9),
('Red-Nosed Reindeer', 3, '2012-07-22', 9),
('Tragedy', 1, '2014-07-04', 10),
('Incubation', 2, '2014-07-11', 10),
('Dove', 3, '2014-07-18', 10);

--

-- Insert data into table User
INSERT INTO User (user_name, user_email, user_password, country_id) VALUES
('John Doe', 'johndoe@example.com', 'password123', 1),
('Jane Smith', 'janesmith@example.com', 'password123', 2),
('Alice Johnson', 'alicej@example.com', 'password123', 3),
('Bob Brown', 'bobb@example.com', 'password123', 4),
('Charlie Davis', 'charlied@example.com', 'password123', 5),
('Daniel Evans', 'danielevans@example.com', 'password123', 6),
('Eva Green', 'evagreen@example.com', 'password123', 7),
('Frank Harris', 'frankharris@example.com', 'password123', 8),
('Grace Ingram', 'graceingram@example.com', 'password123', 9),
('Henry Jackson', 'henryjackson@example.com', 'password123', 10),
('Ivy King', 'ivyking@example.com', 'password123', 1),
('Jack Lee', 'jacklee@example.com', 'password123', 2),
('Katie Miller', 'katiemiller@example.com', 'password123', 3),
('Liam Nelson', 'liamnelson@example.com', 'password123', 4),
('Mia Owens', 'miaowens@example.com', 'password123', 5),
('Noah Perry', 'noahperry@example.com', 'password123', 6),
('Olivia Quinn', 'oliviaquinn@example.com', 'password123', 7),
('Paul Roberts', 'paulroberts@example.com', 'password123', 8),
('Quinn Stewart', 'quinnstewart@example.com', 'password123', 9),
('Rachel Thompson', 'rachelthompson@example.com', 'password123', 10);

--

-- Insert data into table EpisodeComments
INSERT INTO EpisodeComments (comment_content, user_id, episode_id) VALUES
('Great episode, really enjoyed the fight scene!', 1, 1),
('Great episode2, really enjoyed the fight scene!', 1, 1),
('Great episode3, really enjoyed the fight scene!', 1, 1),
('The plot twist at the end was unexpected!', 2, 2),
('I love the character development in this episode.', 3, 3),
('Amazing animation quality!', 4, 4),
('The soundtrack in this episode is phenomenal.', 5, 5),
('I didn\'t like the pacing of this episode.', 6, 6),
('The cliffhanger ending has me excited for the next episode.', 7, 7),
('The dialogue was very well-written.', 8, 8),
('This episode was a bit slow for my taste.', 9, 9),
('Fantastic world-building in this episode.', 10, 10),
('I have mixed feelings about the new character introduction.', 1, 11),
('The fight choreography was top-notch!', 2, 12),
('I appreciate the subtle foreshadowing.', 3, 13),
('The emotional scenes were very touching.', 4, 14),
('Great episode, can\'t wait for the next one!', 5, 15),
('The humor in this episode was spot on.', 6, 16),
('I was on the edge of my seat the entire time.', 7, 17),
('The plot is starting to get really interesting.', 8, 18),
('I didn\'t expect that character to return.', 9, 19),
('This episode answered a lot of my questions.', 10, 20);

--

-- Insert data into table Review
INSERT INTO Review (review_content, review_rating, user_id, anime_id) VALUES
('Absolutely amazing series! The plot is fantastic and the characters are well developed.', 9.5, 1, 1),
('Great story and animation. However, some episodes felt a bit slow.', 8.7, 2, 2),
('One of the best animes I have ever watched. Highly recommend!', 9.8, 3, 3),
('Very intriguing and thought-provoking. Keeps you on the edge of your seat.', 9.2, 4, 4),
('Fantastic animation and action sequences, but the plot could be tighter.', 8.5, 5, 5),
('A must-watch for any anime fan. The world-building is exceptional.', 9.4, 6, 6),
('Good character development and plot, but the ending was a bit disappointing.', 8.3, 7, 7),
('Brilliant series with a unique storyline. Loved every moment.', 9.6, 8, 8),
('Interesting concept, but the pacing was off.', 7.8, 9, 9),
('A solid anime with great characters and story. A few episodes were a bit filler.', 8.9, 10, 10),
('Excellent series with a lot of heart. Highly recommended!', 9.7, 1, 11),
('Great animation and story, but some characters were underdeveloped.', 8.6, 2, 12),
('A wonderful series that I thoroughly enjoyed from start to finish.', 9.3, 3, 13),
('The emotional depth in this series is incredible. A must-watch.', 9.5, 4, 14),
('Fun and engaging series with a lot of action and humor.', 8.8, 5, 15),
('A unique and captivating series. Very well done.', 9.1, 6, 16),
('Some episodes felt like filler, but overall a great series.', 8.4, 7, 17),
('The animation quality is top-notch. Story is engaging.', 9.0, 8, 18),
('Great series with a lot of potential. Looking forward to the next season.', 8.7, 9, 19),
('An excellent series that keeps you hooked till the end.', 9.2, 10, 20);

--

-- Insert data into table UserFavorites
INSERT INTO UserFavorites (user_id, anime_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(2, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 10),
(4, 11),
(4, 12),
(5, 13),
(5, 14),
(5, 15),
(6, 16),
(6, 17),
(6, 18),
(7, 19),
(7, 20);

-- -----------------------------------------------------
-- Creación de FUNCIONES.
-- -----------------------------------------------------

-- Create function GetNumberOfEpisodes
DELIMITER //

CREATE FUNCTION GetNumberOfEpisodes(anime_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE episode_count INT;

    SELECT COUNT(episode_id)
    INTO episode_count
    FROM Episode
    WHERE Episode.anime_id = anime_id;

    RETURN episode_count;
END //

DELIMITER ;

--

-- Create function GetAverageRating
DELIMITER $$

CREATE FUNCTION GetAverageRating(animeId INT)
RETURNS DECIMAL(2, 1)
DETERMINISTIC
BEGIN
    DECLARE avgRating DECIMAL(2, 1);

    SELECT AVG(review_rating) INTO avgRating
    FROM Review
    WHERE anime_id = animeId;

    RETURN avgRating;
END $$

DELIMITER ;

--

-- Create function GetFavoriteAnimes
DELIMITER $$

CREATE FUNCTION GetFavoriteAnimes(userId INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE favoriteAnimes TEXT;

    SELECT GROUP_CONCAT(a.anime_title ORDER BY a.anime_title SEPARATOR ', ') INTO favoriteAnimes
    FROM UserFavorites uf
    JOIN Anime a ON uf.anime_id = a.anime_id
    WHERE uf.user_id = userId;

    RETURN favoriteAnimes;
END $$

DELIMITER ;

--

-- Create function GetRecentComments
DELIMITER $$

CREATE FUNCTION GetRecentComments(episodeId INT, limitCount INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE recentComments TEXT;

    SELECT GROUP_CONCAT(comment_content ORDER BY comment_date DESC SEPARATOR '; ') INTO recentComments
    FROM (
        SELECT ec.comment_content, ec.comment_date
        FROM EpisodeComments ec
        WHERE ec.episode_id = episodeId
        ORDER BY ec.comment_date DESC
        LIMIT limitCount
    ) AS limited_comments;

    RETURN recentComments;
END $$

DELIMITER ;

--

-- Create function GetCountryWithMostUsers
DELIMITER //

CREATE FUNCTION GetCountryWithMostUsers()
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE countryName VARCHAR(255);

    SELECT c.country_name
    INTO countryName
    FROM Country c
    JOIN User u ON c.country_id = u.country_id
    GROUP BY c.country_name
    ORDER BY COUNT(u.user_id) DESC
    LIMIT 1;

    RETURN countryName;
END //

DELIMITER ;

-- -----------------------------------------------------
-- Creación de STORED PROCEDURES.
-- -----------------------------------------------------

-- Create SP AddAuthorToAnime
DELIMITER //

CREATE PROCEDURE AddAuthorToAnime(
    IN p_anime_id INT,
    IN p_author_id INT,
    IN p_role_id INT
)
BEGIN
    -- Insertar un nuevo autor con un rol específico para el anime en la tabla AuthorRoles
    INSERT INTO AuthorRoles (anime_id, author_id, role_id)
    VALUES (p_anime_id, p_author_id, p_role_id);
END //

DELIMITER ;

--

-- Create SP AssignGenreToAnime
DELIMITER //

CREATE PROCEDURE AssignGenreToAnime(
    IN p_anime_id INT,
    IN p_genre_id INT
)
BEGIN
    -- Verificar si el anime y el género existen
    DECLARE anime_exists INT;
    DECLARE genre_exists INT;

    SELECT COUNT(*) INTO anime_exists FROM Anime WHERE anime_id = p_anime_id;
    SELECT COUNT(*) INTO genre_exists FROM Genre WHERE genre_id = p_genre_id;

    -- Si el anime o el género no existen, lanzar un error
    IF anime_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El anime especificado no existe';
    ELSEIF genre_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El género especificado no existe';
    ELSE
        -- Insertar la relación en la tabla AnimeGenres
        INSERT INTO AnimeGenres (anime_id, genre_id) VALUES (p_anime_id, p_genre_id);
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------
-- Creación de TRIGGERS.
-- -----------------------------------------------------

-- Create Trigger episodeDateConsistencyInsert
DELIMITER //

CREATE TRIGGER episodeDateConsistencyInsert
BEFORE INSERT ON Episode
FOR EACH ROW
BEGIN
    DECLARE invalid_episode INT;
    SET invalid_episode = 0;

    -- Verificar si hay algún episodio con un número menor y una fecha mayor o un número mayor y una fecha menor
    SELECT COUNT(*) INTO invalid_episode
    FROM Episode
    WHERE anime_id = NEW.anime_id
    AND (
        (episode_number < NEW.episode_number AND episode_air_date > NEW.episode_air_date)
        OR
        (episode_number > NEW.episode_number AND episode_air_date < NEW.episode_air_date)
    );

    -- Si se encuentra algún episodio inválido, lanzar un error
    IF invalid_episode > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de emisión de un episodio no puede ser inconsistente con la numeración de episodios.';
    END IF;
END //

DELIMITER ;

--

-- Create Trigger episodeDateConsistencyUpdate
DELIMITER //

CREATE TRIGGER episodeDateConsistencyUpdate
BEFORE UPDATE ON Episode
FOR EACH ROW
BEGIN
    DECLARE invalid_episode INT;
    SET invalid_episode = 0;

    -- Verificar si hay algún episodio con un número menor y una fecha mayor o un número mayor y una fecha menor
    SELECT COUNT(*) INTO invalid_episode
    FROM Episode
    WHERE anime_id = NEW.anime_id
    AND (
        (episode_number < NEW.episode_number AND episode_air_date > NEW.episode_air_date)
        OR
        (episode_number > NEW.episode_number AND episode_air_date < NEW.episode_air_date)
    );

    -- Si se encuentra algún episodio inválido, lanzar un error
    IF invalid_episode > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de emisión de un episodio no puede ser inconsistente con la numeración de episodios.';
    END IF;
END //

DELIMITER ;

--

-- Create trigger animeChangeHistory
DELIMITER //

CREATE TRIGGER animeChangeHistory
AFTER UPDATE ON Anime
FOR EACH ROW
BEGIN
    INSERT INTO AnimeHistory (
        anime_id,
        old_anime_title,
        new_anime_title,
        old_anime_synopsis,
        new_anime_synopsis,
        old_anime_status_id,
        new_anime_status_id
    )
    VALUES (
        OLD.anime_id,
        OLD.anime_title,
        NEW.anime_title,
        OLD.anime_synopsis,
        NEW.anime_synopsis,
        OLD.anime_status_id,
        NEW.anime_status_id
    );
END //

DELIMITER ;

--

-- Create trigger notifyNewEpisode
DELIMITER //

CREATE TRIGGER notifyNewEpisode
AFTER INSERT ON Episode
FOR EACH ROW
BEGIN
    DECLARE user_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT uf.user_id
        FROM UserFavorites uf
        WHERE uf.anime_id = NEW.anime_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO Notifications (user_id, message)
        VALUES (user_id, CONCAT('A new episode of your favorite anime has been published: ', NEW.episode_title));
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

-- -----------------------------------------------------
-- Creación de VISTAS.
-- -----------------------------------------------------

-- Create view ComprehensiveAnimeView
CREATE VIEW ComprehensiveAnimeView AS
SELECT
    a.anime_id as Id,
    a.anime_title as Title,
    (SELECT MIN(e.episode_air_date) FROM Episode e WHERE e.anime_id = a.anime_id) AS Release_Date,
    a.anime_synopsis as Synopsis,
    ast.status_name AS Status,
    GROUP_CONCAT(DISTINCT g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS Genres,
    GROUP_CONCAT(DISTINCT CONCAT(au.author_name, ' (', rt.role_name, ', ', c.country_name, ')') SEPARATOR ', ') AS authors,
    GetNumberOfEpisodes(a.anime_id) AS Episodes,
    (SELECT COUNT(ec.comment_id) FROM EpisodeComments ec JOIN Episode e ON ec.episode_id = e.episode_id WHERE e.anime_id = a.anime_id) AS Comments,
    (SELECT COUNT(uf.anime_id) FROM UserFavorites uf WHERE uf.anime_id = a.anime_id) AS Favorites,
    GetAverageRating(a.anime_id) AS Rating
FROM
    Anime a
    LEFT JOIN AnimeGenres ag ON a.anime_id = ag.anime_id
    LEFT JOIN Genre g ON ag.genre_id = g.genre_id
    LEFT JOIN AuthorRoles ar ON a.anime_id = ar.anime_id
    LEFT JOIN Author au ON ar.author_id = au.author_id
    LEFT JOIN AuthorRoleTypes rt ON ar.role_id = rt.role_id
    LEFT JOIN Country c ON au.author_country_id = c.country_id
    LEFT JOIN AnimeStatus ast ON a.anime_status_id = ast.status_id
GROUP BY
    a.anime_id,
    a.anime_title,
    a.anime_synopsis,
    ast.status_name;

--

-- Create view UserFavoriteAnimes
CREATE VIEW UserFavoriteAnimes AS
SELECT
    u.user_id AS UserId,
    u.user_name AS UserName,
    u.user_email AS UserEmail,
    GetFavoriteAnimes(u.user_id) AS Favorites
FROM
    UserFavorites uf
    JOIN User u ON uf.user_id = u.user_id
    JOIN Anime a ON uf.anime_id = a.anime_id
GROUP BY
    u.user_id,
    u.user_name,
    u.user_email;

--

-- Create view UserCountryPercentage
CREATE VIEW UserCountryPercentage AS
SELECT
    c.country_name AS Country,
    COUNT(u.user_id) AS UserCount,
    (COUNT(u.user_id) / (SELECT COUNT(*) FROM User) * 100) AS UserPercentage
FROM
    User u
    LEFT JOIN Country c ON u.country_id = c.country_id
GROUP BY
    c.country_name
ORDER BY
    UserPercentage DESC;
