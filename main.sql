-- -----------------------------------------------------
-- Creación de la BASE.
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS AnimeManagement;
USE AnimeManagement;


-- -----------------------------------------------------
-- Creación de las TABLAS.
-- -----------------------------------------------------

-- Create table 3 AnimeStatus
CREATE TABLE AnimeStatus (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

--

-- Create table 1 Anime
CREATE TABLE Anime (
    anime_id INT PRIMARY KEY AUTO_INCREMENT,
    anime_title VARCHAR(255) NOT NULL,
    anime_release_date DATE,
    anime_synopsis TEXT,
    anime_episode_count INT CHECK (anime_episode_count >= 0),
    anime_status_id INT,
    anime_rating DECIMAL(2, 1) CHECK (anime_rating IS NULL OR (anime_rating >= 1 AND anime_rating <= 10)),
    FOREIGN KEY (anime_status_id) REFERENCES AnimeStatus(status_id),
    INDEX idx_anime_title (anime_title),
    INDEX idx_anime_rating (anime_rating)
);

--

-- Create table 9 Genre
CREATE TABLE Genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_genre_name (genre_name)
);

--

-- Create table 2 AnimeGenres
CREATE TABLE AnimeGenres (
    anime_id INT,
    genre_id INT,
    PRIMARY KEY (anime_id, genre_id),
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id),
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id),
    INDEX idx_animegenres_anime (anime_id),
    INDEX idx_animegenres_genre (genre_id)
);

--

-- Create table 6 Country
CREATE TABLE Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    INDEX idx_country_name (country_name)
);

--

-- Create table 4 Author
CREATE TABLE Author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(255) NOT NULL,
    author_birth_date DATE,
    author_country_id INT,
    FOREIGN KEY (author_country_id) REFERENCES Country(country_id) ON DELETE SET NULL,
    INDEX idx_author_name (author_name)
);

--

-- Create table 5 AuthorRoles
CREATE TABLE AuthorRoles (
    author_role_id INT PRIMARY KEY AUTO_INCREMENT,
    author_role_name VARCHAR(100) NOT NULL,
    author_id INT,
    anime_id INT,
    FOREIGN KEY (author_id) REFERENCES Author(author_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE,
    INDEX idx_author_role (author_role_name)
);

--

-- Create table 7 Episode
CREATE TABLE Episode (
    episode_id INT PRIMARY KEY AUTO_INCREMENT,
    episode_title VARCHAR(255) NOT NULL,
    episode_number INT NOT NULL CHECK (episode_number >= 0),
    episode_air_date DATE,
    anime_id INT,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE
);

--

-- Create table 11 User
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL,
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

-- Create table 8 EpisodeComments
CREATE TABLE EpisodeComments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    comment_content TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    episode_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (episode_id) REFERENCES Episode(episode_id) ON DELETE CASCADE,
    INDEX idx_comment_user (user_id),
    INDEX idx_comment_episode (episode_id)
);

--

-- Create table 10 Review
CREATE TABLE Review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    review_content TEXT,
    review_rating DECIMAL(2, 1) NOT NULL CHECK (rating >= 1 AND rating <= 10),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT,
    anime_id INT,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE,
    INDEX idx_review_user (user_id),
    INDEX idx_review_anime (anime_id)
);

--

-- Create table 12 UserFavorites
CREATE TABLE UserFavorites (
    user_id INT,
    anime_id INT,
    PRIMARY KEY (user_id, anime_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (anime_id) REFERENCES Anime(anime_id) ON DELETE CASCADE
);
